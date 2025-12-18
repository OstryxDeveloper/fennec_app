import 'dart:ui';

import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class OnBoardingWidget4 extends StatelessWidget {
  const OnBoardingWidget4({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Top left emoji (eyes)
                  _buildFloatingEmoji(
                    Assets.icons.eyeEmoji.path,
                    top: 40,
                    left: 40,
                    delay: 0,
                  ),
                  // Top right emoji (handshake)
                  _buildFloatingEmoji(
                    Assets.icons.handshake.path,
                    top: 60,
                    right: 60,
                    delay: 300,
                  ),
                  // Bottom left emoji (checkmark badge)
                  _buildFloatingEmoji(
                    Assets.icons.verifiedBadge.path,
                    bottom: 480,
                    left: 30,
                    delay: 600,
                  ),
                  // Bottom right emoji (group)
                  _buildFloatingEmoji(
                    Assets.icons.people.path,
                    bottom: 480,
                    right: 40,
                    delay: 900,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 160),
                      child: Image.asset(
                        Assets.images.mobile.path,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 40,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0.01),
                                Colors.black.withOpacity(0.005),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Your Group,\nYour Rules',
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
                                'Customize your groups\' profile to match your energy',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyLarge(
                                  context,
                                ).copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildFloatingEmoji(
    String assetPath, {
    double? top,
    double? bottom,
    double? left,
    double? right,
    int delay = 0,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.6 + (value * 0.4),
            child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
          );
        },
        child: _AnimatedFloatingIcon(assetPath: assetPath, delay: delay),
      ),
    );
  }
}

// Animated floating icon widget with continuous animation
class _AnimatedFloatingIcon extends StatefulWidget {
  final String assetPath;
  final int delay;

  const _AnimatedFloatingIcon({required this.assetPath, required this.delay});

  @override
  State<_AnimatedFloatingIcon> createState() => _AnimatedFloatingIconState();
}

class _AnimatedFloatingIconState extends State<_AnimatedFloatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorPalette.primary.withOpacity(
                      (0.4 * _scaleAnimation.value).clamp(0.0, 1.0),
                    ),
                    blurRadius: 24 * _scaleAnimation.value,
                    spreadRadius: 2,
                    offset: Offset(0, 12 * _scaleAnimation.value),
                  ),
                  BoxShadow(
                    color: Color(0xFF6366f1).withOpacity(
                      (0.2 * _scaleAnimation.value).clamp(0.0, 1.0),
                    ),
                    blurRadius: 32 * _scaleAnimation.value,
                    spreadRadius: 0,
                    offset: Offset(0, 8 * _scaleAnimation.value),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
                child: Image.asset(
                  widget.assetPath,
                  fit: BoxFit.contain,
                  height: 100,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
