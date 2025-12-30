import 'package:flutter/material.dart';

class DualBorderRangeThumbShape extends RangeSliderThumbShape {
  final double radius;
  final double strokeWidth;
  final Color fillColor;
  final Color outerBorderColor;
  final Color innerBorderColor;

  const DualBorderRangeThumbShape({
    this.radius = 32,
    this.strokeWidth = 3,
    required this.fillColor,
    required this.outerBorderColor,
    required this.innerBorderColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    bool isPressed = false,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
  }) {
    final Canvas canvas = context.canvas;

    // Fill
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    // Outer border (black)
    final Paint outerBorderPaint = Paint()
      ..color = outerBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Inner border (primary)
    final Paint innerBorderPaint = Paint()
      ..color = innerBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw fill
    canvas.drawCircle(center, radius, fillPaint);

    // Outer border
    canvas.drawCircle(center, radius - strokeWidth / 2, outerBorderPaint);

    // Inner border
    canvas.drawCircle(center, radius - strokeWidth * 2, innerBorderPaint);
  }
}
