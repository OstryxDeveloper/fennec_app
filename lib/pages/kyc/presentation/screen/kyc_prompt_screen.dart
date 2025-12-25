import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_prompt_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/state/kyc_prompt_state.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/create_prompt_bottom_sheet.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/prompt_card.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class KycPromptScreen extends StatefulWidget {
  const KycPromptScreen({super.key});

  @override
  State<KycPromptScreen> createState() => _KycPromptScreenState();
}

class _KycPromptScreenState extends State<KycPromptScreen> {
  final _kycPromptCubit = Di().sl<KycPromptCubit>();

  bool _isBackgroundBlurred = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: Stack(
        children: [
          MovableBackground(
            child: SafeArea(
              child: BlocBuilder<KycPromptCubit, KycPromptState>(
                bloc: _kycPromptCubit,
                builder: (context, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomSizedBox(height: 20),
                                const CustomBackButton(),
                                CustomSizedBox(height: 32),
                                // Title
                                AppText(
                                  text:
                                      'Pick a few prompts and show off your personality.',
                                  style: AppTextStyles.h1(context).copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28.0,
                                  ),
                                ),
                                CustomSizedBox(height: 12),
                                // Subtitle
                                AppText(
                                  text:
                                      'Answer honestly, creatively, or with humor — these are your ice-breakers. You can answer up to 4 prompts.',
                                  style: AppTextStyles.bodyLarge(context)
                                      .copyWith(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                ),
                                CustomSizedBox(height: 32),
                                if (_kycPromptCubit
                                    .customPrompts
                                    .isNotEmpty) ...[
                                  ..._kycPromptCubit.customPrompts.map((
                                    prompt,
                                  ) {
                                    return PromptCard(
                                      prompt: prompt,
                                      setBackgroundBlurred: (value) {
                                        if (mounted) {
                                          setState(() {
                                            _isBackgroundBlurred = value;
                                          });
                                        }
                                      },
                                    );
                                  }),
                                  CustomSizedBox(height: 24),
                                ],
                                // Create Custom Prompt Button
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ColorPalette.primary.withOpacity(
                                      0.3,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        if (_kycPromptCubit.isMaxReached()) {
                                          _showMaxPromptsDialog(context);
                                          return;
                                        }
                                        setState(() {
                                          _isBackgroundBlurred = true;
                                        });
                                        _kycPromptCubit.resetRecording();
                                        await CreatePromptBottomSheet.show(
                                          context,
                                          'Create Custom Prompt',
                                        );
                                        if (mounted) {
                                          setState(() {
                                            _isBackgroundBlurred = false;
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 16,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText(
                                              text: 'Create Custom Prompt',
                                              style:
                                                  AppTextStyles.bodyLarge(
                                                    context,
                                                  ).copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                CustomSizedBox(height: 24),
                                // Separator
                                Center(
                                  child: AppText(
                                    text: 'Or use one of ours..',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.bodyRegular(context)
                                        .copyWith(
                                          color: Colors.white54,
                                          fontSize: 14,
                                        ),
                                  ),
                                ),
                                CustomSizedBox(height: 16),
                                // Predefined Prompts
                                ..._kycPromptCubit.predefinedPrompts.map((
                                  prompt,
                                ) {
                                  return PromptCard(
                                    prompt: prompt,
                                    setBackgroundBlurred: (value) {
                                      if (mounted) {
                                        setState(() {
                                          _isBackgroundBlurred = value;
                                        });
                                      }
                                    },
                                  );
                                }),
                                CustomSizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (_isBackgroundBlurred)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withOpacity(0.1)),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              children: [
                Expanded(
                  child: CustomOutlinedButton(
                    onPressed: () {
                      AutoRouter.of(context).push(const OnBoardingRoute());
                    },
                    text: 'Skip',
                    width: double.infinity,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomElevatedButton(
                    onTap: () {
                      AutoRouter.of(context).push(const OnBoardingRoute());
                    },
                    text: 'Continue',
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMaxPromptsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorPalette.secondry,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: AppText(
            text: 'Maximum Prompts Reached',
            style: AppTextStyles.h1(context).copyWith(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: AppText(
            text:
                'You can select only 4 prompts. Please deselect one to add another.',
            style: AppTextStyles.bodyLarge(
              context,
            ).copyWith(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText(
                text: 'OK',
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
