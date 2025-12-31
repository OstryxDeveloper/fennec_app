import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class OnBoardingWidget1 extends StatefulWidget {
  const OnBoardingWidget1({super.key});

  @override
  State<OnBoardingWidget1> createState() => _OnBoardingWidget1State();
}

class _OnBoardingWidget1State extends State<OnBoardingWidget1> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Two overlapping circular images with gradient borders
                  SizedBox(
                    height: 450,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          left: 20,
                          child: _buildCircularImage(
                            Assets.images.boysGroup.path,
                            isTop: true,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 20,
                          child: _buildCircularImage(
                            Assets.images.girlsGroup.path,
                            isTop: false,
                          ),
                        ),
                        // Heart icons
                        Positioned(
                          top: 130,
                          right: 60,
                          child: _buildHeartIcon(),
                        ),
                        Positioned(
                          bottom: 130,
                          left: 60,
                          child: _buildHeartIcon(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Text content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Text(
                          'The Safer Way\nTo Date',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Stay safe, go out with a group',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCircularImage(String imagePath, {required bool isTop}) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset(
            Assets.animations.iconBg,
            width: 268,
            height: 268,
            fit: BoxFit.cover,
          ),
          ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: 260,
              height: 260,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartIcon() {
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [ColorPalette.primary, ColorPalette.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SvgPicture.asset(Assets.icons.heart.path, width: 30, height: 20),
    );
  }
}
