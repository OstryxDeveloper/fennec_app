import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/auth/presentation/widgets/tile_widget.dart';
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
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({super.key});

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  final _otpController = TextEditingController();

  final ValueNotifier<bool> _isCodeResentNotifier = ValueNotifier(false);
  final ValueNotifier<String?> _errorMessageNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isBlurNotifier = ValueNotifier(false);

  @override
  void dispose() {
    _otpController.dispose();
    _isCodeResentNotifier.dispose();
    _errorMessageNotifier.dispose();
    _isBlurNotifier.dispose();
    super.dispose();
  }

  void _onVerify() async {
    if (_otpController.text != '123456') {
      _errorMessageNotifier.value = 'Incorrect OTP code. Please try again.';
    } else {
      _errorMessageNotifier.value = null;
      _isBlurNotifier.value = true;
      await CustomBottomSheet.show(
        context: context,
        barrierColor: Colors.transparent,
        title: 'Phone Number Verified',
        description:
            "Your phone number has been verified. Continue to complete your profile.",
        buttonText: 'Continue',
        onButtonPressed: () {
          AutoRouter.of(context).push(OnBoardingRoute());
        },
        icon: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green, width: 2),
          ),
          child: Icon(Icons.check, color: Colors.green, size: 50),
        ),
      );
      _isBlurNotifier.value = false;
    }
  }

  void _onResend() {
    _isCodeResentNotifier.value = true;
    _errorMessageNotifier.value = null;
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _isCodeResentNotifier.value = false;
      }
    });
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
                      CustomSizedBox(height: 40),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorPalette.primary,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          size: 40,
                          color: ColorPalette.white,
                        ),
                      ),
                      CustomSizedBox(height: 40),
                      AppText(
                        text: 'Verify your phone number',
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
                      ValueListenableBuilder<String?>(
                        valueListenable: _errorMessageNotifier,
                        builder: (context, errorMessage, child) {
                          return Column(
                            children: [
                              CustomOtpField(
                                controller: _otpController,
                                length: 6,
                                color: errorMessage != null ? Colors.red : null,
                                onCompleted: (otp) {
                                  // _onVerify();
                                },
                              ),
                              if (errorMessage != null) ...[
                                CustomSizedBox(height: 12),
                                AppText(
                                  text: errorMessage,
                                  style: AppTextStyles.bodyRegular(context)
                                      .copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      CustomSizedBox(height: 40),
                      ValueListenableBuilder(
                        valueListenable: _errorMessageNotifier,
                        builder: (context, value, child) {
                          return CustomElevatedButton(
                            onTap: _onVerify,
                            text: value == null ? 'Verify' : 'Try Again',
                            width: double.infinity,
                          );
                        },
                      ),
                      CustomSizedBox(height: 24),

                      ValueListenableBuilder<bool>(
                        valueListenable: _isCodeResentNotifier,
                        builder: (context, isCodeResent, child) {
                          if (!isCodeResent) {
                            return TileWidget(onTap: _onResend);
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: ColorPalette.greenDark,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.icons.checkCircle.path,
                                  height: 24,
                                  width: 24,
                                  colorFilter: ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Code Sent Again',
                                  style: AppTextStyles.bodyLarge(context)
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    _isCodeResentNotifier.value = false;
                                  },
                                  child: SvgPicture.asset(
                                    Assets.icons.cancel.path,
                                    height: 24,
                                    width: 24,
                                    colorFilter: ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isBlurNotifier,
            builder: (context, isBlurred, child) {
              if (!isBlurred) return const SizedBox.shrink();
              return Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
