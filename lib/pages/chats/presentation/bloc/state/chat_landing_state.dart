import 'package:equatable/equatable.dart';

class ChatLandingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatLandingInitial extends ChatLandingState {}

class ChatLandingLoading extends ChatLandingState {}

class ChatLandingLoaded extends ChatLandingState {}

class ChatLandingError extends ChatLandingState {}
