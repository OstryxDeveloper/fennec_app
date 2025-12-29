import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class GroupMemberAvatar extends StatelessWidget {
  final String? imagePath;
  final bool isAddButton;
  final bool isAdmin;
  final VoidCallback? onTap;
  final String label;

  const GroupMemberAvatar({
    super.key,
    this.imagePath,
    this.isAddButton = false,
    this.isAdmin = false,
    this.onTap,
    this.label = 'Add Member',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            AutoRouter.of(context).push(AddMemberRoute());
          },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAddButton
                      ? ColorPalette.secondary
                      : ColorPalette.primary,
                ),
                child: isAddButton
                    ? Assets.icons.userPlus.svg(width: 32, height: 32)
                    : imagePath != null
                    ? ClipOval(
                        child: Image.asset(imagePath!, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.person, color: Colors.white, size: 32),
              ),
              if (isAdmin)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 24,
                      width: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorPalette.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppText(
                        text: 'Admin',
                        style: AppTextStyles.inputLabel(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          AppText(
            text: label,
            style: AppTextStyles.description(
              context,
            ).copyWith(color: ColorPalette.textSecondary),
          ),
        ],
      ),
    );
  }
}
