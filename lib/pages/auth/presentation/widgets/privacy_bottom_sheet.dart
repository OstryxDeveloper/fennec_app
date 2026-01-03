import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PrivacyBottomSheet extends StatelessWidget {
  final ValueNotifier<bool>? blurNotifier;

  const PrivacyBottomSheet({super.key, this.blurNotifier});

  static void show(BuildContext context, {ValueNotifier<bool>? blurNotifier}) {
    blurNotifier?.value = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PrivacyBottomSheet(blurNotifier: blurNotifier),
    ).then((_) {
      blurNotifier?.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorPalette.secondary,
            ColorPalette.black.withValues(alpha: 0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
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
                  icon: SvgPicture.asset(
                    Assets.icons.cancel.path,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),

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
                  CustomSizedBox(height: 12),
                  _buildText(context, 'We may share limited information with:'),
                  CustomSizedBox(height: 8),
                  _buildBulletPoint(
                    context,
                    'Verified partners (for payments or analytics)',
                  ),
                  _buildBulletPoint(
                    context,
                    'Law enforcement (if required by law)',
                  ),
                  _buildBulletPoint(
                    context,
                    'Other users, only as part of normal app functionality (e.g., your name, profile photo, and interests)',
                  ),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '4. Data Retention'),
                  CustomSizedBox(height: 12),
                  _buildText(
                    context,
                    'We keep your information for as long as necessary to provide our services. You can request deletion of your account at any time from within the app.',
                  ),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '5. Security'),
                  CustomSizedBox(height: 12),
                  _buildBulletPoint(
                    context,
                    'We use encryption, secure servers, and access controls to protect your data.',
                  ),
                  _buildBulletPoint(
                    context,
                    'However, no digital system is 100% secure — use caution when sharing information online.',
                  ),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '6. Your Rights'),
                  CustomSizedBox(height: 12),
                  _buildText(context, 'You can:'),
                  CustomSizedBox(height: 8),
                  _buildBulletPoint(
                    context,
                    'Access or edit your personal data',
                  ),
                  _buildBulletPoint(
                    context,
                    'Request deletion of your account',
                  ),
                  _buildBulletPoint(
                    context,
                    'Manage visibility of your profile and group membership',
                  ),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '7. Cookies & Analytics'),
                  CustomSizedBox(height: 12),
                  _buildText(
                    context,
                    'We use cookies and analytics tools to understand how users engage with Fennec and to improve app performance.',
                  ),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '8. Changes to This Policy'),
                  CustomSizedBox(height: 12),
                  _buildText(
                    context,
                    'We may update this policy periodically. The latest version will always be available within the app.',
                  ),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '9. Contact Us'),
                  CustomSizedBox(height: 12),
                  _buildText(
                    context,
                    'For privacy-related questions: privacy@fennec.app',
                  ),
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
      style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildText(BuildContext context, String text) {
    return AppText(text: text, style: AppTextStyles.body(context));
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
