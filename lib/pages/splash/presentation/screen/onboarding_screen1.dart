import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/splash/presentation/bloc/cubit/background_cubit.dart';
import 'package:fennac_app/pages/splash/presentation/widgets/onboarding_widget1.dart';
import 'package:fennac_app/pages/splash/presentation/widgets/onboarding_widget2.dart';
import 'package:fennac_app/pages/splash/presentation/widgets/onboarding_widget3.dart';
import 'package:fennac_app/pages/splash/presentation/widgets/onboarding_widget4.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  final PageController _pageController = PageController();
  final BackgroundCubit _backgroundCubit = Di().sl<BackgroundCubit>();
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
    if (_backgroundCubit.selectedIndex < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      AutoRouter.of(context).replace(const CreateAccountRoute());
    }
  }

  void _skipToEnd() {
    AutoRouter.of(context).replace(const CreateAccountRoute());
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    if (_pageController.hasClients &&
                        _backgroundCubit.selectedIndex > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else if (_backgroundCubit.selectedIndex == 0) {
                      AutoRouter.of(context).pop();
                    }
                  },
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _backgroundCubit.selectIndex(index);
                  },
                  children: [
                    OnBoardingWidget1(),
                    OnboardingWidget2(),
                    OnboardingWidget3(),
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
                      vertical: 20.h,
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
                        BlocBuilder(
                          bloc: _backgroundCubit,
                          builder: (context, state) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                4,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  width: _backgroundCubit.selectedIndex == index
                                      ? 24
                                      : 10,
                                  height:
                                      _backgroundCubit.selectedIndex == index
                                      ? 24
                                      : 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        _backgroundCubit.selectedIndex == index
                                        ? ColorPalette.primary
                                        : Colors.white,
                                    border: Border.all(
                                      color:
                                          _backgroundCubit.selectedIndex ==
                                              index
                                          ? ColorPalette.white
                                          : Colors.transparent,
                                      width: 2.2,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
}
