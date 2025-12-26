import 'package:equatable/equatable.dart';
import 'package:fennac_app/bloc/cubit/imagepicker_cubit.dart';

class ImagePickerState extends Equatable {
  final List<MediaItem>? mediaList;
  final String? errorMessage;

  const ImagePickerState({this.mediaList, this.errorMessage});

  @override
  List<Object?> get props => [mediaList, errorMessage];
}

class ImagePickerInitial extends ImagePickerState {
  const ImagePickerInitial() : super(mediaList: const [], errorMessage: null);
}

class ImagePickerLoading extends ImagePickerState {
  const ImagePickerLoading({super.mediaList}) : super(errorMessage: null);
}

class ImagePickerLoaded extends ImagePickerState {
  const ImagePickerLoaded({List<MediaItem>? mediaList})
    : super(mediaList: mediaList ?? const [], errorMessage: null);
}

class ImagePickerError extends ImagePickerState {
  const ImagePickerError(String message)
    : super(mediaList: const [], errorMessage: message);
}
