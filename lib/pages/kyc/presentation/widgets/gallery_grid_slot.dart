import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/gallery_image_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GalleryGridSlot extends StatelessWidget {
  final String? imagePath;
  final int index;
  final VoidCallback onTap;

  const GalleryGridSlot({
    super.key,
    required this.index,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 124,
        height: 124,
        decoration: BoxDecoration(
          color: ColorPalette.secondary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: imagePath != null
            ? GalleryImageItemWidget(imagePath: imagePath!, index: index)
            : Center(
                child: SvgPicture.asset(
                  Assets.icons.camera.path,
                  fit: BoxFit.scaleDown,
                ),
              ),
      ),
    );
  }
}
