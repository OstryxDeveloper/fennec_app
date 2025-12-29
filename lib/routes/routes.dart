part of 'routes_imports.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      page: SplashRoute.page,
      // initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: LandingRoute.page,
      barrierColor: Colors.transparent,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),

    CustomRoute(
      page: DashboardRoute.page,
      initial: true,

      barrierColor: Colors.transparent,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),

    CustomRoute(
      page: HomeRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    // Home Landing Screen
    CustomRoute(
      page: HomeLandingRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    // Create Group Screen
    CustomRoute(
      page: CreateGroupRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: LoginRoute.page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: ResetPasswordRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: OtpVerificationRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: SetNewPasswordRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: CreateAccountRoute.page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: OnBoardingRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 600),
    ),

    CustomRoute(
      page: VerifyPhoneNumberRoute.page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      barrierColor: Colors.transparent,
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: OnBoardingRoute1.page,
      barrierColor: Colors.transparent,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      duration: const Duration(milliseconds: 300),
    ),

    CustomRoute(
      page: KycRoute.page,
      barrierColor: Colors.transparent,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 400),
    ),

    CustomRoute(
      page: KycDetailsRoute.page,
      barrierColor: Colors.transparent,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: KycGalleryRoute.page,
      barrierColor: Colors.transparent,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: KycMatchRoute.page,
      barrierColor: Colors.transparent,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: KycPromptRoute.page,
      barrierColor: Colors.transparent,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: FilterRoute.page,
      barrierColor: Colors.transparent,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 500),
    ),

    CustomRoute(
      page: AddMemberRoute.page,
      barrierColor: Colors.transparent,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 500),
    ),
  ];
}
