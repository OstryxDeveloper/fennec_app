import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeLandingScreen extends StatelessWidget {
  const HomeLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.secondry,
      body: MovableBackground(
        child: Column(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomSizedBox(height: 80),
                  Container(
                    height: 370,
                    decoration: BoxDecoration(
                      color: ColorPalette.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildGroupImageWithAvatars(),
                        const CustomSizedBox(height: 30),
                        AppText(
                          text: 'Brenda,\t Nancy,\t Jeff,\t Anna',
                          style: AppTextStyles.h1(context).copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const CustomSizedBox(height: 12),
                        // Group Creation Info
                        AppText(
                          text: 'Group created by Anna Taylor 2 hours ago',
                          style: AppTextStyles.bodyRegular(
                            context,
                          ).copyWith(fontSize: 14, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const CustomSizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const CustomSizedBox(height: 20),
            // Invitation Title
            AppText(
              text: "You've Been Invited!",
              style: AppTextStyles.h1(context).copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const CustomSizedBox(height: 16),
            // Invitation Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AppText(
                text:
                    'Your friends want you to be part of their circle. Join and start exploring together.',
                style: AppTextStyles.body(
                  context,
                ).copyWith(fontSize: 16, color: Colors.white70, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const CustomSizedBox(height: 40),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  CustomElevatedButton(
                    text: 'Join Group',
                    onTap: () {
                      // Handle join group action
                    },
                  ),
                  const CustomSizedBox(height: 16),
                  CustomOutlinedButton(
                    text: 'Decline',
                    onPressed: () {
                      // Handle decline action
                    },
                    borderColor: Colors.white70,
                    textColor: Colors.white,
                    height: 52,
                  ),
                  const CustomSizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupImageWithAvatars() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Main Group Image
        Container(
          width: 392,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              Assets.dummy.groupSelfie.path,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Member Avatars Row at Bottom
        Positioned(
          bottom: -20,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMemberAvatar(Assets.dummy.portrait1.path),
              _buildMemberAvatar(Assets.dummy.portrait2.path),
              _buildMemberAvatar(Assets.dummy.portrait3.path),
              _buildMemberAvatar(Assets.dummy.portrait4.path),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberAvatar(String imagePath) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.cover)),
    );
  }
}
