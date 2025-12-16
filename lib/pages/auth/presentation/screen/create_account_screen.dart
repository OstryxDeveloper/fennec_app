import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_country_field.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authCubit = Di().sl<AuthCubit>();

  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    // Set default country if needed, e.g. US
    loadCountries().then((countries) {
      if (mounted) {
        setState(() {
          _selectedCountry = countries.firstWhere(
            (c) => c.iso == 'US',
            orElse: () => countries.first,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                    key: _formKey,
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

                        // First Name & Last Name
                        Row(
                          children: [
                            Expanded(
                              child: CustomLabelTextField(
                                label: 'First Name',
                                controller: _firstNameController,
                                validator: _authCubit.validateName,
                                hintText: 'John',
                                labelColor: Colors.white,
                                filled: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomLabelTextField(
                                label: 'Last Name',
                                controller: _lastNameController,
                                validator: _authCubit.validateName,
                                hintText: 'Doe',
                                labelColor: Colors.white,
                                filled: false,
                              ),
                            ),
                          ],
                        ),
                        CustomSizedBox(height: 24),

                        // Email
                        CustomLabelTextField(
                          label: 'Email',
                          controller: _emailController,
                          validator: _authCubit.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'johndoe.email.com',
                          labelColor: Colors.white,
                          filled: false,
                        ),
                        CustomSizedBox(height: 24),

                        // Phone Number
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Phone Number',
                              style: AppTextStyles.bodyLarge(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            CustomSizedBox(height: 8),
                            Row(
                              children: [
                                // Country Flag Picker (Simplified)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        _selectedCountry?.flag ?? '🇺🇸',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 18,
                                        color: Colors.white70,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Phone Input
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: '(234) 222 345',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white24,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorPalette.primary,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Error text placeholder if needed
                          ],
                        ),
                        CustomSizedBox(height: 24),

                        // Password
                        CustomLabelTextField(
                          label: 'Password',
                          controller: _passwordController,
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
                        ),
                        CustomSizedBox(height: 24),

                        // Confirm Password
                        CustomLabelTextField(
                          label: 'Confirm Password',
                          controller: _confirmPasswordController,
                          validator: (val) =>
                              _authCubit.validateConfirmPassword(
                                val,
                                _passwordController.text,
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
                            if (_formKey.currentState!.validate()) {
                              // Handle sign up
                              AutoRouter.of(
                                context,
                              ).replace(const DashboardRoute());
                            }
                          },
                          text:
                              'Sign Up', // Or "Create Account" ? Design doesn't show button text but "Create Your Account" title implies it.
                          // Login screen had "Login". I'll use "Sign Up" or "Create Account".
                          // Screenshot cuts off the button but usually it's "Sign Up".
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
