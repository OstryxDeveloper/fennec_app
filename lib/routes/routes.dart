part of 'routes_imports.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),

    AutoRoute(page: DashboardRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: ResetPasswordRoute.page),
    AutoRoute(page: OtpVerificationRoute.page),
    AutoRoute(page: CreateAccountRoute.page),
    CustomRoute(
      page: OnBoardingRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      duration: const Duration(milliseconds: 600),
    ),
    AutoRoute(page: VerifyPhoneNumberRoute.page),
    AutoRoute(page: OnBoardingRoute1.page),
  ];

  @override
  RouteType get defaultRouteType => RouteType.custom(
    transitionsBuilder: TransitionsBuilders.slideBottom,
    duration: const Duration(milliseconds: 600),
  );
}
