import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/bloc/state/imagepicker_state.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/continue_button.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/media_container_widget.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

@RoutePage()
class KycGalleryScreen extends StatelessWidget {
  const KycGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imagePickerCubit = Di().sl<ImagePickerCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: MovableBackground(
        child: SafeArea(
          child: BlocListener<ImagePickerCubit, ImagePickerState>(
            bloc: imagePickerCubit,
            listenWhen: (previous, current) =>
                current.errorMessage != null &&
                current.errorMessage != previous.errorMessage,
            listener: (context, state) {
              if (state.errorMessage != null) {
                Fluttertoast.showToast(
                  msg: state.errorMessage ?? 'Error',
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            },
            child: BlocBuilder<ImagePickerCubit, ImagePickerState>(
              bloc: imagePickerCubit,
              builder: (context, state) {
                final mediaList = state.mediaList ?? [];

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSizedBox(height: 24),
                        const CustomBackButton(),
                        CustomSizedBox(height: 32),

                        AppText(
                          text: 'Upload your best shots and short clips.',
                          style: AppTextStyles.h1(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        CustomSizedBox(height: 32),

                        // Gallery Grid Layout
                        _buildGalleryGrid(context, imagePickerCubit, mediaList),
                        CustomSizedBox(height: 24),

                        // Instructional Text
                        AppText(
                          text:
                              'Drag the photos to sort them. Your primary photo appears at the top and will be used as your profile picture.',
                          style: AppTextStyles.bodyLarge(context).copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            height: 1.6,
                          ),
                        ),
                        CustomSizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: CustomOutlinedButton(
                onPressed: () {
                  AutoRouter.of(context).push(const KycPromptRoute());
                },
                text: 'Skip',
                width: double.infinity,
              ),
            ),
            const CustomSizedBox(width: 16),

            Expanded(
              child: ContinueButton(
                onTap: () {
                  AutoRouter.of(context).push(const KycMatchRoute());
                },
                text: 'Continue',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryGrid(
    BuildContext context,
    ImagePickerCubit cubit,
    List<MediaItem> mediaList,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final largeSize = 250.0;
        final smallSize = 120.0;
        final gap = 8.0;

        // Adjust sizes if needed based on available width
        final availableWidthForTop = largeSize + gap + smallSize;
        final scaleFactor = maxWidth < availableWidthForTop
            ? maxWidth / availableWidthForTop
            : 1.0;

        final adjustedLargeSize = largeSize * scaleFactor;
        final adjustedSmallSize = smallSize * scaleFactor;

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: adjustedLargeSize,
                  width: adjustedLargeSize,
                  child: MediaContainerWidget(
                    media: mediaList.isNotEmpty ? mediaList[0] : null,
                    index: 0,
                    width: adjustedLargeSize,
                    height: adjustedLargeSize,
                    onTapAdd: () async {
                      _showMediaPickerOptions(
                        context,
                        cubit,
                        containerIndex: 0,
                      );
                    },
                  ),
                ),
                CustomSizedBox(width: gap),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: adjustedSmallSize,
                      height: adjustedSmallSize,
                      child: MediaContainerWidget(
                        media: mediaList.length > 1 ? mediaList[1] : null,
                        index: 1,
                        width: adjustedSmallSize,
                        height: adjustedSmallSize,
                        onTapAdd: () async {
                          _showMediaPickerOptions(
                            context,
                            cubit,
                            containerIndex: 1,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: gap),
                    SizedBox(
                      width: adjustedSmallSize,
                      height: adjustedSmallSize,
                      child: MediaContainerWidget(
                        media: mediaList.length > 2 ? mediaList[2] : null,
                        index: 2,
                        width: adjustedSmallSize,
                        height: adjustedSmallSize,
                        onTapAdd: () async {
                          _showMediaPickerOptions(
                            context,
                            cubit,
                            containerIndex: 2,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: gap),
            // Bottom row: 3 small containers with flexible widths
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: adjustedSmallSize,
                    child: MediaContainerWidget(
                      media: mediaList.length > 3 ? mediaList[3] : null,
                      index: 3,
                      width: adjustedSmallSize,
                      height: adjustedSmallSize,
                      onTapAdd: () async {
                        _showMediaPickerOptions(
                          context,
                          cubit,
                          containerIndex: 3,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: gap),
                Expanded(
                  child: SizedBox(
                    height: adjustedSmallSize,
                    child: MediaContainerWidget(
                      media: mediaList.length > 4 ? mediaList[4] : null,
                      index: 4,
                      width: adjustedSmallSize,
                      height: adjustedSmallSize,
                      onTapAdd: () async {
                        _showMediaPickerOptions(
                          context,
                          cubit,
                          containerIndex: 4,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: gap),
                Expanded(
                  child: SizedBox(
                    height: adjustedSmallSize,
                    child: MediaContainerWidget(
                      media: mediaList.length > 5 ? mediaList[5] : null,
                      index: 5,
                      width: adjustedSmallSize,
                      height: adjustedSmallSize,
                      onTapAdd: () async {
                        _showMediaPickerOptions(
                          context,
                          cubit,
                          containerIndex: 5,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showMediaPickerOptions(
    BuildContext context,
    ImagePickerCubit cubit, {
    int? containerIndex,
  }) {
    if (cubit.isMaxCapacityReached) {
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
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24 + 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ColorPalette.secondry, ColorPalette.black],
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
                  label: 'Pick Photo from Gallery',
                  icon: Icons.image_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    cubit.pickImagesFromGallery(containerIndex: containerIndex);
                  },
                ),
                Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
                _buildMediaOption(
                  label: 'Pick Video from Gallery',
                  icon: Icons.videocam_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    cubit.pickVideoFromGallery(containerIndex: containerIndex);
                  },
                ),
                Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
                _buildMediaOption(
                  label: 'Take a Photo with Camera',
                  icon: Icons.photo_camera_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    cubit.pickImageFromCamera(containerIndex: containerIndex);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaOption({
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
