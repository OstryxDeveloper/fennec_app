import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? textColor;
  final double? borderWidth;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final ButtonStyle? style;

  const CustomOutlinedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.icon,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.borderWidth,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.textStyle,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style:
            style ??
            OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 30),
              ),
              side: BorderSide(
                color: borderColor ?? Colors.white70,
                width: borderWidth ?? 1,
              ),
              minimumSize: Size.fromHeight(height ?? 50),
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 10)],
            Text(
              text,
              style:
                  textStyle ??
                  TextStyle(
                    fontSize: fontSize ?? 16,
                    color: textColor ?? Colors.white,
                    fontWeight: fontWeight,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
