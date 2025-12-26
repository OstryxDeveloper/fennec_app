import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_prompt_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/create_prompt_bottom_sheet.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/prompt_audio_row.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PromptCard extends StatelessWidget {
  final String prompt;
  final Function(bool) setBackgroundBlurred;

  const PromptCard({
    super.key,
    required this.prompt,
    required this.setBackgroundBlurred,
  });

  @override
  Widget build(BuildContext context) {
    final kycPromptCubit = Di().sl<KycPromptCubit>();

    final isSelected = kycPromptCubit.isPromptSelected(prompt);
    final isMaxReached = kycPromptCubit.isMaxReached() && !isSelected;
    final canSelect = kycPromptCubit.canSelectMore() || isSelected;
    final hasAnswer = kycPromptCubit.hasPromptAnswer(prompt);
    final answer = kycPromptCubit.getPromptAnswer(prompt);
    final isAudio = kycPromptCubit.isPromptAnswerAudio(prompt);
    final audioPath = kycPromptCubit.getPromptAudioPath(prompt);
    final audioData = kycPromptCubit.getAudioPromptData(prompt);

    const sampleAnswers = {
      'A perfect weekend for me looks like...':
          'Sunset shoot, thrift run, then game night with the crew',
      'The most spontaneous thing I\'ve done...': 'Add your story',
      'My friends describe me as...': 'Vibes.',
      'Two truths and a lie...': 'Tap to add your truths',
      'What I\'d bring to a group trip...': 'Roadtrip playlists & snacks',
      'The fastest way to make me smile...': 'Good coffee and good company',
      'How my group describes me in one word...': 'You tell us',
      'My ideal group activity is...': 'Late-night drives',
    };

    final subtitle = hasAnswer
        ? (isAudio ? null : answer)
        : sampleAnswers[prompt] ?? 'Tap to add your answer';
    final showAudioRow = hasAnswer && isAudio && audioPath != null;

    return Opacity(
      opacity: isMaxReached ? 0.4 : 1.0,
      child: Container(
        height: isSelected && showAudioRow ? 128 : null,
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorPalette.primary
              : ColorPalette.secondry.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: ColorPalette.primary.withValues(alpha: 0.15),
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isMaxReached
                ? null
                : () async {
                    setBackgroundBlurred(true);
                    kycPromptCubit.showRecordedState(
                      prompt,
                      audioData?.waveformData ?? [],
                      audioData?.duration ?? "",
                    );
                    await CreatePromptBottomSheet.show(
                      context,
                      prompt,
                      existingAnswer: answer,
                      existingAudioPath: audioPath,
                      existingAudioData: audioData,
                    );
                    setBackgroundBlurred(false);
                  },
            onLongPress: isSelected
                ? () {
                    _showDeselectDialog(context, prompt, kycPromptCubit);
                  }
                : null,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: AppText(
                      text: prompt,
                      maxLines: 1,
                      style: AppTextStyles.bodyLarge(context).copyWith(
                        fontSize: canSelect ? 18 : 16,
                        fontWeight: canSelect
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: subtitle != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: AppText(
                              text: subtitle,
                              style: AppTextStyles.bodySmall(context).copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : null,
                    trailing: hasAnswer
                        ? SvgPicture.asset(
                            Assets.icons.edit3.path,
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              Colors.white.withValues(alpha: 0.6),
                              BlendMode.srcIn,
                            ),
                          )
                        : SvgPicture.asset(
                            Assets.icons.arrowRight.path,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              Colors.white.withValues(alpha: 0.6),
                              BlendMode.srcIn,
                            ),
                          ),
                  ),

                  if (showAudioRow && audioData != null)
                    PromptAudioRow(
                      audioPath: audioPath,
                      duration: audioData.duration,
                      waveformData: audioData.waveformData,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeselectDialog(
    BuildContext context,
    String prompt,
    KycPromptCubit cubit,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorPalette.secondry,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: AppText(
            text: 'Deselect Prompt',
            style: AppTextStyles.h1(context).copyWith(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: AppText(
            text:
                'Do you want to deselect this prompt? Your answer will remain saved.',
            style: AppTextStyles.bodyLarge(context).copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText(
                text: 'Cancel',
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                cubit.togglePromptSelection(prompt);
                Navigator.of(context).pop();
              },
              child: AppText(
                text: 'Deselect',
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: ColorPalette.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
