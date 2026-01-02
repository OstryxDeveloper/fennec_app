import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:fennac_app/pages/auth/presentation/bloc/state/auth_state.dart';
import 'package:fennac_app/reusable_widgets/animated_background_container.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_text_field.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authCubit = Di().sl<AuthCubit>();

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
                  child: BlocBuilder<AuthCubit, AuthState>(
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
                            CustomSizedBox(height: 40),
                            AnimatedBackgroundContainer(
                              icon: Assets.icons.vector4.path,
                            ),
                            CustomSizedBox(height: 40),
                            AppText(
                              text: 'Set New Password',
                              style: AppTextStyles.h1(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            CustomSizedBox(height: 12),
                            AppText(
                              text:
                                  'Enter a new password to access your account.',
                              style: AppTextStyles.bodyLarge(context).copyWith(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            CustomSizedBox(height: 40),
                            // New Password Field
                            CustomLabelTextField(
                              label: 'New Password',
                              controller: _authCubit.newPasswordController,
                              validator: (value) {
                                final error = _authCubit.getNewPasswordError();
                                return error;
                              },
                              obscureText: _authCubit.obscureNewPassword,
                              onChanged: (value) {
                                _authCubit.onNewPasswordChanged(value);
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _authCubit.obscureNewPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _authCubit.toggleNewPasswordVisibility();
                                },
                              ),
                              labelColor:
                                  _authCubit.getNewPasswordError() != null
                                  ? ColorPalette.error
                                  : Colors.white,
                              filled: false,
                            ),
                            if (_authCubit.getNewPasswordError() != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8, left: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: ColorPalette.error,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: AppText(
                                        text: _authCubit.getNewPasswordError()!,
                                        style:
                                            AppTextStyles.bodyRegular(
                                              context,
                                            ).copyWith(
                                              color: ColorPalette.error,
                                              fontSize: 12,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            CustomSizedBox(height: 24),
                            // Confirm New Password Field
                            CustomLabelTextField(
                              label: 'Confirm New Password',
                              controller:
                                  _authCubit.confirmNewPasswordController,
                              validator: (value) {
                                final error = _authCubit
                                    .getConfirmNewPasswordError();
                                return error;
                              },
                              obscureText: _authCubit.obscureConfirmNewPassword,
                              onChanged: (value) {
                                _authCubit.onConfirmNewPasswordChanged(value);
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _authCubit.obscureConfirmNewPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _authCubit
                                      .toggleConfirmNewPasswordVisibility();
                                },
                              ),
                              labelColor:
                                  _authCubit.getConfirmNewPasswordError() !=
                                      null
                                  ? ColorPalette.error
                                  : Colors.white,
                              filled: false,
                            ),
                            if (_authCubit.getConfirmNewPasswordError() != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8, left: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: ColorPalette.error,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: AppText(
                                        text: _authCubit
                                            .getConfirmNewPasswordError()!,
                                        style:
                                            AppTextStyles.bodyRegular(
                                              context,
                                            ).copyWith(
                                              color: ColorPalette.error,
                                              fontSize: 12,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            CustomSizedBox(height: 40),
                            CustomElevatedButton(
                              onTap: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  AutoRouter.of(
                                    context,
                                  ).replace(OnBoardingRoute());
                                } else {
                                  _authCubit.submitNewPassword();
                                }
                              },
                              text: 'Update Password',
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
        ],
      ),
    );
  }
}
