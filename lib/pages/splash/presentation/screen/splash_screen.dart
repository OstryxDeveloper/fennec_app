import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/movable_background.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoScaleAnimation;
  // ignore: unused_field
  late final Animation<double> _logoFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startFlow();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));
  }

  Future<void> _startFlow() async {
    // Animate in
    await _logoController.forward();

    // Keep splash visible
    await Future.delayed(const Duration(seconds: 3));

    // Animate out
    // await _logoController.reverse();

    if (!mounted) return;

    context.router.replace(const OnBoardingRoute());
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MovableBackground(
        child: SafeArea(
          child: Center(
            child: ScaleTransition(
              scale: _logoScaleAnimation,
              child: Hero(
                tag: 'splash_logo',
                child: Lottie.asset(
                  Assets.animations.fennecLogoAnimation,
                  repeat: false,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
