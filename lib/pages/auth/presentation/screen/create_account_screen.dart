import 'package:auto_route/auto_route.dart';
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

  @override
  void initState() {
    super.initState();
    _authCubit.loadCountry();
  }

  @override
  void dispose() {
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
              child: BlocBuilder(
                bloc: _authCubit,
                builder: (context, state) {
                  return Form(
                    key: _authCubit.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomSizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomBackButton(),
                        ),
                        CustomSizedBox(height: 20),
                        SvgPicture.asset(
                          Assets.icons.logoAnimation.path,
                          width: 80,
                          height: 80,
                        ),
                        CustomSizedBox(height: 20),
                        AppText(
                          text: 'Create Your Account',
                          style: AppTextStyles.h1(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        CustomSizedBox(height: 12),
                        AppText(
                          text:
                              'Create your Fennec account and start connecting with groups near you.',
                          style: AppTextStyles.bodyLarge(context).copyWith(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        CustomSizedBox(height: 40),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomLabelTextField(
                                    label: 'First Name',
                                    controller: _authCubit.firstNameController,
                                    hintText: 'John',
                                    labelColor: Colors.white,
                                    filled: false,
                                    onChanged: _authCubit.onFirstNameChanged,
                                  ),
                                  BlocBuilder<AuthCubit, AuthState>(
                                    bloc: _authCubit,
                                    builder: (context, state) {
                                      final error = _authCubit
                                          .getFirstNameError();
                                      if (error != null) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: AppText(
                                            text: error,
                                            style:
                                                AppTextStyles.bodyRegular(
                                                  context,
                                                ).copyWith(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomLabelTextField(
                                    label: 'Last Name',
                                    controller: _authCubit.lastNameController,
                                    hintText: 'Doe',
                                    labelColor: Colors.white,
                                    filled: false,
                                    onChanged: _authCubit.onLastNameChanged,
                                  ),
                                  BlocBuilder<AuthCubit, AuthState>(
                                    bloc: _authCubit,
                                    builder: (context, state) {
                                      final error = _authCubit
                                          .getLastNameError();
                                      if (error != null) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: AppText(
                                            text: error,
                                            style:
                                                AppTextStyles.bodyRegular(
                                                  context,
                                                ).copyWith(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
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
                              hintText: 'jhon@gmail.com',
                              labelColor: Colors.white,
                              filled: false,
                              onChanged: _authCubit.onEmailChanged,
                            ),
                            BlocBuilder<AuthCubit, AuthState>(
                              bloc: _authCubit,
                              builder: (context, state) {
                                final error = _authCubit.getEmailError();
                                if (error != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: AppText(
                                      text: error,
                                      style: AppTextStyles.bodyRegular(context)
                                          .copyWith(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
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
                                _authCubit.phoneController.text =
                                    completePhoneNumber;
                                _authCubit.onPhoneChanged(completePhoneNumber);
                              },
                            ),
                            // Show phone validation error
                            BlocBuilder<AuthCubit, AuthState>(
                              bloc: _authCubit,
                              builder: (context, state) {
                                final phoneError = _authCubit.getPhoneError();
                                if (phoneError != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: AppText(
                                      text: phoneError,
                                      style: AppTextStyles.bodyRegular(context)
                                          .copyWith(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
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
                              hintText: '•••••',
                              labelColor: Colors.white,
                              filled: false,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _authCubit.isObsecure();
                                },
                                icon: Icon(
                                  _authCubit.obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              onChanged: _authCubit.onPasswordChanged,
                            ),
                            BlocBuilder<AuthCubit, AuthState>(
                              bloc: _authCubit,
                              builder: (context, state) {
                                final error = _authCubit.getPasswordError();
                                if (error != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: AppText(
                                      text: error,
                                      style: AppTextStyles.bodyRegular(context)
                                          .copyWith(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                        CustomSizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomLabelTextField(
                              label: 'Confirm Password',
                              controller: _authCubit.confirmPasswordController,
                              obscureText: _authCubit.obscureConfirmPassword,
                              hintText: '•••••••••••••',
                              labelColor: Colors.white,
                              filled: false,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _authCubit.isObsecureConfirm();
                                },
                                icon: Icon(
                                  _authCubit.obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              onChanged: _authCubit.onConfirmPasswordChanged,
                            ),
                            BlocBuilder<AuthCubit, AuthState>(
                              bloc: _authCubit,
                              builder: (context, state) {
                                final error = _authCubit
                                    .getConfirmPasswordError();
                                if (error != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: AppText(
                                      text: error,
                                      style: AppTextStyles.bodyRegular(context)
                                          .copyWith(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                        CustomSizedBox(height: 40),

                        // Terms and Privacy
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'By signing up, you agree to our ',
                            style: AppTextStyles.bodyLarge(
                              context,
                            ).copyWith(color: Colors.white70, fontSize: 12),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    TermsBottomSheet.show(context);
                                  },
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    PrivacyBottomSheet.show(context);
                                  },
                              ),
                            ],
                          ),
                        ),
                        CustomSizedBox(height: 24),

                        // Sign Up Button
                        CustomElevatedButton(
                          onTap: () {
                            // Validate all fields individually
                            final firstNameError = _authCubit.validateName(
                              _authCubit.firstNameController.text,
                            );
                            final lastNameError = _authCubit.validateName(
                              _authCubit.lastNameController.text,
                            );
                            final emailError = _authCubit.validateEmail(
                              _authCubit.emailController.text,
                            );
                            final phoneError = _authCubit.validatePhoneNumber(
                              _authCubit.phoneController.text,
                            );
                            final passwordError = _authCubit.validatePassword(
                              _authCubit.passwordController.text,
                            );
                            final confirmPasswordError = _authCubit
                                .validateConfirmPassword(
                                  _authCubit.confirmPasswordController.text,
                                  _authCubit.passwordController.text,
                                );

                            if (firstNameError == null &&
                                lastNameError == null &&
                                emailError == null &&
                                phoneError == null &&
                                passwordError == null &&
                                confirmPasswordError == null) {
                              AutoRouter.of(
                                context,
                              ).replace(const VerifyPhoneNumberRoute());
                            } else {
                              // Mark all fields as touched to show validation errors
                              if (firstNameError != null) {
                                _authCubit.onFirstNameChanged(
                                  _authCubit.firstNameController.text,
                                );
                              }
                              if (lastNameError != null) {
                                _authCubit.onLastNameChanged(
                                  _authCubit.lastNameController.text,
                                );
                              }
                              if (emailError != null) {
                                _authCubit.onEmailChanged(
                                  _authCubit.emailController.text,
                                );
                              }
                              if (phoneError != null) {
                                _authCubit.onPhoneChanged(
                                  _authCubit.phoneController.text,
                                );
                              }
                              if (passwordError != null) {
                                _authCubit.onPasswordChanged(
                                  _authCubit.passwordController.text,
                                );
                              }
                              if (confirmPasswordError != null) {
                                _authCubit.onConfirmPasswordChanged(
                                  _authCubit.confirmPasswordController.text,
                                );
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
      ),
    );
  }
}
