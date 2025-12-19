import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/bloc/state/imagepicker_state.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/gallery_grid_widget.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/gallery_image_item_widget.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/gallery_upload_widget.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_back_button.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_outlined_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class KycGalleryScreen extends StatelessWidget {
  const KycGalleryScreen({super.key});

  ImagePickerCubit get _imagePickerCubit => Di().sl<ImagePickerCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: MovableBackground(
        child: SafeArea(
          child: BlocBuilder<ImagePickerCubit, ImagePickerState>(
            bloc: _imagePickerCubit,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSizedBox(height: 20),
                      // Back Button
                      CustomBackButton(),
                      CustomSizedBox(height: 32),

                      // Header
                      AppText(
                        text: 'Upload your best shots and short clips.',
                        style: AppTextStyles.h1(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      CustomSizedBox(height: 32),

                      // Media Upload Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Upload Placeholder
                          Expanded(flex: 2, child: GalleryUploadWidget()),
                          const SizedBox(width: 12),
                          // Gallery Grid
                          Expanded(flex: 1, child: GalleryGridWidget()),
                        ],
                      ),
                      // Additional Image Items
                      CustomSizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Upload Placeholder or Image at index 2
                          Expanded(
                            flex: 2,
                            child:
                                _imagePickerCubit.selectedImagePaths.length > 2
                                ? GalleryImageItemWidget(
                                    imagePath:
                                        _imagePickerCubit.selectedImagePaths[2],
                                    index: 2,
                                  )
                                : _buildUploadPlaceholder(2),
                          ),
                          const SizedBox(width: 12),
                          // Image at index 3 or Empty slot
                          Expanded(
                            flex: 1,
                            child:
                                _imagePickerCubit.selectedImagePaths.length > 3
                                ? GalleryImageItemWidget(
                                    imagePath:
                                        _imagePickerCubit.selectedImagePaths[3],
                                    index: 3,
                                  )
                                : _buildUploadPlaceholder(3),
                          ),
                          // Image at index 4 if exists
                          if (_imagePickerCubit.selectedImagePaths.length >
                              4) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: GalleryImageItemWidget(
                                imagePath:
                                    _imagePickerCubit.selectedImagePaths[4],
                                index: 4,
                              ),
                            ),
                          ],
                        ],
                      ),

                      CustomSizedBox(height: 24),

                      // Instructional Text
                      AppText(
                        text:
                            'Drag the photos to sort them. Your primary photo appears at the top and will be used as your profile picture.',
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: CustomOutlinedButton(
                onPressed: () {
                  // Handle skip action
                  AutoRouter.of(context).pop();
                },
                text: 'Skip',
                width: double.infinity,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomElevatedButton(
                onTap: () {
                  AutoRouter.of(context).push(const KycMatchRoute());
                },
                text: 'Continue',
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder(int index) {
    return GestureDetector(
      onTap: () => _imagePickerCubit.pickMultipleImagesFromGallery(),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: ColorPalette.secondry.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Center(
          child: SvgPicture.asset(
            Assets.icons.camera.path,
            fit: BoxFit.scaleDown,
            width: 32,
            height: 32,
          ),
        ),
      ),
    );
  }
}
