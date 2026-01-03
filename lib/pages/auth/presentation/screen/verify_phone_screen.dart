import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/state/auth_state.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({super.key});

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  final _otpController = TextEditingController();
  late AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = Di().sl<AuthCubit>();
    _authCubit.startOtpTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _authCubit.disposeOtpTimer();
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
                      CustomSizedBox(height: 40),
                      AnimatedBackgroundContainer(
                        icon: Assets.icons.vector.path,
                      ),
                      CustomSizedBox(height: 40),
                      AppText(
                        text: 'Verify your phone number',
                        style: AppTextStyles.h1(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      CustomSizedBox(height: 12),
                      AppText(
                        text:
                            "We've sent you a 6-digit code, enter it below to verify your account.",
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white60,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      CustomSizedBox(height: 40),
                      BlocBuilder<AuthCubit, AuthState>(
                        bloc: _authCubit,
                        builder: (context, state) {
                          return Column(
                            children: [
                              CustomOtpField(
                                controller: _otpController,
                                length: 6,
                                color: _authCubit.otpErrorMessage != null
                                    ? Colors.red
                                    : null,
                                onCompleted: (otp) {
                                  // Auto-verify when completed (optional)
                                },
                              ),
                              if (_authCubit.otpErrorMessage != null) ...[
                                CustomSizedBox(height: 12),
                                AppText(
                                  text: _authCubit.otpErrorMessage!,
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
                      BlocBuilder<AuthCubit, AuthState>(
                        bloc: _authCubit,
                        builder: (context, state) {
                          return CustomElevatedButton(
                            onTap: () async {
                              final isValid = await _authCubit.verifyOtpCode(
                                _otpController.text,
                                '123456',
                              );
                              if (isValid && mounted) {
                                await CustomBottomSheet.show(
                                  context: context,
                                  barrierColor: Colors.transparent,
                                  title: 'Phone Number Verified',
                                  description:
                                      "Your phone number has been verified. Continue to complete your profile.",
                                  buttonText: 'Continue',
                                  onButtonPressed: () {
                                    _authCubit.resetOtpBlur();
                                    AutoRouter.of(context).push(KycRoute());
                                  },
                                  icon: AnimatedBackgroundContainer(
                                    icon: Assets.icons.checkGreen.path,
                                    isPng: true,
                                  ),
                                );
                                if (mounted) {
                                  _authCubit.resetOtpBlur();
                                }
                              }
                            },
                            text: _authCubit.otpErrorMessage == null
                                ? 'Verify'
                                : 'Try Again',
                            width: double.infinity,
                          );
                        },
                      ),
                      CustomSizedBox(height: 24),
                      BlocBuilder<AuthCubit, AuthState>(
                        bloc: _authCubit,
                        builder: (context, state) {
                          return Container(
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
                                  text: "Didn't get the code?",
                                  style: AppTextStyles.bodyLarge(
                                    context,
                                  ).copyWith(color: Colors.white),
                                ),
                                InkWell(
                                  onTap: _authCubit.canResendOtp
                                      ? () {
                                          _authCubit.resendOtpCode();
                                        }
                                      : null,
                                  child: AppText(
                                    text: _authCubit.canResendOtp
                                        ? 'Resend'
                                        : _authCubit.formatOtpTime(
                                            _authCubit.remainingSeconds,
                                          ),
                                    style: AppTextStyles.bodyLarge(context)
                                        .copyWith(
                                          color: _authCubit.canResendOtp
                                              ? Colors.white
                                              : Colors.white.withValues(
                                                  alpha: 0.7,
                                                ),
                                          fontWeight: FontWeight.w500,
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
          BlocBuilder<AuthCubit, AuthState>(
            bloc: _authCubit,
            builder: (context, state) {
              if (!_authCubit.isOtpBlurred) {
                return const SizedBox.shrink();
              }
              return Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.black.withValues(alpha: 0.1)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
