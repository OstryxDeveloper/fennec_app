import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;

  const ContinueButton({super.key, this.onTap, this.text = 'Continue'});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(52),
        boxShadow: [
          // Outer glow - softest
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          // Middle glow
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          // Inner glow - closest to button
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(52),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorPalette.primary,
                  ColorPalette.primary.withValues(alpha: 0.95),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(52),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Center(
              child: AppText(
                text: text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'SFPro',
                  shadows: [
                    Shadow(
                      color: Colors.white.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                    Shadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
