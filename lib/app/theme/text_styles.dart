import 'package:flutter/material.dart';

import '../constants/media_query_constants.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _sfProTextStyle() =>
      const TextStyle(fontFamily: 'SFPro', color: Colors.white);

  static TextStyle h1(BuildContext context) => _sfProTextStyle().copyWith(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -0.02 * 40,
  );

  static TextStyle h2(BuildContext context) => _sfProTextStyle().copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: -0.02 * 32,
  );

  static TextStyle h3(BuildContext context) => _sfProTextStyle().copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    height: 1.0,
    letterSpacing: -0.02 * 24,
  );

  static TextStyle h4(BuildContext context) => _sfProTextStyle().copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: -0.02 * 20,
  );

  static TextStyle description(BuildContext context) =>
      _sfProTextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.0,
        letterSpacing: 0,
      );

  static TextStyle chipLabel(BuildContext context) =>
      _sfProTextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.25,
        letterSpacing: 0,
      );

  static TextStyle body(BuildContext context) => _sfProTextStyle().copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  static TextStyle h1Large(BuildContext context) => _sfProTextStyle().copyWith(
    fontSize: getWidth(context) > 1000 ? 40 : 28,
    fontWeight: FontWeight.w500,
    height: getWidth(context) > 1000 ? 40 / 28 : null,
  );

  static TextStyle bodyLarge(BuildContext context) =>
      _sfProTextStyle().copyWith(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      );

  static TextStyle bodyRegular(BuildContext context) =>
      _sfProTextStyle().copyWith(
        fontSize: getWidth(context) > 1050 ? 14 : 12,
        height: getWidth(context) > 1050 ? 17 / 14 : null,
        fontWeight: FontWeight.w400,
      );
  static TextStyle subHeading(BuildContext context) =>
      _sfProTextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        height: 24 / 16,
        letterSpacing: -0.02 * 16,
      );
  static TextStyle h5(BuildContext context) => _sfProTextStyle().copyWith(
    fontSize: getWidth(context) > 1000 ? 20 : 12,
    height: getWidth(context) > 1000 ? 17 / 20 : null,
    fontWeight: FontWeight.w500,
  );

  static TextStyle h6(BuildContext context) => _sfProTextStyle().copyWith(
    fontSize: getWidth(context) > 1000 ? 18 : 12,
    height: getWidth(context) > 1000 ? 17 / 18 : null,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodySmall(BuildContext context) =>
      _sfProTextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 1.0,
        letterSpacing: 0,
      );
  static TextStyle inputLabel(BuildContext context) =>
      _sfProTextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        height: 16 / 12,
        letterSpacing: 0,
      );
  static Widget checkDirection(BuildContext context, List<Widget> data) =>
      getWidth(context) > 1000
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: data,
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: data,
        );

  static Widget checkDirectionSpaceAround(
    BuildContext context,
    List<Widget> data,
  ) => getWidth(context) > 1000
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: data,
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: data,
        );

  static Widget checkDirection1(BuildContext context, List<Widget> data) =>
      getWidth(context) > 1000
      ? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: data,
          ),
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: data,
        );

  static Widget checkDirection2(BuildContext context, List<Widget> data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1000) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: data,
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: data,
          );
        }
      },
    );
  }

  static BoxDecoration customBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withValues(alpha: 0.1),
        blurRadius: 3,
        spreadRadius: 3,
        offset: const Offset(0, 3),
      ),
    ],
  );
}
