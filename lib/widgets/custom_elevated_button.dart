import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/text_styles.dart';

class CustomElevatedButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Widget? icon;
  final double? width;
  const CustomElevatedButton({
    super.key,
    this.onTap,
    required this.text,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primary,
          foregroundColor: ColorPalette.primary,
          shadowColor: ColorPalette.primary,
          textStyle: AppTextStyles.bodyLarge(
            context,
          ).copyWith(color: ColorPalette.white, fontWeight: FontWeight.w600),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(52),
          ),
          minimumSize: const Size.fromHeight(52),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              text: text,
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: ColorPalette.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            CustomSizedBox(width: 10),
            icon ?? SizedBox(),
          ],
        ),
      ),
    );
  }
}
