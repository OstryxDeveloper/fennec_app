import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;

  const RoundIconButton({
    super.key,
    required this.iconPath,
    this.onTap,
    this.size = 40,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            height: iconSize,
            width: iconSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
