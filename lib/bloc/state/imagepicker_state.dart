import 'package:equatable/equatable.dart';

class ImagePickerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImagePickerInitial extends ImagePickerState {}

class ImagePickerLoading extends ImagePickerState {}

class ImagePickerLoaded extends ImagePickerState {}

class ImagePickerError extends ImagePickerState {}
