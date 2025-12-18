import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TileWidget extends StatelessWidget {
  final String? title;
  final String? actionText;
  final VoidCallback? onTap;
  const TileWidget({this.title, this.actionText, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black26,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: title ?? 'Didn’t get the code?',
            style: AppTextStyles.bodyLarge(
              context,
            ).copyWith(color: Colors.white),
          ),
          InkWell(
            onTap: onTap ?? () {},
            child: AppText(
              text: actionText ?? 'Resend',
              style: AppTextStyles.bodyLarge(
                context,
              ).copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
