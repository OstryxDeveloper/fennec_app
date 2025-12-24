import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'round_icon_button.dart';

class HomeTopBar extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onSettingsPressed;

  const HomeTopBar({super.key, this.onBackPressed, this.onSettingsPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RoundIconButton(
          iconPath: Assets.icons.rotateCcw.path,
          onTap: onBackPressed,
        ),
        Text(
          'Fennec',
          style: AppTextStyles.h1Large(context).copyWith(color: Colors.white),
        ),
        RoundIconButton(
          iconPath: Assets.icons.sliders.path,
          onTap: onSettingsPressed,
        ),
      ],
    );
  }
}
