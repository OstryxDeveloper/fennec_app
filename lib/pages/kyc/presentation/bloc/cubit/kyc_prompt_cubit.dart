import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:fennac_app/helpers/toast_helper.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/state/kyc_prompt_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class KycPromptCubit extends Cubit<KycPromptState> {
  KycPromptCubit() : super(KycPromptInitial());

  // List of predefined prompts
  final List<String> predefinedPrompts = [
    'A perfect weekend for me looks like...',
    'The most spontaneous thing I\'ve done...',
    'My friends describe me as...',
    'Two truths and a lie...',
    'What I\'d bring to a group trip...',
    'The fastest way to make me smile...',
    'How my group describes me in one word...',
    'My ideal group activity is...',
  ];

  // Selected prompts (up to 4)
  final List<String> selectedPrompts = [];

  // Custom prompts created by user
  final List<String> customPrompts = [];

  // Prompt answers: Map<prompt, answer>
  // Answer can be text (String) or audio path (String starting with '/')
  final Map<String, String> promptAnswers = {};

  // Audio paths for prompts: Map<prompt, audioPath>
  final Map<String, String> promptAudioPaths = {};

  // Maximum allowed prompts
  static const int maxPrompts = 4;

  // Bottom sheet visibility
  bool _showBottomSheet = false;
  bool get showBottomSheet => _showBottomSheet;

  bool isAudioMode = false;

  // Audio recording state
  String? recordingPath;
  bool isRecording = false;
  bool isRecorded = false;
  bool isPlaying = false;

  void toggleAudioMode() {
    emit(KycPromptLoading());
    isAudioMode = !isAudioMode;
    emit(KycPromptLoaded());
  }

  Future<void> startRecording(RecorderController recorderController) async {
    try {
      emit(KycPromptLoading());
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await recorderController.record(path: path);
      recordingPath = path;
      isRecording = true;
      isRecorded = false;
      isPlaying = false;
      emit(KycPromptLoaded());
    } catch (e) {
      emit(KycPromptError());
      rethrow;
    }
  }

  Future<void> stopRecording(RecorderController recorderController) async {
    try {
      emit(KycPromptLoading());
      final path = await recorderController.stop();
      recordingPath = path ?? recordingPath;
      isRecording = false;
      isRecorded = true;
      isPlaying = false;
      emit(KycPromptLoaded());
    } catch (e) {
      emit(KycPromptError());
      rethrow;
    }
  }

  Future<void> togglePlayback(PlayerController playerController) async {
    try {
      emit(KycPromptLoading());
      if (isPlaying) {
        await playerController.pausePlayer();
        isPlaying = false;
      } else {
        if (recordingPath != null) {
          await playerController.preparePlayer(path: recordingPath!);
          await playerController.startPlayer();
          isPlaying = true;

          // Listen for playback completion
          playerController.onPlayerStateChanged.listen((state) {
            if (state == PlayerState.stopped) {
              isPlaying = false;
              emit(KycPromptLoaded());
            }
          });
        }
      }
      emit(KycPromptLoaded());
    } catch (e) {
      emit(KycPromptError());
      rethrow;
    }
  }

  void deleteRecording(PlayerController playerController) {
    emit(KycPromptLoading());
    if (recordingPath != null) {
      try {
        final file = File(recordingPath!);
        if (file.existsSync()) {
          file.deleteSync();
        }
      } catch (e) {
        // Handle error silently
      }
    }
    playerController.stopPlayer();
    recordingPath = null;
    isRecorded = false;
    isPlaying = false;
    isRecording = false;
    emit(KycPromptLoaded());
  }

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

  void savePromptAnswer(String prompt, String answer, {String? audioPath}) {
    emit(KycPromptLoading());
    promptAnswers[prompt] = answer;
    if (audioPath != null) {
      promptAudioPaths[prompt] = audioPath;
    } else {
      promptAudioPaths.remove(prompt);
    }
    // Auto-select the prompt if not already selected
    if (!selectedPrompts.contains(prompt) &&
        selectedPrompts.length < maxPrompts) {
      selectedPrompts.add(prompt);
    }
    emit(KycPromptLoaded());
  }

  void editPromptAnswer(String prompt) {
    emit(KycPromptLoading());
    // This will be used to open the bottom sheet with existing answer
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
    if (selectedPrompts.length < maxPrompts) {
      return true;
    } else {
      VxToast.show(msg: 'You can select up to $maxPrompts prompts only.');
      return false;
    }
  }
}
