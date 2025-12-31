import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';
import 'package:fennac_app/bloc/state/imagepicker_state.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/reusable_widgets/custom_app_bar.dart';
import 'package:fennac_app/reusable_widgets/gallery_grid_widget.dart';
import 'package:fennac_app/reusable_widgets/media_picker_options.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CreateGroupGalleryScreen extends StatelessWidget {
  const CreateGroupGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MovableBackground(
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
                    CustomSizedBox(height: 16),
                    CustomAppBar(title: 'Create a Group'),
                    // Gallery Grid Layout
                    GalleryGridWidget(
                      mediaList: mediaList,
                      onShowMediaPicker: (context, {containerIndex}) {
                        MediaPickerOptions.show(
                          context,
                          containerIndex: containerIndex,
                        );
                      },
                      hasHeader: true,
                      headerMedia: imagePickerCubit.selectedImage != null
                          ? MediaItem(
                              path: imagePickerCubit.selectedImage!.path,
                              type: MediaType.image,
                              id: 'header_image',
                            )
                          : null,
                    ),

                    CustomSizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: CustomElevatedButton(
          text: 'Create Prompt',
          onTap: () {
            AutoRouter.of(context).push(KycPromptRoute(showSkipButton: false));
          },
        ),
      ),
    );
  }
}

final imagePickerCubit = Di().sl<ImagePickerCubit>();
