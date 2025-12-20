import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/constants/media_query_constants.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_prompt_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/state/kyc_prompt_state.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatePromptBottomSheet extends StatefulWidget {
  final String promptText;
  final String? existingAnswer;
  final String? existingAudioPath;
  const CreatePromptBottomSheet({
    super.key,
    required this.promptText,
    this.existingAnswer,
    this.existingAudioPath,
  });

  static Future<void> show(
    BuildContext context,
    String promptText, {
    String? existingAnswer,
    String? existingAudioPath,
  }) async {
    final cubit = Di().sl<KycPromptCubit>();
    cubit.showCreatePromptBottomSheet();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: CreatePromptBottomSheet(
          promptText: promptText,
          existingAnswer: existingAnswer,
          existingAudioPath: existingAudioPath,
        ),
      ),
    );
    cubit.hideCreatePromptBottomSheet();
  }

  @override
  State<CreatePromptBottomSheet> createState() =>
      _CreatePromptBottomSheetState();
}

class _CreatePromptBottomSheetState extends State<CreatePromptBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final KycPromptCubit _kycPromptCubit = Di().sl<KycPromptCubit>();

  // Audio controllers (managed in widget, state in cubit)
  late RecorderController recorderController;
  late PlayerController playerController;

  @override
  void initState() {
    super.initState();
    // Pre-fill text if editing
    if (widget.existingAnswer != null && widget.existingAudioPath == null) {
      _controller.text = widget.existingAnswer!;
      _kycPromptCubit.isAudioMode = false;
    } else if (widget.existingAudioPath != null) {
      _kycPromptCubit.isAudioMode = true;
      _kycPromptCubit.recordingPath = widget.existingAudioPath;
      _kycPromptCubit.isRecorded = true;
    }
    _initializeRecorder();
    _initializePlayer();
  }

  Future<void> _initializeRecorder() async {
    recorderController = RecorderController();
  }

  void _initializePlayer() {
    playerController = PlayerController();
  }

  Future<void> _startRecording() async {
    try {
      await _kycPromptCubit.startRecording(recorderController);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error starting recording: $e. Please check microphone permissions.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _kycPromptCubit.stopRecording(recorderController);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error stopping recording: $e')));
      }
    }
  }

  Future<void> _togglePlayback() async {
    try {
      await _kycPromptCubit.togglePlayback(playerController);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error playing audio: $e')));
      }
    }
  }

  void _deleteRecording() {
    _kycPromptCubit.deleteRecording(playerController);
  }

  @override
  void dispose() {
    _controller.dispose();
    recorderController.dispose();
    playerController.dispose();
    super.dispose();
  }

  void _handleDone() {
    if (_kycPromptCubit.isAudioMode) {
      if (_kycPromptCubit.isRecorded && _kycPromptCubit.recordingPath != null) {
        if (widget.promptText == 'Create Custom Prompt') {
          final customPromptText = 'Custom Prompt';
          _kycPromptCubit.savePromptAnswer(
            customPromptText,
            'Audio',
            audioPath: _kycPromptCubit.recordingPath,
          );
          if (!_kycPromptCubit.customPrompts.contains(customPromptText)) {
            _kycPromptCubit.addCustomPrompt(customPromptText);
          }
        } else {
          // Save audio answer for existing prompt
          _kycPromptCubit.savePromptAnswer(
            widget.promptText,
            'Audio',
            audioPath: _kycPromptCubit.recordingPath,
          );
        }
        AutoRouter.of(context).pop();
      }
    } else {
      // Handle text submission
      if (_formKey.currentState?.validate() ?? false) {
        final answer = _controller.text.trim();
        // If creating a new custom prompt, use the answer as the prompt text
        if (widget.promptText == 'Create Custom Prompt') {
          _kycPromptCubit.savePromptAnswer(answer, answer);
          if (!_kycPromptCubit.customPrompts.contains(answer)) {
            _kycPromptCubit.addCustomPrompt(answer);
          }
        } else {
          // Save text answer for existing prompt
          _kycPromptCubit.savePromptAnswer(widget.promptText, answer);
        }
        AutoRouter.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(context) * 0.54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorPalette.secondry, ColorPalette.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Handle bar
              CustomSizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              CustomSizedBox(height: 32),
              // Prompt Text
              AppText(
                text: widget.promptText,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              CustomSizedBox(height: 32),
              // Text/Audio Toggle
              BlocBuilder(
                bloc: _kycPromptCubit,
                builder: (context, state) {
                  return Container(
                    height: 36,
                    width: 376,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildToggleSegment(
                          'Text',
                          !_kycPromptCubit.isAudioMode,
                          () {
                            _kycPromptCubit.toggleAudioMode();
                          },
                        ),
                        _buildToggleSegment(
                          'Audio',
                          _kycPromptCubit.isAudioMode,
                          () {
                            _kycPromptCubit.toggleAudioMode();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              CustomSizedBox(height: 40),
              BlocBuilder(
                bloc: _kycPromptCubit,
                builder: (context, state) {
                  return Expanded(
                    child: _kycPromptCubit.isAudioMode
                        ? _buildAudioMode()
                        : _buildTextMode(),
                  );
                },
              ),
              CustomSizedBox(height: 20),
              // Done Button
              CustomElevatedButton(
                onTap: _handleDone,
                text: 'Done',
                width: double.infinity,
              ),
              CustomSizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSegment(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: getWidth(context) > 400 ? 180 : 140,
        height: 32,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: isSelected ? ColorPalette.primary : Colors.black54,

          borderRadius: BorderRadius.circular(30),
        ),
        child: AppText(
          text: label,
          style: AppTextStyles.bodyLarge(
            context,
          ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAudioMode() {
    return BlocBuilder<KycPromptCubit, KycPromptState>(
      bloc: _kycPromptCubit,
      builder: (context, state) {
        if (_kycPromptCubit.isRecorded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      30,
                      (index) => Container(
                        width: 3,
                        height: 20 + (index % 5) * 10.0,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              CustomSizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Play Button
                  GestureDetector(
                    onTap: _togglePlayback,
                    child: Container(
                      width: 96,
                      height: 96,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorPalette.primary,
                        shape: BoxShape.circle,
                      ),
                      child: _kycPromptCubit.isPlaying
                          ? const Icon(
                              Icons.stop,
                              color: Colors.white,
                              size: 32,
                            )
                          : SvgPicture.asset(
                              Assets.icons.play.path,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  CustomSizedBox(width: 24),
                  // Delete Button
                  GestureDetector(
                    onTap: _deleteRecording,
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        Assets.icons.trash.path,
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Show recording UI
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                child: AudioWaveforms(
                  size: const Size(double.infinity, 80),
                  recorderController: recorderController,
                  waveStyle: const WaveStyle(
                    waveColor: Colors.white,
                    extendWaveform: true,
                    showMiddleLine: false,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _kycPromptCubit.isRecording
                    ? _stopRecording
                    : _startRecording,
                child: Container(
                  width: 96,
                  height: 96,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _kycPromptCubit.isRecording
                        ? Colors.red
                        : ColorPalette.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (_kycPromptCubit.isRecording
                                    ? Colors.red
                                    : ColorPalette.primary)
                                .withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: _kycPromptCubit.isRecording
                      ? const Icon(Icons.stop, color: Colors.white, size: 40)
                      : SvgPicture.asset(
                          Assets.icons.mic.path,
                          width: 32,
                          height: 32,
                          color: Colors.white,
                        ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildTextMode() {
    return Form(
      key: _formKey,
      child: CustomLabelTextField(
        label: 'Your answer',
        controller: _controller,
        hintText: 'Type your answer here...',
        labelColor: Colors.white,
        filled: false,
        maxLines: 4,
        minLines: 3,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your answer';
          }
          return null;
        },
      ),
    );
  }
}
