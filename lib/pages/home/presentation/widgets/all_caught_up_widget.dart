import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../widgets/custom_elevated_button.dart';

class AllCaughtUpWidget extends StatelessWidget {
  final VoidCallback onAllow;
  const AllCaughtUpWidget({required this.onAllow, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: ColorPalette.black.withValues(alpha: 0.1),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(
                  Assets.animations.iconBg,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SvgPicture.asset(
                  Assets.icons.alertTriangle.path,
                  height: 48,
                  width: 45,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'You’re All Caught Up',
            textAlign: TextAlign.center,
            style: AppTextStyles.h2(
              context,
            ).copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          Text(
            'You’ve seen all the groups available in your area for now. New groups join regularly — check back soon.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge(context).copyWith(
              color: ColorPalette.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 48),
          CustomElevatedButton(text: 'Adjust Filters', onTap: onAllow),
        ],
      ),
    );
  }
}
