import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/helpers/gradient_toast.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class DeclineWidget extends StatelessWidget {
  const DeclineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Center(child: Assets.icons.error.svg(width: 72, height: 72)),

          const CustomSizedBox(height: 24),
          AppText(
            text: 'Invitation Declined',
            style: AppTextStyles.h2(context),
            textAlign: TextAlign.center,
          ),
          const CustomSizedBox(height: 24),
          AppText(
            text:
                'You can create your own group or join another one using a link, or QR code.',
            style: AppTextStyles.subHeading(
              context,
            ).copyWith(color: ColorPalette.textSecondary),
            textAlign: TextAlign.center,
          ),
          const CustomSizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: 'Create a Group',
                  onTap: () {
                    context.router.push(const CreateGroupRoute());
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomOutlinedButton(
                  text: 'Find a Group',
                  onPressed: () {
                    VxToast.show(message: 'Coming Soon!');
                  },
                  borderColor: Colors.white70,
                  textColor: Colors.white,
                  height: 52,
                ),
              ),
            ],
          ),
          const CustomSizedBox(height: 20),
        ],
      ),
    );
  }
}
