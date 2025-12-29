import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomChips extends StatelessWidget {
  final String? emoji;
  final String? icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? height;
  final TextStyle? textStyle;
  final double? horizontalPadding;
  final double? verticalPadding;

  const CustomChips({
    super.key,
    this.emoji,
    this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.height,
    this.textStyle,
    this.horizontalPadding,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: height ?? 44,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 12,
          vertical: verticalPadding ?? 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? ColorPalette.primary : ColorPalette.secondary,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: ColorPalette.primary, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: AppTextStyles.chipLabel(context)),
              const SizedBox(width: 6),
            ],
            if (icon != null) ...[
              SvgPicture.asset(icon!, height: 16, width: 16),
              const SizedBox(width: 6),
            ],
            AppText(
              text: label,
              style:
                  textStyle ??
                  AppTextStyles.chipLabel(context).copyWith(
                    color: isSelected
                        ? Colors.white
                        : ColorPalette.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
