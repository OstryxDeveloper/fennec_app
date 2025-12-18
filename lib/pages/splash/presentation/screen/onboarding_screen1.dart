import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/constants/media_query_constants.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/pages/splash/presentation/widgets/onboarding_widget1.dart';
import 'package:fennac_app/pages/splash/presentation/widgets/onboarding_widget4.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class OnBoardingScreen1 extends StatefulWidget {
  const OnBoardingScreen1({super.key});

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _buttonController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _buttonFadeAnimation;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Button animation controller
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    // Text animations
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Button animations
    _buttonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
        );

    _buttonFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _buttonController, curve: Curves.easeIn));
  }

  void _startAnimationSequence() async {
    // Start logo animation immediately
    await _logoController.forward();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 100));
    await _textController.forward();

    // Start button animation after text
    await Future.delayed(const Duration(milliseconds: 100));
    await _buttonController.forward();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      AutoRouter.of(context).replace(const CreateAccountRoute());
    }
  }

  void _skipToEnd() {
    AutoRouter.of(context).replace(const DashboardRoute());
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MovableBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    OnBoardingWidget1(),
                    _buildPage2(),
                    _buildPage3(),
                    OnBoardingWidget4(),
                  ],
                ),
              ),

              AnimatedBuilder(
                animation: _buttonController,
                builder: (context, child) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 40.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _skipToEnd,
                          child: AppText(
                            text: 'Skip',
                            style: AppTextStyles.bodyLarge(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            4,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: _currentPage == index ? 24 : 10,
                              height: _currentPage == index ? 24 : 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? ColorPalette.primary
                                    : Colors.white,
                                border: Border.all(
                                  color: _currentPage == index
                                      ? ColorPalette.white
                                      : Colors.transparent,
                                  width: 2.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _nextPage,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette.primary,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: ColorPalette.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stack to overlay animations
        LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: getHeight(context) * 0.6,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Lottie.asset(
                      Assets.animations.emojis6s,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned.fill(
                    child: Lottie.asset(
                      Assets.animations.scrollingMessagesTopOpacity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
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
    );
  }

  Widget _buildPage3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'splash_logo',
          child: AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _logoFadeAnimation,
                child: ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(
                        Assets.animations.rotatingGroupAnimationNoShadow,
                        repeat: true,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              AppText(
                text: 'Match in Groups',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1(
                  context,
                ).copyWith(color: Colors.white, fontSize: 32),
              ),
              const SizedBox(height: 24),
              AppText(
                text: 'Find other groups that match your vibe ',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge(
                  context,
                ).copyWith(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
