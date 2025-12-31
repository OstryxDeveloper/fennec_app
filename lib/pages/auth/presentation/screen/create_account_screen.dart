import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/state/auth_state.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_country_field.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/pages/auth/presentation/widgets/privacy_bottom_sheet.dart';
import 'package:fennac_app/pages/auth/presentation/widgets/terms_bottom_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _authCubit = Di().sl<AuthCubit>();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isBlurNotifier = ValueNotifier(false);
  final ValueNotifier<String?> _errorMessageNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _authCubit.loadCountry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: MovableBackground(
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: BlocBuilder<AuthCubit, AuthState>(
                    bloc: _authCubit,
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomBackButton(),
                            ),
                            SvgPicture.asset(
                              Assets.icons.logoAnimation.path,
                              width: 80,
                              height: 80,
                            ),
                            CustomSizedBox(height: 20),
                            AppText(
                              text: 'Create Your Account',
                              style: AppTextStyles.h2(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomSizedBox(height: 12),
                            AppText(
                              text:
                                  'Create your Fennec account and start connecting with groups near you.',
                              style: AppTextStyles.subHeading(
                                context,
                              ).copyWith(color: ColorPalette.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                            CustomSizedBox(height: 40),

                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomLabelTextField(
                                        label: 'First Name',
                                        controller:
                                            _authCubit.firstNameController,
                                        hintText: 'Enter your first name',
                                        labelColor: Colors.white,
                                        filled: false,
                                        onChanged: (value) {
                                          if (mounted) {
                                            _authCubit.onFirstNameChanged(
                                              value,
                                            );
                                          }
                                        },
                                      ),
                                      if (_authCubit.getFirstNameError() !=
                                          null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: AppText(
                                            text:
                                                _authCubit
                                                    .getFirstNameError() ??
                                                "",
                                            style:
                                                AppTextStyles.bodyRegular(
                                                  context,
                                                ).copyWith(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomLabelTextField(
                                        label: 'Last Name',
                                        controller:
                                            _authCubit.lastNameController,
                                        hintText: 'Enter your last name',
                                        labelColor: Colors.white,
                                        filled: false,
                                        onChanged: (value) {
                                          if (mounted) {
                                            _authCubit.onLastNameChanged(value);
                                          }
                                        },
                                      ),
                                      if (_authCubit.getLastNameError() != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: AppText(
                                            text:
                                                _authCubit.getLastNameError() ??
                                                "",
                                            style:
                                                AppTextStyles.bodyRegular(
                                                  context,
                                                ).copyWith(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            CustomSizedBox(height: 24),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomLabelTextField(
                                  label: 'Email',
                                  controller: _authCubit.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  hintText: 'example@gmail.com',
                                  labelColor: Colors.white,
                                  filled: false,
                                  onChanged: (value) {
                                    if (mounted) {
                                      _authCubit.onEmailChanged(value);
                                    }
                                  },
                                ),
                                if (_authCubit.getEmailError() != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: AppText(
                                      text: _authCubit.getEmailError() ?? "",
                                      style: AppTextStyles.bodyRegular(context)
                                          .copyWith(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                            CustomSizedBox(height: 24),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PhoneNumberField(
                                  label: 'Phone Number',
                                  hintText: 'Enter Your Number',
                                  initialCountry: _authCubit.selectedCountry,
                                  onChanged: (completePhoneNumber) {
                                    if (mounted) {
                                      _authCubit.phoneController.text =
                                          completePhoneNumber;
                                      _authCubit.onPhoneChanged(
                                        completePhoneNumber,
                                      );
                                    }
                                  },
                                ),
                                if (_authCubit.getPhoneError() != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: AppText(
                                      text: _authCubit.getPhoneError() ?? "",
                                      style: AppTextStyles.bodyRegular(context)
                                          .copyWith(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                            CustomSizedBox(height: 24),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomLabelTextField(
                                  label: 'Password',
                                  controller: _authCubit.passwordController,
                                  obscureText: _authCubit.obscurePassword,
                                  hintText: 'Enter your password',
                                  labelColor: Colors.white,
                                  filled: false,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      if (mounted) {
                                        _authCubit.togglePasswordVisibility();
                                      }
                                    },
                                    icon: _authCubit.obscurePassword
                                        ? Assets.icons.eye.svg(
                                            color: Colors.white,
                                          )
                                        : Assets.icons.eyeClose.svg(
                                            color: Colors.white,
                                          ),
                                  ),
                                  onChanged: (value) {
                                    if (mounted) {
                                      _authCubit.onPasswordChanged(value);
                                    }
                                  },
                                ),
                                if (_authCubit.getPasswordError() != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: AppText(
                                      text: _authCubit.getPasswordError() ?? "",
                                      style: AppTextStyles.bodyRegular(context)
                                          .copyWith(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                            CustomSizedBox(height: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomLabelTextField(
                                  label: 'Confirm Password',
                                  controller:
                                      _authCubit.confirmPasswordController,
                                  obscureText:
                                      _authCubit.obscureConfirmPassword,
                                  hintText: 'Re-enter your password',
                                  labelColor: Colors.white,
                                  filled: false,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      if (mounted) {
                                        _authCubit
                                            .toggleConfirmPasswordVisibility();
                                      }
                                    },
                                    icon: _authCubit.obscureConfirmPassword
                                        ? Assets.icons.eye.svg(
                                            color: Colors.white,
                                          )
                                        : Assets.icons.eyeClose.svg(
                                            color: Colors.white,
                                          ),
                                  ),
                                  onChanged: (value) {
                                    if (mounted) {
                                      _authCubit.onConfirmPasswordChanged(
                                        value,
                                      );
                                    }
                                  },
                                ),
                                if (_authCubit.getConfirmPasswordError() !=
                                    null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: AppText(
                                      text:
                                          _authCubit
                                              .getConfirmPasswordError() ??
                                          "",
                                      style: AppTextStyles.bodyRegular(context)
                                          .copyWith(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                            CustomSizedBox(height: 16),

                            // Terms and Privacy
                            ValueListenableBuilder<String?>(
                              valueListenable: _errorMessageNotifier,
                              builder: (context, errorMessage, child) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: 'By signing up, you agree to our ',
                                      style: AppTextStyles.description(
                                        context,
                                      ).copyWith(color: Colors.white70),
                                      children: [
                                        TextSpan(
                                          text: 'Terms of Service',
                                          style:
                                              AppTextStyles.description(
                                                context,
                                              ).copyWith(
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              TermsBottomSheet.show(
                                                context,
                                                blurNotifier: _isBlurNotifier,
                                              );
                                            },
                                        ),
                                        const TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style:
                                              AppTextStyles.description(
                                                context,
                                              ).copyWith(
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              PrivacyBottomSheet.show(
                                                context,
                                                blurNotifier: _isBlurNotifier,
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            CustomSizedBox(height: 24),

                            // Sign Up Button
                            CustomElevatedButton(
                              onTap: () {
                                if (mounted) {
                                  _authCubit.submit();

                                  if (_authCubit.isFormValid()) {
                                    AutoRouter.of(
                                      context,
                                    ).replace(const VerifyPhoneNumberRoute());
                                  }
                                }
                              },
                              text: 'Sign Up',
                              width: double.infinity,
                            ),
                            CustomSizedBox(height: 40),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isBlurNotifier,
              builder: (context, isBlurred, child) {
                return IgnorePointer(
                  ignoring: !isBlurred,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isBlurred ? 1 : 0.0,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
