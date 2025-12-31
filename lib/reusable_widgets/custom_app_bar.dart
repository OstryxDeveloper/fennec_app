import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  const CustomAppBar({super.key, this.title});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          const CustomBackButton(),
          const Spacer(),
          AppText(
            text: title ?? 'Find a Group',
            style: AppTextStyles.h4(context),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
