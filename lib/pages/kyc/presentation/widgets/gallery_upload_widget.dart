import 'dart:io';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/bloc/state/imagepicker_state.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GalleryUploadWidget extends StatelessWidget {
  const GalleryUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = Di().sl<ImagePickerCubit>();

    return BlocBuilder<ImagePickerCubit, ImagePickerState>(
      bloc: cubit,
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _showImageSourceDialog(context, cubit),
          child: Container(
            width: 258,
            height: 260,
            decoration: BoxDecoration(
              color: ColorPalette.secondry.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:
                  (cubit.mediaList.isNotEmpty &&
                      cubit.mediaList[0].path.isNotEmpty)
                  ? Stack(
                      children: [
                        Image.file(
                          File(cubit.mediaList[0].path),
                          width: double.infinity,
                          height: 260,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: SvgPicture.asset(
                                Assets.icons.camera.path,
                                fit: BoxFit.scaleDown,
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () =>
                                cubit.removeMedia(cubit.mediaList[0].id),
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
                    )
                  : Center(
                      child: SvgPicture.asset(
                        Assets.icons.camera.path,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _showImageSourceDialog(BuildContext context, ImagePickerCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorPalette.secondry, ColorPalette.black],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickMultipleImagesFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickImageFromCamera();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
