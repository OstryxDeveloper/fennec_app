import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/text_styles.dart';
import 'custom_elevated_button.dart';
import 'custom_outlined_button.dart';
import 'custom_sized_box.dart';
import 'custom_text.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final Widget? icon;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryButtonPressed;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    this.onButtonPressed,
    this.icon,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String description,
    required String buttonText,
    VoidCallback? onButtonPressed,
    Widget? icon,
    Color? barrierColor,
    String? secondaryButtonText,
    VoidCallback? onSecondaryButtonPressed,
    ValueNotifier<bool>? blurNotifier,
  }) async {
    blurNotifier?.value = true;
    try {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: barrierColor,
        isScrollControlled: true,
        builder: (context) => CustomBottomSheet(
          title: title,
          description: description,
          buttonText: buttonText,
          onButtonPressed: () {
            if (onButtonPressed != null) {
              onButtonPressed();
            }
            Navigator.of(context).maybePop();
          },
          icon: icon,
          secondaryButtonText: secondaryButtonText,
          onSecondaryButtonPressed: onSecondaryButtonPressed,
        ),
      );
    } finally {
      blurNotifier?.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorPalette.secondary, ColorPalette.black],
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
            style: AppTextStyles.h2(
              context,
            ).copyWith(color: ColorPalette.white, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const CustomSizedBox(height: 16),
          AppText(
            text: description,
            style: AppTextStyles.subHeading(
              context,
            ).copyWith(color: ColorPalette.white.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
          const CustomSizedBox(height: 32),
          CustomElevatedButton(text: buttonText, onTap: onButtonPressed),
          if (secondaryButtonText != null &&
              onSecondaryButtonPressed != null) ...[
            const CustomSizedBox(height: 32),
            CustomOutlinedButton(
              text: secondaryButtonText!,
              onPressed: onSecondaryButtonPressed!,
              width: double.infinity,
            ),
            const CustomSizedBox(height: 40),
          ],
          const CustomSizedBox(height: 16),
        ],
      ),
    );
  }
}
