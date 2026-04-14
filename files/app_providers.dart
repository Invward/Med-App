// lib/core/providers/app_providers.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../../features/detection/model_service.dart';

// ─── Inference State ────────────────────────────────────────────────────────

enum InferenceStatus { idle, running, done, error }

class InferenceState {
  final InferenceStatus status;
  final Map<String, dynamic>? result;
  final String? error;
  final File? imageFile;

  const InferenceState({
    this.status = InferenceStatus.idle,
    this.result,
    this.error,
    this.imageFile,
  });

  InferenceState copyWith({
    InferenceStatus? status,
    Map<String, dynamic>? result,
    String? error,
    File? imageFile,
  }) {
    return InferenceState(
      status: status ?? this.status,
      result: result ?? this.result,
      error: error ?? this.error,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}

class InferenceNotifier extends StateNotifier<InferenceState> {
  InferenceNotifier() : super(const InferenceState());

  Future<void> analyze(File imageFile) async {
    state = InferenceState(
      status: InferenceStatus.running,
      imageFile: imageFile,
    );
    try {
      final result = await ModelService.runInference(imageFile);
      state = state.copyWith(
        status: InferenceStatus.done,
        result: result,
      );
      // Save to history
      await _saveToHistory(imageFile, result);
    } catch (e) {
      state = state.copyWith(
        status: InferenceStatus.error,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = const InferenceState();
  }

  Future<void> _saveToHistory(
      File imageFile, Map<String, dynamic> result) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final historyFile = File('${dir.path}/history.json');
      List<dynamic> history = [];
      if (await historyFile.exists()) {
        final content = await historyFile.readAsString();
        history = jsonDecode(content) as List<dynamic>;
      }
      history.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'imagePath': imageFile.path,
        'result': result,
        'timestamp': DateTime.now().toIso8601String(),
      });
      // Keep last 50 entries
      if (history.length > 50) history = history.sublist(0, 50);
      await historyFile.writeAsString(jsonEncode(history));
    } catch (_) {}
  }
}

final inferenceProvider =
    StateNotifierProvider<InferenceNotifier, InferenceState>(
  (ref) => InferenceNotifier(),
);

// ─── History ────────────────────────────────────────────────────────────────

final historyProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final historyFile = File('${dir.path}/history.json');
    if (!await historyFile.exists()) return [];
    final content = await historyFile.readAsString();
    final list = jsonDecode(content) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  } catch (_) {
    return [];
  }
});

// ─── Model loading ──────────────────────────────────────────────────────────

final modelLoadedProvider = FutureProvider<bool>((ref) async {
  try {
    await ModelService.loadModel();
    return true;
  } catch (e) {
    return false;
  }
});

// ─── Settings ───────────────────────────────────────────────────────────────

class SettingsState {
  final bool notificationsEnabled;
  final bool shareBurnReport;

  const SettingsState({
    this.notificationsEnabled = true,
    this.shareBurnReport = true,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? shareBurnReport,
  }) {
    return SettingsState(
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      shareBurnReport: shareBurnReport ?? this.shareBurnReport,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void toggleNotifications() {
    state = state.copyWith(
        notificationsEnabled: !state.notificationsEnabled);
  }

  void toggleShareReport() {
    state = state.copyWith(shareBurnReport: !state.shareBurnReport);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
