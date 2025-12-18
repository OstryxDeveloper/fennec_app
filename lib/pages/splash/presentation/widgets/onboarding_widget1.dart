import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingWidget1 extends StatelessWidget {
  const OnBoardingWidget1({super.key});

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
                          bottom: 180,
                          left: 30,
                          child: _buildHeartIcon(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
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
                            color: Colors.white.withOpacity(0.7),
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
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            ColorPalette.secondry,
            ColorPalette.primary,
            ColorPalette.secondry,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF1E1E2E),
        ),
        padding: const EdgeInsets.all(4),
        child: ClipOval(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 260,
            height: 260,
          ),
        ),
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
          colors: [ColorPalette.primary, ColorPalette.secondry],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withOpacity(0.5),
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
