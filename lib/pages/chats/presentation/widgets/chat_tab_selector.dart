import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ChatTabSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const ChatTabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ColorPalette.cardBlack,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(0),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedIndex == 0
                      ? ColorPalette.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                alignment: Alignment.center,
                child: AppText(
                  text: 'Chats',
                  style: AppTextStyles.subHeading(
                    context,
                  ).copyWith(color: ColorPalette.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(1),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedIndex == 1
                      ? ColorPalette.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                alignment: Alignment.center,
                child: AppText(
                  text: 'Calls',
                  style: AppTextStyles.subHeading(
                    context,
                  ).copyWith(color: ColorPalette.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
