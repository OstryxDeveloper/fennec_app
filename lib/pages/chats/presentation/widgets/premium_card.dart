import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:flutter/material.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 530,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorPalette.black.withValues(alpha: 0.4),
        border: Border.all(color: ColorPalette.primary, width: 1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            'Unlock the Full Fennec\nExperience',
            textAlign: TextAlign.center,
            style: AppTextStyles.h3(context),
          ),
          const CustomSizedBox(height: 16),
          Text(
            'Fennec Premium lets you join multiple groups, start one-on-one chats, enjoy longer calls, and reach more amazing groups around you.',
            textAlign: TextAlign.center,
            style: AppTextStyles.description(context),
          ),
          const CustomSizedBox(height: 24),
          Container(
            height: 224,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorPalette.primary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureItem('✅', 'Join multiple groups', context),
                const CustomSizedBox(height: 12),
                _buildFeatureItem('💬', 'Start individual chats', context),
                const CustomSizedBox(height: 12),
                _buildFeatureItem(
                  '📞',
                  'Unlimited voice & video calls',
                  context,
                ),
                const CustomSizedBox(height: 12),
                _buildFeatureItem('💖', 'See who liked your group', context),
                const CustomSizedBox(height: 12),
                _buildFeatureItem('⚡', 'Unlimited daily swipes', context),
                const CustomSizedBox(height: 12),
                _buildFeatureItem('🎁', 'Access premium prompts', context),
              ],
            ),
          ),
          const CustomSizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$9.99',
                style: AppTextStyles.h2(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '/month',
                style: AppTextStyles.subHeading(
                  context,
                ).copyWith(color: ColorPalette.textPrimary),
              ),
            ],
          ),
          const CustomSizedBox(height: 20),
          CustomElevatedButton(text: 'Upgrade to Premium', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String text, BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: AppTextStyles.chipLabel(context)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.chipLabel(
              context,
            ).copyWith(color: ColorPalette.white),
          ),
        ),
      ],
    );
  }
}
