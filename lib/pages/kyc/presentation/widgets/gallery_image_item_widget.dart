import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GalleryImageItemWidget extends StatelessWidget {
  final String imagePath;
  final int index;

  const GalleryImageItemWidget({
    super.key,
    required this.imagePath,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = Di().sl<ImagePickerCubit>();

    return LongPressDraggable<int>(
      data: index,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 80,
          height: 90,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: ColorPalette.secondry.withOpacity(0.5),
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.white54,
                    size: 30,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          color: Colors.black.withOpacity(0.3),
        ),
      ),
      child: DragTarget<int>(
        onAccept: (draggedIndex) {
          cubit.reorderImages(draggedIndex, index);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            key: ValueKey('image_$index'),
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: ColorPalette.secondry.withOpacity(0.5),
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                          size: 40,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => cubit.removeImage(index),
                      child: Container(
                        alignment: Alignment.center,
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorPalette.error,
                        ),
                        child: SvgPicture.asset(
                          Assets.icons.trash.path,
                          color: Colors.white,
                          width: 10,
                          height: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
