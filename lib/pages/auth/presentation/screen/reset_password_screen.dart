import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_country_field.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../routes/routes_imports.gr.dart';
import '../../../../widgets/custom_bottom_sheet.dart';

@RoutePage()
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _countryCodeController = TextEditingController();

  final _authCubit = Di().sl<AuthCubit>();

  @override
  void dispose() {
    _emailController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          text: 'Reset your password',
                          style: AppTextStyles.h1(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        CustomSizedBox(height: 12),

                        AppText(
                          text:
                              "Enter your email and we’ll send you a code to reset your password.",
                          style: AppTextStyles.bodyLarge(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        CustomSizedBox(height: 40),

                        if (_authCubit.isEmail)
                          CustomLabelTextField(
                            label: _authCubit.isEmail
                                ? 'Email'
                                : 'Phone Number',
                            controller: _emailController,
                            validator: _authCubit.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'johndoe@email.com',
                            labelColor: Colors.white,
                            filled: false,
                          ),
                        if (!_authCubit.isEmail)
                          UnderlineCountryPickerField(
                            label: 'Country',
                            hintText: 'Select your country',

                            onChanged: (country) {
                              print(country.name);
                            },
                          ),

                        CustomSizedBox(height: 40),

                        CustomElevatedButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              // AutoRouter.of(context).pop();
                              CustomBottomSheet.show(
                                context: context,
                                title: 'Reset code sent!',
                                description:
                                    "We've sent a 6-digit code to you. Continue to reset your password.",
                                buttonText: 'Continue',
                                onButtonPressed: () {
                                  AutoRouter.of(
                                    context,
                                  ).push(OtpVerificationRoute());
                                },
                                icon: Container(
                                  // Example icon wrapper
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.green,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 50,
                                  ),
                                ),
                              );
                            }
                          },
                          text: 'Send reset code',
                          width: double.infinity,
                        ),
                        CustomSizedBox(height: 40),
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
                                text: 'Can’t access your email?',
                                style: AppTextStyles.bodyLarge(
                                  context,
                                ).copyWith(color: Colors.white),
                              ),
                              InkWell(
                                onTap: () {
                                  _authCubit.isEmailOrPhone();
                                },
                                child: AppText(
                                  text: _authCubit.isEmail
                                      ? 'Use Phone Number'
                                      : 'Use Email',
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
