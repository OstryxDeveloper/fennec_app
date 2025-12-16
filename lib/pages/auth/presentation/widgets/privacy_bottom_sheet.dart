import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class PrivacyBottomSheet extends StatelessWidget {
  const PrivacyBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PrivacyBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorPalette.secondry, ColorPalette.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Privacy Policy',
                  style: AppTextStyles.h1(context).copyWith(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText(
                    context,
                    'Your privacy matters to us. This Privacy Policy explains what data we collect, how we use it, and how we protect your information.',
                  ),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '1. Information We Collect'),
                  CustomSizedBox(height: 12),
                  _buildText(context, 'We collect:'),
                  CustomSizedBox(height: 8),
                  _buildBulletPoint(
                    context,
                    'Account Information: Name, email, phone number, and date of birth.',
                  ),
                  _buildBulletPoint(
                    context,
                    'Profile Data: Photos, answers to personality questions, and group associations.',
                  ),
                  _buildBulletPoint(
                    context,
                    'Usage Data: Interactions, chats, preferences, and app activity.',
                  ),
                  _buildBulletPoint(
                    context,
                    'Device Data: IP address, device type, and basic diagnostics.',
                  ),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '2. How We Use Your Information'),
                  CustomSizedBox(height: 12),
                  _buildText(context, 'We use your data to:'),
                  CustomSizedBox(height: 8),
                  _buildBulletPoint(context, 'Create and manage your account'),
                  _buildBulletPoint(
                    context,
                    'Match you with compatible groups',
                  ),
                  _buildBulletPoint(
                    context,
                    'Enable communication and in-app messaging',
                  ),
                  _buildBulletPoint(
                    context,
                    'Improve Fennec\'s functionality and user experience',
                  ),
                  _buildBulletPoint(context, 'Prevent fraud and ensure safety'),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '3. Sharing Your Information'),
                  CustomSizedBox(height: 12),
                  _buildText(context, 'We never sell your personal data.'),
                  CustomSizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text) {
    return AppText(
      text: text,
      style: AppTextStyles.bodyLarge(context).copyWith(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildText(BuildContext context, String text) {
    return AppText(
      text: text,
      style: AppTextStyles.bodyLarge(
        context,
      ).copyWith(color: Colors.white70, fontSize: 14, height: 1.5),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 4, color: Colors.white70),
          ),
          const SizedBox(width: 12),
          Expanded(child: _buildText(context, text)),
        ],
      ),
    );
  }
}
