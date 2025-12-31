import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class InterestChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const InterestChip({
    super.key,
    required this.emoji,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? ColorPalette.primary : ColorPalette.secondary,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: ColorPalette.primary, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: AppTextStyles.chipLabel(context)),
            const SizedBox(width: 6),
            AppText(
              text: label,
              style: AppTextStyles.chipLabel(context).copyWith(
                color: isSelected ? Colors.white : ColorPalette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
