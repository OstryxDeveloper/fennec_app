import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MediaPickerOptions extends StatelessWidget {
  final int? containerIndex;

  const MediaPickerOptions({super.key, this.containerIndex});

  static void show(BuildContext context, {int? containerIndex}) {
    if (_imagePickerCubit.isMaxCapacityReached) {
      Fluttertoast.showToast(
        msg: 'Maximum 6 media items allowed',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return MediaPickerOptions(containerIndex: containerIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24 + 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorPalette.secondary, ColorPalette.black],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Add Media',
                style: AppTextStyles.h1(context).copyWith(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildMediaOption(
              context,
              label: 'Pick Photo from Gallery',
              icon: Icons.image_outlined,
              onTap: () {
                Navigator.pop(context);
                _imagePickerCubit.pickImagesFromGallery(
                  containerIndex: containerIndex,
                );
              },
            ),
            Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
            _buildMediaOption(
              context,
              label: 'Pick Video from Gallery',
              icon: Icons.videocam_outlined,
              onTap: () {
                Navigator.pop(context);
                _imagePickerCubit.pickVideoFromGallery(
                  containerIndex: containerIndex,
                );
              },
            ),
            Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
            _buildMediaOption(
              context,
              label: 'Take a Photo with Camera',
              icon: Icons.photo_camera_outlined,
              onTap: () {
                Navigator.pop(context);
                _imagePickerCubit.pickImageFromCamera(
                  containerIndex: containerIndex,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaOption(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

final _imagePickerCubit = Di().sl<ImagePickerCubit>();
