import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {}

class AuthValidationLoading extends AuthState {}

class AuthValidation extends AuthState {
  final int validationCounter;

  AuthValidation({this.validationCounter = 0});

  @override
  List<Object?> get props => [validationCounter];
}

class AuthError extends AuthState {}
