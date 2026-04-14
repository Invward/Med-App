// lib/features/detection/model_service.dart
import 'dart:io';
import 'dart:math' as math;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelService {
  static Interpreter? _interpreter;
  static const String modelPath = 'assets/models/model_ver2.tflite';

  /// Default input dimensions expected by model_ver2.tflite.
  /// Actual size is read from model input tensor at runtime.
  static const int defaultInputSize = 224;
  static const int numChannels = 3;
  static const double _softmaxEpsilon = 1e-3;
  static int _runtimeInputSize = defaultInputSize;
  static int _runtimeNumClasses = 3;

  /// Canonical class labels used across known model variants.
  static const List<String> _labels3 = [
    '1st Degree Burn',
    '2nd Degree Burn',
    '3rd Degree Burn',
  ];
  static const List<String> _labels4 = [
    'Normal Skin',
    '1st Degree Burn',
    '2nd Degree Burn',
    '3rd Degree Burn',
  ];

  /// Human-readable severity metadata per class index.
  static const List<Map<String, String>> _metadata = [
    {
      'label': 'Normal Skin',
      'severity': 'None',
      'depth': 'N/A',
      'color': 'green',
      'description':
          'No burn detected. The skin appears healthy with no visible thermal, chemical, or radiation damage.',
    },
    {
      'label': '1st Degree Burn',
      'severity': 'Minor',
      'depth': 'Superficial',
      'color': 'yellow',
      'description':
          'Superficial burn affecting only the outer layer of skin (epidermis). Characterized by redness, minor swelling, and pain without blisters.',
    },
    {
      'label': '2nd Degree Burn',
      'severity': 'Moderate',
      'depth': 'Partial Thickness',
      'color': 'orange',
      'description':
          'Partial-thickness burn extending into the dermis. Characterized by blistering, significant redness, and intense pain. Requires careful moisture management and infection protection.',
    },
    {
      'label': '3rd Degree Burn',
      'severity': 'Severe',
      'depth': 'Full Thickness',
      'color': 'red',
      'description':
          'Full-thickness burn destroying both epidermis and dermis layers. Skin may appear white, brown, or charred. Requires immediate professional medical intervention.',
    },
  ];

  // ─── Public API ────────────────────────────────────────────────────────────

  /// Load the TFLite model from assets. Call once at app startup.
  static Future<void> loadModel() async {
    _interpreter ??= await Interpreter.fromAsset(modelPath);
    _validateModelContract();
  }

  /// Run inference on [imageFile]. Returns a result map containing:
  /// - `degree` (int): 0–3
  /// - `label` (String): e.g. "2nd Degree Burn"
  /// - `confidence` (double): 0.0–1.0
  /// - `severity` (String)
  /// - `depth` (String)
  /// - `description` (String)
  /// - `needsHospital` (bool)
  /// - `infectionRisk` (String)
  static Future<Map<String, dynamic>> runInference(File imageFile) async {
    if (_interpreter == null) {
      await loadModel();
    }
    _validateModelContract();

    // 1. Load & decode image
    final rawBytes = await imageFile.readAsBytes();
    img.Image? decoded = img.decodeImage(rawBytes);
    if (decoded == null) throw Exception('Failed to decode image');

    // 2. Normalize orientation, center-crop square, then resize to model input.
    decoded = img.bakeOrientation(decoded);
    final cropped = _centerCropSquare(decoded);
    final resized = img.copyResize(
      cropped,
      width: _runtimeInputSize,
      height: _runtimeInputSize,
    );

    // 3. Convert to float32 tensor in RGB order with raw 0..255 values.
    final input = _imageToFloat32List(resized);

    // 4. Prepare output tensor  (shape: [1, numClasses])
    final output = List.filled(_runtimeNumClasses, 0.0)
        .reshape([1, _runtimeNumClasses]);

    // 5. Run inference
    _interpreter!.run(input, output);

    // 6. Parse output
    final rawScores = (output[0] as List).map((e) => (e as num).toDouble()).toList();
    final scores = _normalizeScores(rawScores);
    final classIndex = _argmax(scores);
    final confidence = scores[classIndex];

    return _buildResult(classIndex, confidence);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static List<List<List<List<double>>>> _imageToFloat32List(img.Image image) {
    return List.generate(1, (_) {
      return List.generate(_runtimeInputSize, (y) {
        return List.generate(_runtimeInputSize, (x) {
          final pixel = image.getPixel(x, y);
          return [
            pixel.r.toDouble(),
            pixel.g.toDouble(),
            pixel.b.toDouble(),
          ];
        });
      });
    });
  }

  static img.Image _centerCropSquare(img.Image source) {
    final side = source.width < source.height ? source.width : source.height;
    final left = (source.width - side) ~/ 2;
    final top = (source.height - side) ~/ 2;
    return img.copyCrop(source, x: left, y: top, width: side, height: side);
  }

  static List<double> _normalizeScores(List<double> values) {
    if (values.isEmpty) return values;
    final total = values.reduce((a, b) => a + b);
    final hasNegative = values.any((v) => v < 0);
    final alreadyProbabilities =
        !hasNegative && (total - 1.0).abs() <= _softmaxEpsilon;
    return alreadyProbabilities ? values : _softmax(values);
  }

  static List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce((a, b) => a > b ? a : b);
    final exps = logits.map((v) => math.exp(v - maxLogit)).toList();
    final sum = exps.reduce((a, b) => a + b);
    if (sum == 0) return List<double>.filled(logits.length, 0.0);
    return exps.map((v) => v / sum).toList();
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

  static Map<String, dynamic> _buildResult(int classIndex, double confidence) {
    final labels = _labelsForClasses(_runtimeNumClasses);
    final label = labels[classIndex];
    final meta =
        _metadata.firstWhere((m) => m['label'] == label, orElse: () => _metadata.last);

    // Hospitalization logic based on degree
    final needsHospital = label == '2nd Degree Burn' || label == '3rd Degree Burn';

    // Infection risk based on degree
    final infectionRisk = switch (label) {
      'Normal Skin' => 'None',
      '1st Degree Burn' => 'Low',
      '2nd Degree Burn' => 'Moderate',
      '3rd Degree Burn' => 'High',
      _ => 'Unknown',
    };

    final degree = switch (label) {
      'Normal Skin' => 0,
      '1st Degree Burn' => 1,
      '2nd Degree Burn' => 2,
      '3rd Degree Burn' => 3,
      _ => classIndex,
    };

    return {
      'degree': degree,
      'label': meta['label']!,
      'confidence': confidence,
      'severity': meta['severity']!,
      'depth': meta['depth']!,
      'color': meta['color']!,
      'description': meta['description']!,
      'needsHospital': needsHospital,
      'infectionRisk': infectionRisk,
      'cause': 'Thermal', // default; can be extended with multi-label model
    };
  }

  static void _validateModelContract() {
    final interpreter = _interpreter;
    if (interpreter == null) {
      throw StateError('Interpreter is not initialized.');
    }

    final inputTensor = interpreter.getInputTensor(0);
    final inputShape = inputTensor.shape;
    final inputType = inputTensor.type;
    final validShape = inputShape.length == 4 &&
        inputShape[0] == 1 &&
        inputShape[1] > 0 &&
        inputShape[2] > 0 &&
        inputShape[3] == numChannels;
    if (!validShape) {
      throw StateError(
        'Unexpected input tensor. Expected [1,H,W,3], got '
        '${inputShape.toString()} $inputType',
      );
    }
    _runtimeInputSize = inputShape[1];

    final outputTensor = interpreter.getOutputTensor(0);
    final outputShape = outputTensor.shape;
    final outputType = outputTensor.type;
    final outputClasses = outputShape.isNotEmpty ? outputShape.last : 0;
    final validOutputType =
        outputType == TensorType.float32 || outputType == TensorType.uint8;
    final validClasses = outputClasses == 3 || outputClasses == 4;
    if (!validOutputType || !validClasses) {
      throw StateError(
        'Unexpected output tensor. Expected float32/uint8 with 3 or 4 '
        'classes, got ${outputShape.toString()} $outputType',
      );
    }
    _runtimeNumClasses = outputClasses;
  }

  static List<String> _labelsForClasses(int classes) {
    if (classes == 4) return _labels4;
    return _labels3;
  }

  /// Dispose the interpreter when done (optional, call in app teardown).
  static void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
