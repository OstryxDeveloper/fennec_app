import 'package:flutter/widgets.dart';

const double designWidth = 440;
const double designHeight = 956;
const double minHeight = 600;

double getHeight(BuildContext context) => MediaQuery.of(context).size.height;

double getWidth(BuildContext context) => MediaQuery.of(context).size.width;

double getProportionalHeight(BuildContext context, double inputHeight) {
  final screenHeight = getHeight(context);

  final scale = (screenHeight / designHeight).clamp(
    minHeight / designHeight,
    1.2,
  );

  return inputHeight * scale;
}

double getProportionalWidth(BuildContext context, double inputWidth) {
  final screenWidth = getWidth(context);
  return (inputWidth / designWidth) * screenWidth;
}
