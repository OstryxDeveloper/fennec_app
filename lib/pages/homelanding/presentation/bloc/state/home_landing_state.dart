import 'package:equatable/equatable.dart';

class HomeLandingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeLandingInitial extends HomeLandingState {}

class HomeLandingLoading extends HomeLandingState {}

class HomeLandingLoaded extends HomeLandingState {}

class HomeLandingError extends HomeLandingState {}
