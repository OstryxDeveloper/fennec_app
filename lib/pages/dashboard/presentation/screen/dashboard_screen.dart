import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  Future<void> cacheImages(BuildContext context) async {
    final imageAssets = [
      Assets.images.boysGroup.path,
      Assets.images.girlsGroup.path,
      Assets.images.mobile.path,
    ];

    for (final assetPath in imageAssets) {
      try {
        await precacheImage(AssetImage(assetPath), context);
      } catch (e) {
        debugPrint('Failed to precache image: $assetPath - $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Set system UI overlay style to match dark background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0D0D0D),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scale = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      cacheImages(context); // Now async, won't block
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _socialIcon(Widget icon) {
    return Container(
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
      child: IconButton(onPressed: () {}, icon: icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: MovableBackground(
        child: SafeArea(
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
              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Column(
                      children: [
                        CustomElevatedButton(
                          width: 0.9.sw,
                          text: 'Create your Account',
                          onTap: () {
                            AutoRouter.of(
                              context,
                            ).push(const OnBoardingRoute1());
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
                            _socialIcon(
                              Assets.icons.google.svg(width: 24, height: 24),
                            ),
                            const SizedBox(width: 16),
                            _socialIcon(
                              Assets.icons.facebook.svg(width: 24, height: 24),
                            ),
                            const SizedBox(width: 16),
                            _socialIcon(
                              Assets.icons.apple.svg(
                                width: 24,
                                height: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
