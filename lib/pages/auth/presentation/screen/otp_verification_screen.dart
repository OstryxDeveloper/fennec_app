import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_otp_field.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
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

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: MovableBackground(
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
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Lottie.asset(
                          Assets.animations.iconBg,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        SvgPicture.asset(
                          Assets.icons.vector4.path,
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
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
                      print("OTP Completed: $otp");
                    },
                  ),
                  CustomSizedBox(height: 40),
                  CustomElevatedButton(
                    onTap: () {
                      // Verify logic
                      print("Verify OTP: ${_otpController.text}");
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
                          onTap: () {
                            // Resend logic
                            print("Resend Code");
                          },
                          child: AppText(
                            text: 'Resend',
                            style: AppTextStyles.bodyLarge(context).copyWith(
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
    );
  }
}
