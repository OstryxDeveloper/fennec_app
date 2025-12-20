import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_prompt_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/create_prompt_bottom_sheet.dart';
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
    final canSelect = kycPromptCubit.canSelectMore() || isSelected;
    final hasAnswer = kycPromptCubit.hasPromptAnswer(prompt);
    final answer = kycPromptCubit.getPromptAnswer(prompt);
    final isAudio = kycPromptCubit.isPromptAnswerAudio(prompt);
    final audioPath = kycPromptCubit.getPromptAudioPath(prompt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected
              ? ColorPalette.secondry.withOpacity(0.8)
              : ColorPalette.secondry.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: ColorPalette.primary, width: 2)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              setBackgroundBlurred(true);
              await CreatePromptBottomSheet.show(
                context,
                prompt,
                existingAnswer: answer,
                existingAudioPath: audioPath,
              );
              setBackgroundBlurred(false);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppText(
                          text: prompt,
                          style: AppTextStyles.bodyLarge(context).copyWith(
                            color: canSelect ? Colors.white : Colors.white38,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasAnswer)
                            GestureDetector(
                              onTap: () async {
                                setBackgroundBlurred(true);
                                await CreatePromptBottomSheet.show(
                                  context,
                                  prompt,
                                  existingAnswer: answer,
                                  existingAudioPath: audioPath,
                                );
                                setBackgroundBlurred(false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: SvgPicture.asset(
                                  Assets.icons.edit.path,
                                  width: 20,
                                  height: 20,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: ColorPalette.primary,
                              size: 24,
                            )
                          else
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white54,
                              size: 16,
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (hasAnswer && answer != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: isAudio
                          ? Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.icons.play.path,
                                  width: 16,
                                  height: 16,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 8),
                                AppText(
                                  text: '00:16',
                                  style: AppTextStyles.bodyRegular(context)
                                      .copyWith(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            )
                          : AppText(
                              text: answer,
                              style: AppTextStyles.bodyRegular(
                                context,
                              ).copyWith(color: Colors.white70, fontSize: 13),
                            ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
