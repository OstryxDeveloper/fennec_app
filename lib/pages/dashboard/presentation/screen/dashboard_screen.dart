import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: MovableBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 400,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Lottie.asset(
                          Assets.animations.welcomeScreenAnimationNoShadow,
                          repeat: true,
                          fit: BoxFit.fill,
                        ),
                        SvgPicture.asset(
                          Assets.icons.fennecLogoWithText.path,
                          width: 120,
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomElevatedButton(
                    width: 0.9.sw,
                    text: 'Create your Account',
                    onTap: () {
                      AutoRouter.of(context).push(const CreateAccountRoute());
                    },
                  ),

                  const SizedBox(height: 16),

                  CustomOutlinedButton(
                    width: 0.9.sw,
                    onPressed: () {
                      AutoRouter.of(context).push(const LoginRoute());
                    },
                    text: 'Login with Email',
                  ),
                  const SizedBox(height: 24),

                  AppText(
                    text: 'or continue with',
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorPalette.secondry,
                          boxShadow: [
                            BoxShadow(
                              color: ColorPalette.secondry.withOpacity(0.6),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Assets.icons.google.svg(width: 24, height: 24),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorPalette.secondry,
                          boxShadow: [
                            BoxShadow(
                              color: ColorPalette.secondry.withOpacity(0.6),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Assets.icons.facebook.svg(
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorPalette.secondry,
                          boxShadow: [
                            BoxShadow(
                              color: ColorPalette.secondry.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Assets.icons.apple.svg(
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
