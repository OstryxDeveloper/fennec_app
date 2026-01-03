import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/bloc/state/imagepicker_state.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/continue_button.dart';
import 'package:fennac_app/reusable_widgets/gallery_grid_widget.dart';
import 'package:fennac_app/reusable_widgets/media_picker_options.dart';
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
        backgroundType: MovableBackgroundType.medium,
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
                        GalleryGridWidget(
                          mediaList: mediaList,
                          onShowMediaPicker: (context, {containerIndex}) {
                            MediaPickerOptions.show(
                              context,
                              containerIndex: containerIndex,
                            );
                          },
                        ),
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
                  AutoRouter.of(context).push(const KycMatchRoute());
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
