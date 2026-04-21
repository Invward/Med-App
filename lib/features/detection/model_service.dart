// lib/features/detection/model_service.dart
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelService {
  static Interpreter? _interpreter;
  static String _modelPath = 'assets/models/burn_model_float32.tflite';

  static const int inputSize = 224;
  static const int numChannels = 3;

  // ImageNet normalization constants
  static const List<double> _mean = [0.485, 0.456, 0.406];
  static const List<double> _std = [0.229, 0.224, 0.225];

  /// Canonical class labels based on the report: first_degree, no_burn, second_degree, third_degree
  static const List<String> _labels = [
    'first_degree',
    'no_burn',
    'second_degree',
    'third_degree',
  ];

  /// Human-readable labels and metadata
  static const Map<String, Map<String, String>> _metadataMap = {
    'no_burn': {
      'label': 'No Burn',
      'severity': 'None',
      'depth': 'N/A',
      'color': 'green',
      'description':
          'No burn detected. The skin appears healthy with no visible thermal, chemical, or radiation damage.',
    },
    'first_degree': {
      'label': '1st Degree Burn',
      'severity': 'Minor',
      'depth': 'Superficial',
      'color': 'yellow',
      'description':
          'Superficial burn affecting only the outer layer of skin (epidermis). Characterized by redness, minor swelling, and pain without blisters.',
    },
    'second_degree': {
      'label': '2nd Degree Burn',
      'severity': 'Moderate',
      'depth': 'Partial Thickness',
      'color': 'orange',
      'description':
          'Partial-thickness burn extending into the dermis. Characterized by blistering, significant redness, and intense pain.',
    },
    'third_degree': {
      'label': '3rd Degree Burn',
      'severity': 'Severe',
      'depth': 'Full Thickness',
      'color': 'red',
      'description':
          'Full-thickness burn destroying both epidermis and dermis layers. Skin may appear white, brown, or charred. Requires immediate medical intervention.',
    },
  };

  // ─── Public API ────────────────────────────────────────────────────────────

  static Future<void> loadModel() async {
    try {
      _interpreter ??= await Interpreter.fromAsset(_modelPath);
      debugPrint('Model loaded successfully: $_modelPath');
    } catch (e) {
      debugPrint('Failed to load model: $e');
      rethrow;
    }
  }

  static String get currentModelPath => _modelPath;

  static Future<void> setModelPath(String modelPath) async {
    if (_modelPath == modelPath && _interpreter != null) return;
    dispose();
    _modelPath = modelPath;
    await loadModel();
  }

  /// Run inference on [imageFile].
  static Future<Map<String, dynamic>> runInference(File imageFile) async {
    if (_interpreter == null) {
      await loadModel();
    }

    // 1. Load & decode image
    final rawBytes = await imageFile.readAsBytes();
    img.Image? decoded = img.decodeImage(rawBytes);
    if (decoded == null) throw Exception('Failed to decode image');

    // 2. Normalize orientation and resize
    decoded = img.bakeOrientation(decoded);
    final resized = img.copyResize(
      decoded,
      width: inputSize,
      height: inputSize,
    );

    // 3. Preprocess with ImageNet normalization
    final input = _imageToFloat32List(resized);

    // 4. Prepare output tensor [1, 4]
    final output = List.filled(1 * 4, 0.0).reshape([1, 4]);

    // 5. Run inference
    _interpreter!.run(input, output);

    // 6. Post-process
    final rawLogits = (output[0] as List).cast<double>();
    final scores =
        _softmax(rawLogits); // Convert logits -> probabilities (0.0-1.0)

    debugPrint(
        'Raw logits: ${rawLogits.map((v) => v.toStringAsFixed(4)).join(', ')}');
    debugPrint(
        'Softmax probs: ${scores.map((v) => v.toStringAsFixed(4)).join(', ')}');

    final classIndex = _argmax(scores);
    final confidence = scores[classIndex];
    final rawLabel = _labels[classIndex];

    return _buildResult(rawLabel, confidence, scores);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static List<List<List<List<double>>>> _imageToFloat32List(img.Image image) {
    return List.generate(1, (_) {
      return List.generate(inputSize, (y) {
        return List.generate(inputSize, (x) {
          final pixel = image.getPixel(x, y);
          // ImageNet normalization: (x/255.0 - mean) / std
          return [
            (pixel.r / 255.0 - _mean[0]) / _std[0],
            (pixel.g / 255.0 - _mean[1]) / _std[1],
            (pixel.b / 255.0 - _mean[2]) / _std[2],
          ];
        });
      });
    });
  }

  static int _argmax(List<double> scores) {
    int maxIdx = 0;
    double maxVal = scores[0];
    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > maxVal) {
        maxVal = scores[i];
        maxIdx = i;
      }
    }
    return maxIdx;
  }

  /// Convert raw logits to probabilities via softmax.
  /// Uses the max-subtraction trick for numerical stability.
  static List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce((a, b) => a > b ? a : b);
    final exps = logits.map((v) => math.exp(v - maxLogit)).toList();
    final sum = exps.reduce((a, b) => a + b);
    if (sum == 0)
      return List<double>.filled(logits.length, 1.0 / logits.length);
    return exps.map((v) => v / sum).toList();
  }

  static Map<String, dynamic> _buildResult(
    String rawLabel,
    double confidence,
    List<double> scores,
  ) {
    final meta = _metadataMap[rawLabel] ?? _metadataMap['no_burn']!;

    final label = meta['label']!;
    final needsHospital =
        label == '2nd Degree Burn' || label == '3rd Degree Burn';

    final infectionRisk = switch (label) {
      'No Burn' => 'None',
      '1st Degree Burn' => 'Low',
      '2nd Degree Burn' => 'Moderate',
      '3rd Degree Burn' => 'High',
      _ => 'Unknown',
    };

    final degree = switch (label) {
      'No Burn' => 0,
      '1st Degree Burn' => 1,
      '2nd Degree Burn' => 2,
      '3rd Degree Burn' => 3,
      _ => 0,
    };

    return {
      'degree': degree,
      'label': label,
      'confidence': confidence,
      'scores': {
        for (int i = 0; i < _labels.length; i++) _labels[i]: scores[i],
      },
      'severity': meta['severity']!,
      'depth': meta['depth']!,
      'color': meta['color']!,
      'description': meta['description']!,
      'needsHospital': needsHospital,
      'infectionRisk': infectionRisk,
      'cause': 'Thermal',
      'modelPath': _modelPath,
      'rawLabel': rawLabel,
    };
  }

  static void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
