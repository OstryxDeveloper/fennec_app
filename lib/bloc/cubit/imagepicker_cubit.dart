import 'dart:io';

import 'package:fennac_app/bloc/state/imagepicker_state.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit() : super(ImagePickerInitial());

  final ImagePicker _imagePicker = ImagePicker();
  List<File> selectedImages = [];
  List<String> selectedImagePaths = [
    Assets.dummy.portrait.path,
    Assets.dummy.portrait1.path,
    Assets.dummy.portrait2.path,
    Assets.dummy.portrait3.path,
    Assets.dummy.portrait4.path,
  ];

  Future<void> pickImageFromGallery() async {
    emit(ImagePickerLoading());
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );

      if (pickedFile != null) {
        selectedImages.add(File(pickedFile.path));
        emit(ImagePickerLoaded());
      }
    } catch (e) {
      emit(ImagePickerError());
      debugPrint('Error picking image from gallery: $e');
    }
  }

  Future<void> pickMultipleImagesFromGallery() async {
    emit(ImagePickerLoading());
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        requestFullMetadata: false,
      );

      if (pickedFiles.isNotEmpty) {
        selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        emit(ImagePickerLoaded());
      }
    } catch (e) {
      emit(ImagePickerError());
      debugPrint('Error picking images from gallery: $e');
    }
  }

  Future<void> pickImageFromCamera() async {
    emit(ImagePickerLoading());

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 80,
        requestFullMetadata: false,
      );

      if (pickedFile != null) {
        selectedImages.add(File(pickedFile.path));
        emit(ImagePickerLoaded());
      }
    } catch (e) {
      emit(ImagePickerError());

      debugPrint('Error picking image from camera: $e');
    }
  }

  void removeImage(int index) {
    emit(ImagePickerLoading());
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      emit(ImagePickerLoaded());
    }
    // Also remove from asset paths
    if (index >= 0 && index < selectedImagePaths.length) {
      selectedImagePaths.removeAt(index);
      emit(ImagePickerLoaded());
    }
  }

  void reorderImages(int oldIndex, int newIndex) {
    emit(ImagePickerLoading());
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    if (oldIndex >= 0 &&
        oldIndex < selectedImages.length &&
        newIndex >= 0 &&
        newIndex < selectedImages.length) {
      final item = selectedImages.removeAt(oldIndex);
      selectedImages.insert(newIndex, item);
      emit(ImagePickerLoaded());
    }
    // Also reorder asset paths
    if (oldIndex >= 0 &&
        oldIndex < selectedImagePaths.length &&
        newIndex >= 0 &&
        newIndex < selectedImagePaths.length) {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = selectedImagePaths.removeAt(oldIndex);
      selectedImagePaths.insert(newIndex, item);
      emit(ImagePickerLoaded());
    }
  }

  void clearAllImages() {
    emit(ImagePickerLoading());
    selectedImages.clear();
    selectedImagePaths.clear();
    emit(ImagePickerLoaded());
  }

  // Legacy support
  File? get selectedImage =>
      selectedImages.isNotEmpty ? selectedImages.first : null;

  void clearSelectedImage() {
    clearAllImages();
  }
}
