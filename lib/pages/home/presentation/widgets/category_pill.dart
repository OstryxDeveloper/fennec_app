import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CategoryPill extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback? onTap;

  const CategoryPill({
    super.key,
    required this.iconPath,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: ColorPalette.secondary,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: ColorPalette.primary, width: 1),
        ),
        child: Text(
          label,
          style: AppTextStyles.chipLabel(
            context,
          ).copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
