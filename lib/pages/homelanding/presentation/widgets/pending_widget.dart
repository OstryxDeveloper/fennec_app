import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/homelanding/presentation/bloc/cubit/home_landing_cubit.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class PendingWidget extends StatelessWidget {
  const PendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Invitation Title
        AppText(
          text: "You've Been Invited!",
          style: AppTextStyles.h2(context),
          textAlign: TextAlign.center,
        ),
        const CustomSizedBox(height: 16),
        // Invitation Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AppText(
            text:
                'Your friends want you to be part of their circle. Join and start exploring together.',
            style: AppTextStyles.subHeading(
              context,
            ).copyWith(color: ColorPalette.textSecondary),
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
                  _homeLandingCubit.selectDeclined(InvitationStatus.accepted);
                },
              ),
              const CustomSizedBox(height: 16),
              CustomOutlinedButton(
                text: 'Decline',
                onPressed: () {
                  _homeLandingCubit.selectDeclined(InvitationStatus.declined);
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
    );
  }
}

final HomeLandingCubit _homeLandingCubit = Di().sl<HomeLandingCubit>();
