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
      durationInMilliseconds: 600,
    ),
  ];

  @override
  RouteType get defaultRouteType => RouteType.custom(
    transitionsBuilder: TransitionsBuilders.slideBottom,
    duration: const Duration(milliseconds: 600),
  );
}
