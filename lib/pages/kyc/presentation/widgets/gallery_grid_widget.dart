import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/gallery_grid_slot.dart';
import 'package:flutter/material.dart';

class GalleryGridWidget extends StatelessWidget {
  const GalleryGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = Di().sl<ImagePickerCubit>();

    return SizedBox(
      height: 260,
      child: Column(
        children: [
          GalleryGridSlot(
            index: 0,
            imagePath: cubit.selectedImagePaths.isNotEmpty
                ? cubit.selectedImagePaths[0]
                : null,
            onTap: cubit.pickMultipleImagesFromGallery,
          ),
          const SizedBox(height: 10),
          GalleryGridSlot(
            index: 1,
            imagePath: cubit.selectedImagePaths.length > 1
                ? cubit.selectedImagePaths[1]
                : null,
            onTap: cubit.pickMultipleImagesFromGallery,
          ),
        ],
      ),
    );
  }
}
