import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/reusable_widgets/animated_background_container.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_bottom_sheet.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_otp_field.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isBackgroundBlurred = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: Stack(
        children: [
          MovableBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomSizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomBackButton(),
                      ),
                      AnimatedBackgroundContainer(
                        icon: Assets.icons.vector4.path,
                      ),

                      CustomSizedBox(height: 40),
                      AppText(
                        text: 'Verify your code',
                        style: AppTextStyles.h1(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      CustomSizedBox(height: 12),
                      AppText(
                        text:
                            "We’ve sent you a 6-digit code, enter it below to verify your account.",
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      CustomSizedBox(height: 40),
                      CustomOtpField(
                        controller: _otpController,
                        length: 6,
                        onCompleted: (otp) {
                          debugPrint("OTP Completed: $otp");
                        },
                      ),
                      CustomSizedBox(height: 40),
                      CustomElevatedButton(
                        onTap: () async {
                          setState(() {
                            _isBackgroundBlurred = true;
                          });
                          await CustomBottomSheet.show(
                            icon: AnimatedBackgroundContainer(
                              icon: Assets.icons.checkGreen.path,
                              isPng: true,
                            ),
                            context: context,
                            title: 'Account Verified',
                            description:
                                'Your account has been verified. Continue to set new password for your account.',
                            buttonText: 'Continue',
                            onButtonPressed: () {
                              Navigator.pop(context);
                              AutoRouter.of(
                                context,
                              ).push(const SetNewPasswordRoute());
                            },
                          );
                          if (mounted) {
                            setState(() {
                              _isBackgroundBlurred = false;
                            });
                          }
                        },
                        text: 'Verify',
                        width: double.infinity,
                      ),
                      CustomSizedBox(height: 24),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black26,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: 'Didn’t get the code?',
                              style: AppTextStyles.bodyLarge(
                                context,
                              ).copyWith(color: Colors.white),
                            ),
                            InkWell(
                              onTap: () {},
                              child: AppText(
                                text: 'Resend',
                                style: AppTextStyles.bodyLarge(context)
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isBackgroundBlurred)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withValues(alpha: 0.1)),
              ),
            ),
        ],
      ),
    );
  }
}
