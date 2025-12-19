import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/bloc/state/imagepicker_state.dart';
import 'package:fennac_app/core/di_container.dart';
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
                          fontSize: 24,
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
                      if (_imagePickerCubit.selectedImagePaths.length > 2) ...[
                        CustomSizedBox(height: 12),
                        Row(
                          children: [
                            if (_imagePickerCubit.selectedImagePaths.length > 2)
                              Expanded(
                                child: GalleryImageItemWidget(
                                  imagePath:
                                      _imagePickerCubit.selectedImagePaths[2],
                                  index: 2,
                                ),
                              ),
                            if (_imagePickerCubit.selectedImagePaths.length >
                                3) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: GalleryImageItemWidget(
                                  imagePath:
                                      _imagePickerCubit.selectedImagePaths[3],
                                  index: 3,
                                ),
                              ),
                            ],
                            if (_imagePickerCubit.selectedImagePaths.length >
                                4) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: GalleryImageItemWidget(
                                  imagePath:
                                      _imagePickerCubit.selectedImagePaths[4],
                                  index: 4,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                      CustomSizedBox(height: 24),

                      // Instructional Text
                      AppText(
                        text:
                            'Drag the photos to sort them. Your primary photo appears at the top and will be used as your profile picture.',
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      CustomSizedBox(height: 40),

                      // Bottom Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomOutlinedButton(
                              onPressed: () {
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
                                // Handle continue action
                                AutoRouter.of(
                                  context,
                                ).push(const DashboardRoute());
                              },
                              text: 'Continue',
                              width: double.infinity,
                            ),
                          ),
                        ],
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
    );
  }
}
