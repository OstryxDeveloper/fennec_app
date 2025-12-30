import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/app/app.dart';

class VxToast {
  static void show({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    CustomSnackbar.show(
      child: GradientToast(
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }
}

class CustomSnackbar {
  static void show({required Widget child}) {
    final messenger = snackbarKey.currentState;
    messenger?.removeCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.horizontal,
        elevation: 0,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        // Figma: left/right 24, floating near bottom
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: child,
      ),
    );
  }
}

class GradientToast extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const GradientToast({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF16003F), Color(0xFF111111)],
          ),
        ),
        child: Row(
          children: [
            Assets.icons.info.svg(width: 24, height: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(context),
              ),
            ),
            if (actionLabel != null)
              _ActionButton(label: actionLabel!, onTap: onAction),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _ActionButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.6),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: ColorPalette.primary,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(
              label,
              style: AppTextStyles.h4(
                context,
              ).copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
