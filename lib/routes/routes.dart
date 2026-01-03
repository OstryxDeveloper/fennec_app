part of 'routes_imports.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      page: SplashRoute.page,
      initial: true,
      transitionsBuilder: AppTransitions.fade,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: LandingRoute.page,
      barrierColor: Colors.transparent,
      transitionsBuilder: AppTransitions.noTransition,
    ),

    CustomRoute(
      page: DashboardRoute.page,
      // initial: true,
      barrierColor: Colors.transparent,
      transitionsBuilder: AppTransitions.noTransition,
    ),

    CustomRoute(
      page: HomeRoute.page,
      transitionsBuilder: AppTransitions.fade,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: HomeLandingRoute.page,
      transitionsBuilder: AppTransitions.fade,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: ChatLandingRoute.page,
      transitionsBuilder: AppTransitions.fade,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: CreateGroupRoute.page,
      transitionsBuilder: AppTransitions.fade,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: LoginRoute.page,
      transitionsBuilder: AppTransitions.slideUp,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: ResetPasswordRoute.page,
      transitionsBuilder: AppTransitions.fade,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: OtpVerificationRoute.page,
      transitionsBuilder: AppTransitions.fade,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: SetNewPasswordRoute.page,
      transitionsBuilder: AppTransitions.fade,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: CreateAccountRoute.page,
      transitionsBuilder: AppTransitions.slideUp,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: OnBoardingRoute.page,
      transitionsBuilder: AppTransitions.fade,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 600),
    ),

    CustomRoute(
      page: VerifyPhoneNumberRoute.page,
      transitionsBuilder: AppTransitions.slideUp,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: OnBoardingRoute1.page,
      transitionsBuilder: AppTransitions.fade,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: KycRoute.page,
      transitionsBuilder: AppTransitions.slideRight,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 400),
    ),

    CustomRoute(
      page: KycDetailsRoute.page,
      transitionsBuilder: AppTransitions.slideRight,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: KycGalleryRoute.page,
      transitionsBuilder: AppTransitions.slideRight,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: KycMatchRoute.page,
      transitionsBuilder: AppTransitions.slideRight,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: KycPromptRoute.page,
      transitionsBuilder: AppTransitions.slideRight,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: FilterRoute.page,
      transitionsBuilder: AppTransitions.slideUp,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: AddMemberRoute.page,
      transitionsBuilder: AppTransitions.slideUp,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),
    CustomRoute(
      page: CreateGroupGalleryRoute.page,
      transitionsBuilder: AppTransitions.slideRight,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),
  ];
}
