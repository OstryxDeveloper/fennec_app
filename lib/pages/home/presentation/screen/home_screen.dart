import 'dart:developer';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/constants/app_enums.dart';
import 'package:fennac_app/app/constants/dummy_constants.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/pages/home/presentation/widgets/hero_section.dart';
import 'package:fennac_app/pages/home/presentation/widgets/home_top_bar.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_emojis.dart';
import '../../../../generated/assets.gen.dart';
import '../swipe/swipe_card.dart';
import '../swipe/swipe_controller.dart';
import '../widgets/all_caught_up_widget.dart';
import '../widgets/home_card_design.dart';
import '../widgets/send_poke_bottomsheet.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController crossAnimationController;
  late final AnimationController checkAnimationController;
  late final AnimationController endFadeController;
  late final Animation<double> endFadeAnimation;

  late Animation<double> crossSizeAnimation;
  late Animation<double> crossFadeAnimation;
  late Animation<Offset> crossSlideAnimation;

  late Animation<double> checkSizeAnimation;
  late Animation<double> checkFadeAnimation;
  late Animation<Offset> checkSlideAnimation;

  late final AnimationController nextGroupAnimationController;
  late Animation<Offset> nextGroupSlideAnimation;

  late final AnimationController groupAni;
  late Animation<Offset> groupSlide;

  int activeIndex = 0;

  late SwipeController swipeController;

  @override
  void initState() {
    super.initState();
    swipeController = SwipeController(vsync: this);

    nextGroupAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    nextGroupSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 40),
          end: const Offset(0, 0.5),
        ).animate(
          CurvedAnimation(
            parent: nextGroupAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    groupAni = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    groupSlide = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.35),
    ).animate(CurvedAnimation(parent: groupAni, curve: Curves.easeInOut));

    crossAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    crossSizeAnimation = Tween<double>(begin: 0.1, end: 4).animate(
      CurvedAnimation(
        parent: crossAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    endFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    endFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: endFadeController, curve: Curves.easeInOut),
    );

    crossFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: crossAnimationController, curve: Curves.easeIn),
    );

    checkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    checkSizeAnimation = Tween<double>(begin: 0.1, end: 4).animate(
      CurvedAnimation(
        parent: checkAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    checkFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: checkAnimationController, curve: Curves.easeIn),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    crossSlideAnimation =
        Tween<Offset>(
          begin: Offset(width - 100, height * 0.3),
          end: Offset(width - 230, 70),
        ).animate(
          CurvedAnimation(
            parent: crossAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    checkSlideAnimation =
        Tween<Offset>(
          begin: Offset(0, height * 0.3),
          end: Offset(170, 70),
        ).animate(
          CurvedAnimation(
            parent: checkAnimationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  void animateSwipe(CardSwiperDirection direction) {
    if (direction == CardSwiperDirection.left) {
      crossAnimationController.forward();
    } else if (direction == CardSwiperDirection.right) {
      checkAnimationController.forward();
    }
  }

  // reset animations
  void resetAnimations() {
    crossAnimationController.reset();
    checkAnimationController.reset();
  }

  @override
  void dispose() {
    endFadeController.dispose();
    crossAnimationController.dispose();
    checkAnimationController.dispose();
    super.dispose();
  }

  double maxSwipeDistance = 400;
  bool animationTriggered = false;
  double computeNextCardProgress(double cardX, double triggerDistance) {
    final absX = cardX.abs();

    if (absX <= triggerDistance) return 0;

    return ((absX - triggerDistance) / triggerDistance).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MovableBackground(
        backgroundType: MovableBackgroundType.dark,
        child: BlocListener(
          bloc: homeCubit,
          listener: (context, state) {
            final cardX = homeCubit.xAxisCardValue;
            final progress = (cardX.abs() / 250).clamp(0.0, 1.0);
            if (cardX > 10) {
              checkAnimationController.value = progress;
              crossAnimationController.value = 0;
              // nextGroupAnimationController.value = progress;
            } else if (cardX < -10) {
              crossAnimationController.value = progress;
              checkAnimationController.value = 0;
              // nextGroupAnimationController.value = progress;
            } else {
              crossAnimationController.reset();
              checkAnimationController.reset();
            }
          },
          child: BlocBuilder(
            bloc: homeCubit,
            builder: (context, state) {
              return Column(
                children: [
                  const CustomSizedBox(height: 50),
                  HomeTopBar(
                    onSettingsPressed: () {
                      AutoRouter.of(context).push(const FilterRoute());
                    },
                    onBackPressed: () {
                      // Jump back to the first group and clear end state visuals
                      endFadeController.reset();
                      resetAnimations();
                      homeCubit.restartFromBeginning();
                    },
                  ),
                  const CustomSizedBox(height: 16),
                  Expanded(
                    child: Stack(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: homeCubit.isEnd ? 0.0 : 1.0,
                          child: AnimatedBuilder(
                            animation: crossAnimationController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: crossSlideAnimation.value,
                                child: Transform.scale(
                                  scale: crossSizeAnimation.value,
                                  child: Opacity(
                                    opacity: crossFadeAnimation.value,
                                    child: child,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorPalette.error.withValues(
                                      alpha: .1,
                                    ),
                                    blurRadius: 5,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                shape: BoxShape.circle,
                                color: ColorPalette.error.withValues(alpha: .1),
                              ),
                              child: SvgPicture.asset(
                                Assets.icons.error.path,
                                height: 30,
                                width: 30,
                                colorFilter: ColorFilter.mode(
                                  ColorPalette.error,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // CHECK ANIMATION
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: homeCubit.isEnd ? 0.0 : 1.0,
                          child: AnimatedBuilder(
                            animation: checkAnimationController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: checkSlideAnimation.value,
                                child: Transform.scale(
                                  scale: checkSizeAnimation.value,
                                  child: Opacity(
                                    opacity: checkFadeAnimation.value,
                                    child: child,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorPalette.green.withValues(
                                      alpha: .1,
                                    ),
                                    blurRadius: 5,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                shape: BoxShape.circle,
                                color: ColorPalette.green.withValues(alpha: .1),
                              ),
                              child: Image.asset(
                                Assets.icons.checkGreen.path,
                                height: 30,
                                width: 30,
                                color: ColorPalette.green,
                              ),
                            ),
                          ),
                        ),

                        if (homeCubit.isEnd)
                          Align(
                            alignment: Alignment.center,
                            child: FadeTransition(
                              opacity: endFadeAnimation,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: AllCaughtUpWidget(
                                  onAllow: () {
                                    resetAnimations();
                                  },
                                ),
                              ),
                            ),
                          ),
                        BlocBuilder(
                          bloc: homeCubit,
                          builder: (context, state) {
                            if (homeCubit.isEnd) {
                              return const Center(child: Text('No more cards'));
                            }

                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                // 🔹 NEXT CARD (under)
                                BlocBuilder(
                                  bloc: homeCubit,
                                  builder: (context, state) {
                                    final cardX = homeCubit.xAxisCardValue;
                                    final screenWidth = MediaQuery.of(
                                      context,
                                    ).size.width;
                                    final triggerDistance = screenWidth * 0.33;

                                    final progress = computeNextCardProgress(
                                      cardX,
                                      triggerDistance,
                                    );

                                    final slideY = lerpDouble(
                                      800,
                                      0,
                                      progress / 1.5,
                                    )!;
                                    final scale = lerpDouble(
                                      0.94,
                                      1.0,
                                      progress,
                                    )!;
                                    final opacity = lerpDouble(
                                      0.7,
                                      1.0,
                                      progress,
                                    )!;

                                    return Opacity(
                                      opacity: opacity,
                                      child: Transform.translate(
                                        offset: Offset(0, slideY),
                                        child: Transform.scale(
                                          scale: scale,
                                          child: SlideTransition(
                                            position: groupSlide,
                                            child: HomeCardDesign(
                                              group: homeCubit.nextGroup,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // 🔹 TOP CARD (draggable)
                                SwipeCard(
                                  controller: swipeController,
                                  onSwipe: (result) {
                                    if (result != SwipeResult.none) {
                                      // homeCubit.onSwipeCompleted(result);
                                      // homeCubit.updateCardPosition(0);
                                      // homeCubit.selectGroupIndex(
                                      //   homeCubit.currentIndex,
                                      // );
                                      groupAni.forward(from: 0);
                                      resetAnimations();
                                      if (homeCubit.isEndOfList) {
                                        // Fade in AllCaughtUp
                                        endFadeController.forward();
                                        // Instantly hide swipe icons
                                        crossAnimationController.reset();
                                        checkAnimationController.reset();
                                        homeCubit.markEndReached();
                                      }
                                    }
                                  },
                                  child: HomeCardDesign(
                                    group: homeCubit.currentGroup,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        // CARD SWIPER
                        // CardSwiper(
                        //   cardsCount: DummyConstants.groups.length,
                        //   numberOfCardsDisplayed: DummyConstants.groups.length,
                        //   isLoop: false,
                        //   controller: homeCubit.cardSwiperController,
                        //   backCardOffset: Offset(0, getHeight(context) * 0.5),
                        //   padding: const EdgeInsets.symmetric(horizontal: 0),
                        //   duration: const Duration(seconds: 1),
                        //   showBackCardOnUndo: true,
                        //   allowedSwipeDirection:
                        //       const AllowedSwipeDirection.symmetric(
                        //         horizontal: true,
                        //       ),
                        //   onEnd: () {
                        //     homeCubit.markEndReached();
                        //     // Fade in AllCaughtUp
                        //     endFadeController.forward();

                        //     // Instantly hide swipe icons
                        //     crossAnimationController.reset();
                        //     checkAnimationController.reset();
                        //   },
                        //   // Reset animation when swipe ends
                        //   onSwipe: (previousIndex, currentIndex, direction) {
                        //     log('Swiped to $currentIndex from $previousIndex');
                        //     homeCubit.selectGroupIndex(currentIndex);
                        //     return true;
                        //   },
                        //   cardBuilder: (context, index, percentX, percentY) {
                        //     homeCubit.updateCardPosition(percentX.toDouble());
                        //     return Stack(
                        //       children: [
                        //         ClipRRect(
                        //           borderRadius: BorderRadius.circular(24),
                        //           // child: MovableBackground(
                        //           //   backgroundType: MovableBackgroundType.dark,
                        //           //   child: SizedBox.expand(),
                        //           // ),
                        //         ),
                        //         HomeCardDesign(
                        //           group: DummyConstants.groups[index],
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: BlocBuilder(
        bloc: homeCubit,
        builder: (context, state) {
          if (homeCubit.selectedProfile != null && !homeCubit.isEnd) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => SendPokeBottomSheet(
                    pokeType: PokeType.floating,
                    image: homeCubit.selectedProfile?.images?.first,
                    promptTitle: homeCubit.selectedProfile?.promptTitle,
                    promptAnswer: homeCubit.selectedProfile?.promptAnswer,
                  ),
                );
              },
              child: Container(
                height: 56,
                width: 56,
                margin: const EdgeInsets.only(bottom: 80, right: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorPalette.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  AppEmojis.pointingRight,
                  style: AppTextStyles.h4(context),
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
