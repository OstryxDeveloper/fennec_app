import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/dashboard/presentation/bloc/cubit/dashboard_cubit.dart';
import 'package:fennac_app/pages/home/presentation/screen/home_screen.dart';
import 'package:fennac_app/pages/homelanding/presentation/bloc/cubit/home_landing_cubit.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class JoinWidget extends StatelessWidget {
  const JoinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Center(child: Assets.icons.checkGreen.image(width: 72, height: 72)),
          const CustomSizedBox(height: 24),

          AppText(
            text: "Welcome to the group!",
            style: AppTextStyles.h2(context),
            textAlign: TextAlign.center,
          ),
          const CustomSizedBox(height: 24),
          // Invitation Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AppText(
              text:
                  'Your group profile is ready. Chat, share, and match with other groups nearby!',
              style: AppTextStyles.subHeading(
                context,
              ).copyWith(color: ColorPalette.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const CustomSizedBox(height: 40),
          CustomElevatedButton(
            text: 'Start Exploring',
            onTap: () {
              Di().sl<DashboardCubit>().changePage(0, HomeScreen());
              // _homeLandingCubit.selectDeclined(InvitationStatus.declined);
            },
          ),
        ],
      ),
    );
  }
}

final HomeLandingCubit _homeLandingCubit = Di().sl<HomeLandingCubit>();
