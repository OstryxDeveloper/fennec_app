import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/constants/media_query_constants.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/helpers/toast_helper.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_prompt_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/audio_mode_widget.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePromptBottomSheet extends StatefulWidget {
  final String promptText;
  final String? existingAnswer;
  final String? existingAudioPath;
  final AudioPromptData? existingAudioData;
  const CreatePromptBottomSheet({
    super.key,
    required this.promptText,
    this.existingAnswer,
    this.existingAudioPath,
    this.existingAudioData,
  });

  static Future<void> show(
    BuildContext context,
    String promptText, {
    String? existingAnswer,
    String? existingAudioPath,
    AudioPromptData? existingAudioData,
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
          existingAudioData: existingAudioData,
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
  final KycPromptCubit _kycPromptCubit = Di().sl<KycPromptCubit>();

  bool get _isCustom => widget.promptText == 'Create Custom Prompt';
  final _formKey = GlobalKey<FormState>();

  // Audio controllers (managed in widget, state in cubit)
  void _handleDone() {
    final promptText = _isCustom == true
        ? _kycPromptCubit.promptController.text.trim()
        : widget.promptText.trim();

    if (_kycPromptCubit.isAudioMode) {
      if (_isCustom == true && promptText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add your prompt.')),
        );
        return;
      }

      if (_kycPromptCubit.isRecorded && _kycPromptCubit.recordingPath != null) {
        if (_isCustom == true &&
            !_kycPromptCubit.customPrompts.contains(promptText)) {
          _kycPromptCubit.addCustomPrompt(promptText);
        }

        _kycPromptCubit.savePromptAnswer(
          promptText,
          'Audio',
          audioPath: _kycPromptCubit.recordingPath,
          waveformData: _kycPromptCubit.recordedWaveformData,
          duration: _kycPromptCubit.recordedDuration,
        );
        _kycPromptCubit.promptController.clear();

        AutoRouter.of(context).pop();
      } else {
        showCustomToast(context, 'Please record your answer.');
      }
    } else {
      // Handle text submission
      if (_formKey.currentState?.validate() ?? false) {
        final answer = _kycPromptCubit.controller.text.trim();

        if (_isCustom == true &&
            !_kycPromptCubit.customPrompts.contains(promptText)) {
          _kycPromptCubit.addCustomPrompt(promptText);
        }

        _kycPromptCubit.savePromptAnswer(promptText, answer);
        _kycPromptCubit.controller.clear();
        AutoRouter.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: _isCustom
            ? getHeight(context) * 0.64
            : getHeight(context) * 0.54,
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
            child: Form(
              key: _formKey,
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
                  if (_isCustom) ...[
                    CustomSizedBox(height: 24),
                    CustomLabelTextField(
                      label: 'Your prompt',
                      controller: _kycPromptCubit.promptController,
                      hintText: 'Type here..',
                      labelColor: Colors.white,
                      filled: false,
                      validator: (value) {
                        if (_isCustom &&
                            (value == null || value.trim().isEmpty)) {
                          return 'Please enter your prompt';
                        }
                        return null;
                      },
                    ),
                  ],
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
                            ? AudioModeWidget(
                                existingAudioPath: widget.existingAudioPath,
                                existingAudioData: widget.existingAudioData,
                                promptText: _isCustom
                                    ? _kycPromptCubit.promptController.text
                                          .trim()
                                    : widget.promptText,
                              )
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

  Widget _buildTextMode() {
    return CustomLabelTextField(
      label: 'Your answer',
      controller: _kycPromptCubit.controller,
      scrollController: ScrollController(),
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
    );
  }
}
