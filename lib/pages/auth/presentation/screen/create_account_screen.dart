import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/helpers/toast_helper.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/cubit/auth_cubit.dart';
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
    _authCubit.firstNameController.addListener(_validateAllFields);
    _authCubit.lastNameController.addListener(_validateAllFields);
    _authCubit.emailController.addListener(_validateAllFields);
    _authCubit.phoneController.addListener(_validateAllFields);
    _authCubit.passwordController.addListener(_validateAllFields);
    _authCubit.confirmPasswordController.addListener(_validateAllFields);
  }

  @override
  void dispose() {
    _authCubit.firstNameController.removeListener(_validateAllFields);
    _authCubit.lastNameController.removeListener(_validateAllFields);
    _authCubit.emailController.removeListener(_validateAllFields);
    _authCubit.phoneController.removeListener(_validateAllFields);
    _authCubit.passwordController.removeListener(_validateAllFields);
    _authCubit.confirmPasswordController.removeListener(_validateAllFields);
    super.dispose();
  }

  void _validateAllFields() {
    if (_authCubit.formKey.currentState != null) {
      _authCubit.formKey.currentState!.validate();
    }
    if (mounted) {
      setState(() {});
    }
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              child: CustomLabelTextField(
                                label: 'First Name',
                                controller: _authCubit.firstNameController,
                                validator: _authCubit.validateName,
                                hintText: 'John',
                                labelColor: Colors.white,
                                filled: false,
                                onChanged: (_) => _validateAllFields(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomLabelTextField(
                                label: 'Last Name',
                                controller: _authCubit.lastNameController,
                                validator: _authCubit.validateName,
                                hintText: 'Doe',
                                labelColor: Colors.white,
                                filled: false,
                                onChanged: (_) => _validateAllFields(),
                              ),
                            ),
                          ],
                        ),
                        CustomSizedBox(height: 24),

                        CustomLabelTextField(
                          label: 'Email',
                          controller: _authCubit.emailController,
                          validator: _authCubit.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'jhon@gmail.com',
                          labelColor: Colors.white,
                          filled: false,
                          onChanged: (_) => _validateAllFields(),
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
                                _validateAllFields();
                              },
                              validator: _authCubit.validatePhoneNumber,
                            ),
                            // Show phone validation error
                            Builder(
                              builder: (context) {
                                final phoneError = _authCubit
                                    .validatePhoneNumber(
                                      _authCubit.phoneController.text,
                                    );
                                if (phoneError != null &&
                                    _authCubit
                                        .phoneController
                                        .text
                                        .isNotEmpty) {
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

                        CustomLabelTextField(
                          label: 'Password',
                          controller: _authCubit.passwordController,
                          validator: _authCubit.validatePassword,
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
                          onChanged: (_) => _validateAllFields(),
                        ),
                        CustomSizedBox(height: 24),
                        CustomLabelTextField(
                          label: 'Confirm Password',
                          controller: _authCubit.confirmPasswordController,
                          validator: (val) =>
                              _authCubit.validateConfirmPassword(
                                val,
                                _authCubit.passwordController.text,
                              ),
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
                          onChanged: (_) => _validateAllFields(),
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
                            if (_authCubit.formKey.currentState?.validate() ??
                                false) {
                              final phoneError = _authCubit.validatePhoneNumber(
                                _authCubit.phoneController.text,
                              );
                              if (phoneError != null) {
                                VxToast.show(
                                  msg: phoneError,
                                  bgColor: Colors.red,
                                );

                                return;
                              }

                              AutoRouter.of(
                                context,
                              ).replace(const VerifyPhoneNumberRoute());
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
