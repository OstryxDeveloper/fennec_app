import 'dart:ui';

import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:flutter/material.dart';

class OnBoardingWidget4 extends StatelessWidget {
  const OnBoardingWidget4({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    final topIconsTop = screenHeight * 0.02;
    final bottomIconsBottom = screenHeight * 0.52;
    final mobileImageTopPadding = screenHeight * 0.17;
    final textContainerHeight = screenHeight * 0.3;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Top icons row
                  Positioned(
                    top: topIconsTop,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _AnimatedFloatingIcon(
                            assetPath: Assets.icons.eyeEmoji.path,
                            delay: 0,
                            color: Colors.white,
                            size: screenWidth * 0.18,
                          ),
                          SizedBox(width: screenWidth * 0.2),
                          _AnimatedFloatingIcon(
                            assetPath: Assets.icons.handshake.path,
                            delay: 150,
                            color: Colors.white,
                            size: screenWidth * 0.18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom icons row
                  Positioned(
                    bottom: bottomIconsBottom,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _AnimatedFloatingIcon(
                            assetPath: Assets.icons.verifiedBadge.path,
                            delay: 300,
                            color: ColorPalette.green,
                            size: screenWidth * 0.18,
                          ),
                          _AnimatedFloatingIcon(
                            assetPath: Assets.icons.people.path,
                            delay: 450,
                            color: Colors.white,
                            size: screenWidth * 0.18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Center mobile image
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: mobileImageTopPadding),
                      child: Image.asset(
                        Assets.images.mobile.path,
                        fit: BoxFit.contain,
                        height: screenHeight * 0.6,
                      ),
                    ),
                  ),

                  // Bottom text with blur
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: textContainerHeight,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              int steps = 60;
                              return Stack(
                                children: List.generate(steps, (index) {
                                  double fraction = index / steps;
                                  double sigmaY = 1 + fraction * 30;
                                  double sigmaX = 0.5 + fraction * 1;
                                  return Positioned(
                                    top: constraints.maxHeight * fraction,
                                    left: 0,
                                    right: 0,
                                    height: constraints.maxHeight / steps,
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: sigmaX,
                                          sigmaY: sigmaY,
                                        ),
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                            ),
                            margin: EdgeInsets.only(top: screenHeight * 0.04),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Spacer(),
                                Text(
                                  'Your Group,\nYour Rules',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.h1(context).copyWith(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CustomSizedBox(height: 16),
                                Text(
                                  'Customize your groups\' profile to match your energy',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyLarge(context)
                                      .copyWith(
                                        color: Colors.white54,
                                        fontSize: 16,
                                      ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
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
}

class _AnimatedFloatingIcon extends StatefulWidget {
  final String assetPath;
  final int delay;
  final Color color;
  final double size;

  const _AnimatedFloatingIcon({
    required this.assetPath,
    required this.delay,
    required this.color,
    required this.size,
  });

  @override
  State<_AnimatedFloatingIcon> createState() => _AnimatedFloatingIconState();
}

class _AnimatedFloatingIconState extends State<_AnimatedFloatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      _startPeriodicAnimation();
    });
  }

  void _startPeriodicAnimation() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        await _controller.forward();
        if (mounted) {
          await _controller.reverse();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.05),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: widget.color.withOpacity(0.1),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(widget.assetPath, fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }
}
