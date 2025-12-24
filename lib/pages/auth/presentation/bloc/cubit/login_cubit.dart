import 'package:fennac_app/pages/auth/presentation/bloc/state/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  int _validationCounter = 0;
  bool obscurePassword = true;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a valid email address';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password must be at least 8 characters';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  void togglePasswordVisibility() {
    emit(LoginValidationLoading());
    obscurePassword = !obscurePassword;
    emit(LoginValidation(validationCounter: _validationCounter));
  }
}
