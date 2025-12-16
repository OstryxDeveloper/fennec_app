import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authCubit = Di().sl<AuthCubit>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

                        CustomBackButton(),

                        CustomSizedBox(height: 40),

                        SvgPicture.asset(
                          Assets.icons.logoAnimation.path,
                          width: 100,
                          height: 100,
                        ),

                        CustomSizedBox(height: 40),

                        AppText(
                          text: 'Login to your account',
                          style: AppTextStyles.h1(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        CustomSizedBox(height: 40),

                        CustomLabelTextField(
                          label: 'Email',
                          controller: _emailController,
                          validator: _authCubit.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'johndoe@email.com',
                          labelColor: Colors.white,
                          filled: false,
                        ),

                        CustomSizedBox(height: 24),

                        CustomLabelTextField(
                          label: 'Password',
                          controller: _passwordController,
                          validator: _authCubit.validatePassword,
                          obscureText: _authCubit.obscurePassword,
                          hintText: '••••••••••',
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
                              color: Colors.white70,
                            ),
                          ),
                        ),

                        CustomSizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              AutoRouter.of(
                                context,
                              ).push(const ResetPasswordRoute());
                            },
                            child: AppText(
                              text: 'Forgot Password?',
                              style: AppTextStyles.bodyLarge(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        CustomSizedBox(height: 40),

                        CustomElevatedButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              AutoRouter.of(context).pop();
                            }
                          },
                          text: 'Login',
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
