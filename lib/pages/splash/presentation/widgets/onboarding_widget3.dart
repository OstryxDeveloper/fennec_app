import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingWidget3 extends StatefulWidget {
  const OnboardingWidget3({super.key});

  @override
  State<OnboardingWidget3> createState() => _OnboardingWidget3State();
}

class _OnboardingWidget3State extends State<OnboardingWidget3> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'splash_logo',
          child: Stack(
            alignment: Alignment.center,
            children: [
              Lottie.asset(
                Assets.animations.rotatingGroupAnimationNoShadowDotted,
                repeat: true,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              AppText(
                text: 'Match in Groups',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1(context).copyWith(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              AppText(
                text: 'Find other groups that match your vibe',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge(
                  context,
                ).copyWith(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
