import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/state/kyc_prompt_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioPromptData {
  final String audioPath;
  final List<double> waveformData;
  final String duration;

  AudioPromptData({
    required this.audioPath,
    required this.waveformData,
    required this.duration,
  });
}

class KycPromptCubit extends Cubit<KycPromptState> {
  KycPromptCubit() : super(KycPromptInitial());

  final TextEditingController promptController = TextEditingController();
  final TextEditingController controller = TextEditingController();

  // Selected prompts (up to 4)
  final List<String> selectedPrompts = [];

  // Custom prompts created by user
  final List<String> customPrompts = [];

  // Prompt answers: Map<prompt, answer>
  // Answer can be text (String) or audio path (String starting with '/')
  final Map<String, String> promptAnswers = {};

  // Audio paths for prompts: Map<prompt, audioPath>
  final Map<String, String> promptAudioPaths = {};

  // Audio prompt data with waveform and duration: Map<prompt, AudioPromptData>
  final Map<String, AudioPromptData> audioPromptData = {};

  // Maximum allowed prompts
  static const int maxPrompts = 4;

  // Bottom sheet visibility
  bool _showBottomSheet = false;
  bool get showBottomSheet => _showBottomSheet;

  bool isAudioMode = false;

  // ==================== AUDIO CONTROLLERS (Owned by Cubit) ====================
  final RecorderController _recorderController = RecorderController();
  final PlayerController _playerController = PlayerController();

  // ==================== AUDIO STATE (Single Source of Truth) ====================
  String? recordingPath;
  bool isRecording = false;
  bool isRecordingPaused = false;
  bool isRecorded = false;
  bool isPlaying = false;
  List<double> recordedWaveformData = [];
  String recordedDuration = '00:00';

  // ==================== TIMER STATE (Owned by Cubit) ====================
  Timer? _recordTimer;
  Duration _recordingElapsed = Duration.zero;

  Duration get recordingElapsed => _recordingElapsed;

  // Expose controllers to widgets (but widgets should only read, not manipulate)
  RecorderController get recorderController => _recorderController;
  PlayerController get playerController => _playerController;
  StreamSubscription<Amplitude>? amplitudeSub;

  void toggleAudioMode() {
    emit(KycPromptLoading());
    isAudioMode = !isAudioMode;
    emit(KycPromptLoaded());
  }

  // reset recording state
  void resetRecording() {
    emit(KycPromptLoading());
    recordingPath = null;
    isRecording = false;
    isRecordingPaused = false;
    isRecorded = false;
    isPlaying = false;
    recordedWaveformData = [];
    recordedDuration = '00:00';
    _recordingElapsed = Duration.zero;
    emit(KycPromptLoaded());
  }

  // show recorded state
  void showRecordedState(
    String audioPath,
    List<double> waveformData,
    String duration,
  ) {
    emit(KycPromptLoading());
    recordingPath = audioPath;
    isRecording = false;
    isRecordingPaused = false;
    isRecorded = true;
    isPlaying = false;
    recordedWaveformData = waveformData;
    recordedDuration = duration;
    emit(KycPromptLoaded());
  }

  // ==================== RECORDING CONTROL ====================
  final record = AudioRecorder();

  /// Start recording a new audio prompt
  Future<void> startRecording() async {
    try {
      emit(KycPromptLoading());

      // Check permissions first
      final hasPermission = await record.hasPermission();
      if (!hasPermission) {
        log('Recording permission not granted');
        emit(KycPromptError());
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await record.start(
        RecordConfig(
          androidConfig: AndroidRecordConfig(
            audioManagerMode: AudioManagerMode.modeInCommunication,
            service: AndroidService(
              title: 'Fennec Audio Recording',
              content: "Recording audio for KYC prompt",
            ),
          ),
          noiseSuppress: true,
          encoder: AudioEncoder.wav,
          iosConfig: IosRecordConfig(
            categoryOptions: [
              IosAudioCategoryOption.allowBluetooth,
              IosAudioCategoryOption.defaultToSpeaker,
            ],
          ),
        ),
        path: path,
      );
      recordingPath = path;
      isRecording = true;
      isRecordingPaused = false;
      isRecorded = false;
      isPlaying = false;
      recordedWaveformData = [];
      recordedDuration = '00:00';
      _startWaveformStream();
      _startTimer();
      emit(KycPromptLoaded());
    } catch (e) {
      log('Error starting recording: $e');
      emit(KycPromptError());
      rethrow;
    }
  }

  void _startWaveformStream() {
    amplitudeSub?.cancel();

    amplitudeSub = record
        .onAmplitudeChanged(const Duration(milliseconds: 60))
        .listen((amp) {
          emit(KycPromptLoading());
          final barHeight = processWaveform(amp.current);
          recordedWaveformData.add(barHeight);

          // Keep buffer small (performance)
          if (recordedWaveformData.length > 120) {
            recordedWaveformData.removeAt(30);
          }

          // // Normalize amplitude for waveform (0–100)
          // final normalized = amp.current.clamp(-60, 0);
          // final waveValue = ((normalized + 60) / 60) * 100;
          // final simplifying = waveValue > 1.0 ? waveValue / 100.0 : waveValue;
          // final boosted = (simplifying * 1.25).clamp(0.0, 1.0);
          // final barHeight = (8 + (24 * boosted)).clamp(8.0, 32.h);
          // recordedWaveformData.add(barHeight);
          // // if (recordedWaveformData.length > 150) {
          // //   recordedWaveformData.removeAt(0);
          // // }
          debugPrint('Amplitude: ${amp.current}, WaveValue: $barHeight');
          emit(KycPromptLoaded());
        });
  }

  double _smoothedValue = 0.0;
  double _previousHeight = 0.0;

  double silenceThreshold = -55.0;
  double smoothingFactor = 0.2; // 0.1–0.3 (lower = smoother)
  double decayFactor = 0.85;

  double processWaveform(double ampDb) {
    // 1️⃣ Silence detection
    if (ampDb <= silenceThreshold) {
      _previousHeight *= decayFactor;
      return _previousHeight < 0.5 ? 0.0 : _previousHeight;
    }

    // 2️⃣ Normalize (-60 → 0 dB → 0 → 1)
    final normalized = ((ampDb.clamp(-60.0, 0.0) + 60) / 60);

    // 3️⃣ Smooth (EMA)
    _smoothedValue =
        (_smoothedValue * (1 - smoothingFactor)) +
        (normalized * smoothingFactor);

    // 4️⃣ Boost like WhatsApp
    final boosted = (_smoothedValue * 1.3).clamp(0.0, 1.0);

    // 5️⃣ Convert to height
    final targetHeight = 32.h * boosted;

    // 6️⃣ Decay animation (fast rise, slow fall)
    final height = targetHeight > _previousHeight
        ? targetHeight
        : _previousHeight * decayFactor;

    _previousHeight = height;
    return height;
  }

  /// Pause an active recording
  Future<void> pauseRecording() async {
    try {
      if (!isRecording || isRecordingPaused) return;
      emit(KycPromptLoading());
      await record.pause();
      amplitudeSub?.pause();
      isRecordingPaused = true;
      _recordTimer?.cancel();
      emit(KycPromptLoaded());
    } catch (e) {
      log('Error pausing recording: $e');
      emit(KycPromptError());
      rethrow;
    }
  }

  /// Resume a paused recording
  Future<void> resumeRecording() async {
    try {
      if (!isRecording || !isRecordingPaused) return;
      emit(KycPromptLoading());
      await record.resume();
      amplitudeSub?.resume();
      isRecordingPaused = false;
      _startTimer();
      emit(KycPromptLoaded());
    } catch (e) {
      log('Error resuming recording: $e');
      emit(KycPromptError());
      rethrow;
    }
  }

  /// Stop recording and finalize waveform data
  Future<void> stopRecording() async {
    try {
      log('Stopping recording...');
      emit(KycPromptLoading());

      final path = await record.stop();
      recordingPath = path ?? recordingPath;
      isRecording = false;
      isRecordingPaused = false;
      isRecorded = true;
      isPlaying = false;

      _stopTimer();
      amplitudeSub?.cancel();
      // Capture finalized waveform data from recorder
      _captureWaveformData();

      emit(KycPromptLoaded());
    } catch (e) {
      log('Error stopping recording: $e');
      emit(KycPromptError());
      rethrow;
    }
  }

  // ==================== PREVIEW CONTROL ====================

  /// Play the recorded audio
  Future<void> playPreview() async {
    try {
      emit(KycPromptLoading());
      if (recordingPath == null) {
        emit(KycPromptLoaded());
        return;
      }
      await _playerController.preparePlayer(path: recordingPath!);
      await _playerController.startPlayer();
      isPlaying = true;

      _playerController.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.stopped) {
          _onPlaybackStopped();
        }
      });
      emit(KycPromptLoaded());
    } catch (e) {
      log('Error playing preview: $e');
      emit(KycPromptError());
      rethrow;
    }
  }

  /// Pause playback
  Future<void> pausePreview() async {
    try {
      if (!isPlaying) return;
      emit(KycPromptLoading());
      await _playerController.pausePlayer();
      isPlaying = false;
      emit(KycPromptLoaded());
    } catch (e) {
      log('Error pausing preview: $e');
      emit(KycPromptError());
      rethrow;
    }
  }

  /// Stop playback
  Future<void> stopPreview() async {
    try {
      emit(KycPromptLoading());
      await _playerController.stopPlayer();
      isPlaying = false;
      emit(KycPromptLoaded());
    } catch (e) {
      log('Error stopping preview: $e');
      emit(KycPromptError());
      rethrow;
    }
  }

  // ==================== DELETE AUDIO ====================

  /// Delete recorded audio and reset all audio state
  void deleteAudio() {
    emit(KycPromptLoading());
    _resetAudioState();
    emit(KycPromptLoaded());
  }

  // ==================== PRIVATE HELPERS ====================

  /// Start the recording timer
  void _startTimer() {
    _recordTimer?.cancel();
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recordingElapsed += const Duration(seconds: 1);
      emit(KycPromptLoaded());
    });
  }

  /// Stop the recording timer
  void _stopTimer() {
    _recordTimer?.cancel();
  }

  /// Capture waveform data from the recorder controller
  void _captureWaveformData() {
    // if (_recorderController.waveData.isNotEmpty) {
    //   final maxAmplitude = _recorderController.waveData
    //       .reduce((a, b) => a > b ? a : b)
    //       .toDouble();
    //   recordedWaveformData = List<double>.from(
    //     _recorderController.waveData.map(
    //       (e) => maxAmplitude > 0 ? e / maxAmplitude : 0.0,
    //     ),
    //   );
    // } else {
    //   recordedWaveformData = List.generate(100, (i) {
    //     final t = i / 100.0;
    //     return (0.3 + 0.7 * (1 - (2 * t - 1).abs())) *
    //         (0.5 + 0.5 * (i % 3) / 3);
    //   });
    // }

    if (recordedWaveformData.length < 120) {
      final additionalSamples = 120 - recordedWaveformData.length;
      final firstValue = recordedWaveformData.isNotEmpty
          ? recordedWaveformData.first.clamp(1.0, double.infinity)
          : 1.0;

      recordedWaveformData.insertAll(
        0,
        List<double>.filled(additionalSamples, firstValue),
      );
    }

    // Update duration from timer
    final minutes = (_recordingElapsed.inSeconds ~/ 60).toString().padLeft(
      2,
      '0',
    );
    final seconds = (_recordingElapsed.inSeconds % 60).toString().padLeft(
      2,
      '0',
    );
    recordedDuration = '$minutes:$seconds';
  }

  /// Called when playback stops
  void _onPlaybackStopped() {
    isPlaying = false;
    emit(KycPromptLoaded());
  }

  /// Reset all audio-related state
  void _resetAudioState() {
    emit(KycPromptLoading());
    // Stop playback and recording
    record.stop();
    isPlaying = false;
    isRecording = false;
    isRecordingPaused = false;
    _stopTimer();
    _recordingElapsed = Duration.zero;

    // Delete audio file
    if (recordingPath != null) {
      try {
        final file = File(recordingPath!);
        if (file.existsSync()) {
          file.deleteSync();
        }
      } catch (e) {
        log('Error deleting audio file: $e');
      }
    }

    recordingPath = null;
    isRecorded = false;
    isPlaying = false;
    isRecording = false;
    isRecordingPaused = false;
    recordedWaveformData = [];
    recordedDuration = '00:00';
    emit(KycPromptLoaded());
  }

  // ==================== PROMPT MANAGEMENT ====================

  void showCreatePromptBottomSheet() {
    emit(KycPromptLoading());
    _showBottomSheet = true;
    emit(KycPromptLoaded());
  }

  void hideCreatePromptBottomSheet() {
    emit(KycPromptLoading());
    _showBottomSheet = false;
    emit(KycPromptLoaded());
  }

  void togglePromptSelection(String prompt) {
    emit(KycPromptLoading());
    if (selectedPrompts.contains(prompt)) {
      selectedPrompts.remove(prompt);
    } else {
      if (selectedPrompts.length < maxPrompts) {
        selectedPrompts.add(prompt);
      }
    }
    emit(KycPromptLoaded());
  }

  void addCustomPrompt(String prompt) {
    emit(KycPromptLoading());
    if (prompt.trim().isNotEmpty &&
        selectedPrompts.length < maxPrompts &&
        !selectedPrompts.contains(prompt.trim())) {
      customPrompts.add(prompt.trim());
      selectedPrompts.add(prompt.trim());
      _showBottomSheet = false;
      emit(KycPromptLoaded());
    }
  }

  void savePromptAnswer(
    String prompt,
    String answer, {
    String? audioPath,
    List<double>? waveformData,
    String? duration,
  }) {
    emit(KycPromptLoading());
    promptAnswers[prompt] = answer;
    if (audioPath != null) {
      promptAudioPaths[prompt] = audioPath;
      if (waveformData != null && duration != null) {
        audioPromptData[prompt] = AudioPromptData(
          audioPath: audioPath,
          waveformData: waveformData,
          duration: duration,
        );
      }
    } else {
      promptAudioPaths.remove(prompt);
      audioPromptData.remove(prompt);
    }
    if (!selectedPrompts.contains(prompt) &&
        selectedPrompts.length < maxPrompts) {
      selectedPrompts.add(prompt);
    }
    emit(KycPromptLoaded());
  }

  void editPromptAnswer(String prompt) {
    emit(KycPromptLoading());
    emit(KycPromptLoaded());
  }

  String? getPromptAnswer(String prompt) {
    return promptAnswers[prompt];
  }

  String? getPromptAudioPath(String prompt) {
    return promptAudioPaths[prompt];
  }

  bool hasPromptAnswer(String prompt) {
    return promptAnswers.containsKey(prompt);
  }

  bool isPromptAnswerAudio(String prompt) {
    return promptAudioPaths.containsKey(prompt);
  }

  void removePrompt(String prompt) {
    emit(KycPromptLoading());
    selectedPrompts.remove(prompt);
    customPrompts.remove(prompt);
    emit(KycPromptLoaded());
  }

  bool isPromptSelected(String prompt) {
    return selectedPrompts.contains(prompt);
  }

  bool canSelectMore() {
    return selectedPrompts.length < maxPrompts;
  }

  AudioPromptData? getAudioPromptData(String prompt) {
    return audioPromptData[prompt];
  }

  bool isMaxReached() {
    return selectedPrompts.length >= maxPrompts;
  }
}
