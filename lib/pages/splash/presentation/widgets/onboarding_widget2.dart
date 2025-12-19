import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingWidget2 extends StatelessWidget {
  const OnboardingWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Lottie.asset(Assets.animations.emojis7s, fit: BoxFit.cover),
          ),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Lottie.asset(
                    Assets.animations.scrollingMessagesTopOpacity,
                    fit: BoxFit.contain,
                  ),
                  AppText(
                    text: 'Group Chats that\nStay Alive',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h1(
                      context,
                    ).copyWith(color: Colors.white, fontSize: 32),
                  ),
                  const SizedBox(height: 24),
                  AppText(
                    text:
                        'Dive into a shared chat room, Have fun with your friends',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge(
                      context,
                    ).copyWith(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
