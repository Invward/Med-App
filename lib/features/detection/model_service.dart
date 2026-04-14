// lib/features/detection/model_service.dart
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelService {
  static Interpreter? _interpreter;
  static const String modelPath = 'assets/models/model_ver2.tflite';

  /// Input dimensions expected by model_ver2.tflite
  /// Adjust [inputSize] if your model uses a different resolution.
  static const int inputSize = 224;
  static const int numChannels = 3;

  /// Class labels — must match training order
  static const List<String> labels = [
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
    assert(_interpreter != null,
        'ModelService.loadModel() must be called before runInference()');

    // 1. Load & decode image
    final rawBytes = await imageFile.readAsBytes();
    img.Image? decoded = img.decodeImage(rawBytes);
    if (decoded == null) throw Exception('Failed to decode image');

    // 2. Resize to model input size
    final resized =
        img.copyResize(decoded, width: inputSize, height: inputSize);

    // 3. Normalise pixels to [0, 1] and build input tensor
    final input = _imageToFloat32List(resized);

    // 4. Prepare output tensor  (shape: [1, numClasses])
    final output = List.filled(1 * labels.length, 0.0)
        .reshape([1, labels.length]);

    // 5. Run inference
    _interpreter!.run(input, output);

    // 6. Parse output
    final scores = (output[0] as List).cast<double>();
    final classIndex = _argmax(scores);
    final confidence = scores[classIndex];

    return _buildResult(classIndex, confidence);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static List<List<List<List<double>>>> _imageToFloat32List(img.Image image) {
    return List.generate(1, (_) {
      return List.generate(inputSize, (y) {
        return List.generate(inputSize, (x) {
          final pixel = image.getPixel(x, y);
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
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

  static Map<String, dynamic> _buildResult(int classIndex, double confidence) {
    final meta = _metadata[classIndex];

    // Hospitalization logic based on degree
    final needsHospital = classIndex >= 2;

    // Infection risk based on degree
    String infectionRisk;
    switch (classIndex) {
      case 0:
        infectionRisk = 'None';
        break;
      case 1:
        infectionRisk = 'Low';
        break;
      case 2:
        infectionRisk = 'Moderate';
        break;
      case 3:
        infectionRisk = 'High';
        break;
      default:
        infectionRisk = 'Unknown';
    }

    return {
      'degree': classIndex,
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

  /// Dispose the interpreter when done (optional, call in app teardown).
  static void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
