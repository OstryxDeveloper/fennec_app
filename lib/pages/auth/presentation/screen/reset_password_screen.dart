import 'dart:ui';
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
import 'package:lottie/lottie.dart';

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
  bool _isBackgroundBlurred = false;

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
      body: Stack(
        children: [
          MovableBackground(
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
                                    Assets.icons.vector3.path,
                                    height: 40,
                                    width: 40,
                                  ),
                                ],
                              ),
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
                              PhoneNumberField(
                                label: 'Country',
                                hintText: 'Select your country',

                                onChanged: (country) {},
                              ),

                            CustomSizedBox(height: 40),

                            CustomElevatedButton(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isBackgroundBlurred = true;
                                  });

                                  await CustomBottomSheet.show(
                                    context: context,
                                    barrierColor: Colors.transparent,
                                    title: 'Reset code sent!',
                                    description:
                                        "We've sent a 6-digit code to you. Continue to reset your password.",
                                    buttonText: 'Continue',
                                    onButtonPressed: () {
                                      AutoRouter.of(context).pop();
                                      AutoRouter.of(
                                        context,
                                      ).push(OtpVerificationRoute());
                                    },
                                    icon: SizedBox(
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
                                          Image.asset(
                                            Assets.icons.checkGreen.path,
                                            height: 72,
                                            width: 72,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );

                                  setState(() {
                                    _isBackgroundBlurred = false;
                                  });
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
          if (_isBackgroundBlurred)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withOpacity(0.1)),
              ),
            ),
        ],
      ),
    );
  }
}
