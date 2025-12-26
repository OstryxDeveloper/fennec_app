import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {}

class LoginValidationLoading extends LoginState {}

class LoginValidation extends LoginState {
  final int validationCounter;

  LoginValidation({this.validationCounter = 0});

  @override
  List<Object?> get props => [validationCounter];
}

class LoginError extends LoginState {}
