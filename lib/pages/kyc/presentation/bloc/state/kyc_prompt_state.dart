import 'package:equatable/equatable.dart';

class KycPromptState extends Equatable {
  @override
  List<Object?> get props => [];
}

class KycPromptInitial extends KycPromptState {}

class KycPromptLoading extends KycPromptState {}

class KycPromptLoaded extends KycPromptState {}

class KycPromptError extends KycPromptState {}

