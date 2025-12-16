import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData? icon;
  final double? size;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.icon,
    this.size,
    this.alignment,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.black26,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onPressed ?? () => Navigator.pop(context),
          icon: Icon(
            icon ?? Icons.arrow_back,
            color: iconColor ?? Colors.white,
            size: size,
          ),
          padding: padding ?? EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }
}
