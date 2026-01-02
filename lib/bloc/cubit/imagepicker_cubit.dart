import 'dart:io';

import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/bloc/state/imagepicker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class MediaItem {
  final String path;
  final MediaType type;
  final String id;

  MediaItem({required this.path, required this.type, required this.id});
}

enum MediaType { image, video }

class ImagePickerCubit extends Cubit<ImagePickerState> {
  static const int maxMediaItems = 6;

  ImagePickerCubit() : super(ImagePickerInitial());

  final ImagePicker _imagePicker = ImagePicker();
  final ImageCropper _imageCropper = ImageCropper();
  List<MediaItem> mediaList = [];
  File? selectedImage;

  /// Force square cropping for every image selection.
  Future<String?> _cropToSquare(String sourcePath) async {
    try {
      final croppedFile = await _imageCropper.cropImage(
        sourcePath: sourcePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            backgroundColor: ColorPalette.secondary,
            toolbarColor: ColorPalette.secondary,
            toolbarTitle: 'Crop Image',
            lockAspectRatio: true,
            hideBottomControls: true,
            toolbarWidgetColor: Colors.white,
            statusBarLight: true,
          ),
          IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
        ],
      );

      return croppedFile?.path;
    } catch (e) {
      debugPrint('Error while cropping image: $e');
      emit(ImagePickerError('Could not crop image'));
      return null;
    }
  }

  /// Pick single or multiple images from gallery and add to specific index
  Future<void> pickImagesFromGallery({int? containerIndex}) async {
    if (mediaList.length >= maxMediaItems) {
      emit(ImagePickerError('Maximum $maxMediaItems media items allowed'));
      return;
    }

    emit(ImagePickerLoading());
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        for (var file in pickedFiles) {
          if (mediaList.length < maxMediaItems) {
            final croppedPath = await _cropToSquare(file.path);
            if (croppedPath == null) {
              continue;
            }

            final newItem = MediaItem(
              path: croppedPath,
              type: MediaType.image,
              id:
                  DateTime.now().millisecondsSinceEpoch.toString() +
                  mediaList.length.toString(),
            );

            // Add to specific container if provided, otherwise append
            if (containerIndex != null) {
              if (containerIndex == -1) {
                selectedImage = File(newItem.path);
              } else if (containerIndex >= 0 &&
                  containerIndex < maxMediaItems) {
                if (containerIndex < mediaList.length) {
                  mediaList[containerIndex] = newItem;
                } else {
                  mediaList.add(newItem);
                }
              }
            } else {
              mediaList.add(newItem);
            }
          }
        }
        emit(ImagePickerLoaded(mediaList: mediaList));
      } else {
        emit(ImagePickerLoaded(mediaList: mediaList));
      }
    } catch (e) {
      emit(ImagePickerError('Error picking images: $e'));
      debugPrint('Error picking images from gallery: $e');
    }
  }

  /// Pick video from gallery and add to specific index
  Future<void> pickVideoFromGallery({int? containerIndex}) async {
    if (mediaList.length >= maxMediaItems) {
      emit(ImagePickerError('Maximum $maxMediaItems media items allowed'));
      return;
    }

    emit(ImagePickerLoading());
    try {
      final XFile? pickedFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (pickedFile != null) {
        final newItem = MediaItem(
          path: pickedFile.path,
          type: MediaType.video,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        );

        // Add to specific container if provided, otherwise append
        if (containerIndex != null &&
            containerIndex >= 0 &&
            containerIndex < maxMediaItems) {
          if (containerIndex < mediaList.length) {
            mediaList[containerIndex] = newItem;
          } else {
            mediaList.add(newItem);
          }
        } else {
          mediaList.add(newItem);
        }
        emit(ImagePickerLoaded(mediaList: mediaList));
      } else {
        emit(ImagePickerLoaded(mediaList: mediaList));
      }
    } catch (e) {
      emit(ImagePickerError('Error picking video: $e'));
      debugPrint('Error picking video from gallery: $e');
    }
  }

  /// Pick image from camera and add to specific index
  Future<void> pickImageFromCamera({int? containerIndex}) async {
    if (mediaList.length >= maxMediaItems) {
      emit(ImagePickerError('Maximum $maxMediaItems media items allowed'));
      return;
    }

    emit(ImagePickerLoading());
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final croppedPath = await _cropToSquare(pickedFile.path);
        if (croppedPath == null) {
          emit(ImagePickerLoaded(mediaList: mediaList));
          return;
        }

        final newItem = MediaItem(
          path: croppedPath,
          type: MediaType.image,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        );

        // Add to specific container if provided, otherwise append
        if (containerIndex != null &&
            containerIndex >= 0 &&
            containerIndex < maxMediaItems) {
          if (containerIndex < mediaList.length) {
            mediaList[containerIndex] = newItem;
          } else {
            mediaList.add(newItem);
          }
        } else {
          mediaList.add(newItem);
        }
        emit(ImagePickerLoaded(mediaList: mediaList));
      } else {
        emit(ImagePickerLoaded(mediaList: mediaList));
      }
    } catch (e) {
      emit(ImagePickerError('Error picking image from camera: $e'));
      debugPrint('Error picking image from camera: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    emit(ImagePickerLoading());
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );

      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        emit(ImagePickerSuccess());
      }
    } catch (e) {
      emit(ImagePickerError('Error picking image from gallery: $e'));

      debugPrint('Error picking image from gallery: $e');
    }
  }

  /// Remove media item by ID or by index
  void removeMedia(String? id, {int? index}) {
    emit(ImagePickerLoading());
    if (id == 'header_image' || index == -1) {
      selectedImage = null;
    } else if (id != null) {
      mediaList.removeWhere((item) => item.id == id);
    } else if (index != null && index >= 0 && index < mediaList.length) {
      mediaList.removeAt(index);
    }
    emit(ImagePickerLoaded(mediaList: mediaList));
  }

  /// Reorder media items by dragging
  void reorderMedia(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= mediaList.length ||
        newIndex < 0 ||
        newIndex >= mediaList.length) {
      return;
    }

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = mediaList.removeAt(oldIndex);
    mediaList.insert(newIndex, item);
    emit(ImagePickerLoaded(mediaList: mediaList));
  }

  /// Clear all media
  void clearAllMedia() {
    mediaList.clear();
    emit(ImagePickerLoaded(mediaList: mediaList));
  }

  /// Get current count of media
  int get mediaCount => mediaList.length;

  /// Check if max capacity reached
  bool get isMaxCapacityReached => mediaList.length >= maxMediaItems;

  /// Get remaining slots
  int get remainingSlots => maxMediaItems - mediaList.length;

  Future<void> pickMultipleImagesFromGallery() async {
    await pickImagesFromGallery();
  }
}
