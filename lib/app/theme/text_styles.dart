import 'package:flutter/material.dart';

import '../constants/media_query_constants.dart';

class AppTextStyles {
  AppTextStyles._();

  // Base text style with SF Pro font
  static TextStyle _sfProTextStyle() => const TextStyle(fontFamily: 'SFPro');

  static TextStyle h1Large(BuildContext context) => _sfProTextStyle().copyWith(
    fontSize: getWidth(context) > 1000 ? 40 : 28,
    fontWeight: FontWeight.w500,
    height: getWidth(context) > 1000 ? 40 / 28 : null,
  );

  static TextStyle h1(BuildContext context) => _sfProTextStyle().copyWith(
    fontSize: getWidth(context) > 1000 ? 32 : 18,
    fontWeight: FontWeight.w500,
    height: getWidth(context) > 1000 ? 24 / 28 : null,
  );

  static TextStyle h2(BuildContext context) => _sfProTextStyle().copyWith(
    fontSize: getWidth(context) > 1050 ? 24 : 18,
    fontWeight: FontWeight.w500,
    height: getWidth(context) > 1050 ? 24 / 24 : null,
  );

  static TextStyle bodyLarge(BuildContext context) =>
      _sfProTextStyle().copyWith(
        fontSize: getWidth(context) > 600 ? 16 : 12,
        height: getWidth(context) > 600 ? 17 / 16 : null,
        fontWeight: FontWeight.w400,
      );

  static TextStyle bodyRegular(BuildContext context) =>
      _sfProTextStyle().copyWith(
        fontSize: getWidth(context) > 1050 ? 14 : 12,
        height: getWidth(context) > 1050 ? 17 / 14 : null,
        fontWeight: FontWeight.w400,
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
        fontSize: getWidth(context) > 1000 ? 12 : 12,
        height: getWidth(context) > 1000 ? 17 / 12 : null,
        fontWeight: FontWeight.w400,
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
        color: Colors.grey.withOpacity(0.1),
        blurRadius: 3,
        spreadRadius: 3,
        offset: const Offset(0, 3),
      ),
    ],
  );
}
