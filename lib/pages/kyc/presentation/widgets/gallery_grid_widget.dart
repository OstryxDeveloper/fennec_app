import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/bloc/state/imagepicker_state.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/gallery_image_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GalleryGridWidget extends StatelessWidget {
  const GalleryGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = Di().sl<ImagePickerCubit>();

    return BlocBuilder<ImagePickerCubit, ImagePickerState>(
      bloc: cubit,
      builder: (context, state) {
        if (cubit.selectedImagePaths.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: 2 images
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      width: 124,
                      height: 124,
                      child: GalleryImageItemWidget(
                        imagePath: cubit.selectedImagePaths[0],
                        index: 0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (cubit.selectedImagePaths.length > 1)
                      SizedBox(
                        width: 124,
                        height: 124,
                        child: GalleryImageItemWidget(
                          imagePath: cubit.selectedImagePaths[1],
                          index: 1,
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
