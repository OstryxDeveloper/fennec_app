import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/movable_background.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../routes/routes_imports.gr.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_text.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;
  late final AnimationController _textController;

  late final Animation<Offset> _textSlideAnimation;
  late final Animation<Offset> _logoSlideAnimation;
  late final Animation<double> _textFadeAnimation;

  late final AnimationController _logoController;
  late final Animation<Offset> _logoAndTextSlideAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final AnimationController _welcomeController;
  late final Animation<double> _welcomeScaleAnimation;

  late final Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(vsync: this);

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _logoSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _logoAndTextSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: Offset(0, -0.65)).animate(
          CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
        );

    _textFadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _welcomeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _welcomeScaleAnimation = Tween<double>(begin: 10, end: 1).animate(
      CurvedAnimation(parent: _welcomeController, curve: Curves.easeOut),
    );
    _buttonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _welcomeController,
            curve: Curves.easeOutCubic,
          ),
        );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _textController.forward();
        Future.delayed(const Duration(seconds: 1), () {
          _logoController.forward();
          _logoController.addListener(() {
            if (_logoController.isCompleted) {
              _welcomeController.forward();
            }
          });
        });
        Future.delayed(const Duration(seconds: 1), () {
          // context.router.replace(const OnBoardingRoute());
        });
      }
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _textController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MovableBackground(
        backgroundType: MovableBackgroundType.medium,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// 1️⃣ BACKGROUND / WELCOME ANIMATION (UNDER EVERYTHING)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                left: 0,
                right: 0,
                top: _logoAndTextSlideAnimation.value.dy + 50,
                child: ScaleTransition(
                  scale: _welcomeScaleAnimation,
                  child: Lottie.asset(
                    Assets.animations.welcomeScreenAnimationRoadNoShadowDashed,
                    repeat: true,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// 2️⃣ LOGO + TEXT (ABOVE)
              SlideTransition(
                position: _logoAndTextSlideAnimation,
                child: ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SlideTransition(
                        position: _logoSlideAnimation,
                        child: Lottie.asset(
                          Assets.animations.fennecLogoAnimation,
                          controller: _lottieController,
                          repeat: false,
                          fit: BoxFit.contain,
                          onLoaded: (composition) {
                            _lottieController
                              ..duration = composition.duration
                              ..forward();
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _textFadeAnimation,
                        child: SlideTransition(
                          position: _textSlideAnimation,
                          child: SvgPicture.asset(
                            Assets.icons.fennecLogoText.path,
                            width: 200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                bottom: 10,
                child: SlideTransition(
                  position: _buttonSlideAnimation,
                  child: Column(
                    children: [
                      AppText(
                        text: 'Find your vibe\n-\ttogether.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h1(context),
                      ),
                      SizedBox(height: 72.h),
                      CustomElevatedButton(
                        width: 0.9.sw,
                        text: 'Get Started',
                        onTap: () {
                          AutoRouter.of(context).replace(const LandingRoute());
                        },
                        icon: Assets.icons.arrowRight.svg(
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            ColorPalette.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
