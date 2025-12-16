import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TermsBottomSheet extends StatelessWidget {
  const TermsBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TermsBottomSheet(),
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
                  text: 'Terms of Service',
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
                    'Welcome to Fennec, a group-based social and dating platform that helps people connect and interact in a fun, safe, and authentic way. By using our app, you agree to these Terms of Service ("Terms"). Please read them carefully.',
                  ),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '1. Acceptance of Terms'),
                  CustomSizedBox(height: 12),
                  _buildText(
                    context,
                    'By accessing or using Fennec, you confirm that you are at least 18 years old and agree to be bound by these Terms and our Privacy Policy. If you do not agree, please do not use the app.',
                  ),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '2. Account Registration'),
                  CustomSizedBox(height: 12),
                  _buildBulletPoint(
                    context,
                    'You must provide accurate and up-to-date information when creating your account.',
                  ),
                  _buildBulletPoint(
                    context,
                    'You are responsible for maintaining the confidentiality of your login details.',
                  ),
                  _buildBulletPoint(
                    context,
                    'Fennec reserves the right to suspend or terminate any account that violates these Terms.',
                  ),
                  CustomSizedBox(height: 24),
                  _buildSectionTitle(context, '3. Group Use & Conduct'),
                  CustomSizedBox(height: 12),
                  _buildBulletPoint(
                    context,
                    'Users may create or join groups to connect with others.',
                  ),
                  _buildBulletPoint(
                    context,
                    'Group Heads can manage members, approve or remove participants, and report misconduct.',
                  ),
                  _buildBulletPoint(
                    context,
                    'You agree to communicate respectfully and refrain from harassment, hate speech, or inappropriate content.',
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
