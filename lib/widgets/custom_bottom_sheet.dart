import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/text_styles.dart';
import 'custom_elevated_button.dart';
import 'custom_sized_box.dart';
import 'custom_text.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Widget? icon;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
    this.icon,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onButtonPressed,
    Widget? icon,
    Color? barrierColor,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      isScrollControlled: true,
      builder: (context) => CustomBottomSheet(
        title: title,
        description: description,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorPalette.secondry, ColorPalette.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const CustomSizedBox(height: 24)],
          AppText(
            text: title,
            style: AppTextStyles.h1(
              context,
            ).copyWith(color: ColorPalette.white, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const CustomSizedBox(height: 16),
          AppText(
            text: description,
            style: AppTextStyles.bodyLarge(
              context,
            ).copyWith(color: ColorPalette.white.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
          const CustomSizedBox(height: 32),
          CustomElevatedButton(text: buttonText, onTap: onButtonPressed),
          const CustomSizedBox(height: 16),
        ],
      ),
    );
  }
}
