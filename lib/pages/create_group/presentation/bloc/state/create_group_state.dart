import 'package:equatable/equatable.dart';

abstract class CreateGroupState extends Equatable {
  const CreateGroupState();
  @override
  List<Object?> get props => [];
}

class CreateGroupInitial extends CreateGroupState {}

class CreateGroupLoading extends CreateGroupState {}

class CreateGroupLoaded extends CreateGroupState {}

class CreateGroupPermissionDenied extends CreateGroupState {}

class CreateGroupPermissionPermanentlyDenied extends CreateGroupState {}

class CreateGroupError extends CreateGroupState {}
