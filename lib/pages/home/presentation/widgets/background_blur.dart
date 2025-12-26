import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredBackground extends StatelessWidget {
  final bool isSelected;
  final Widget child;

  const BlurredBackground({
    super.key,
    required this.isSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          opacity: isSelected ? 1.0 : 0.0,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withValues(alpha: 0)),
          ),
        ),
      ],
    );
  }
}
