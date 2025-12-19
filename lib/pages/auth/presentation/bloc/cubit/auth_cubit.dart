import 'package:fennac_app/pages/auth/presentation/bloc/state/auth_state.dart';
import 'package:fennac_app/widgets/custom_country_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool obscurePassword = true;
  bool isEmail = true;

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Country? selectedCountry;

  // Individual field validation states
  bool _firstNameTouched = false;
  bool _lastNameTouched = false;
  bool _emailTouched = false;
  bool _phoneTouched = false;
  bool _passwordTouched = false;
  bool _confirmPasswordTouched = false;

  void isObsecure() {
    emit(AuthLoading());
    obscurePassword = !obscurePassword;
    emit(AuthLoaded());
  }

  void isEmailOrPhone() {
    emit(AuthLoading());
    isEmail = !isEmail;
    emit(AuthLoaded());
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a valid email address.';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password must be at least 8 characters.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number is too long';
    }

    return null;
  }

  bool obscureConfirmPassword = true;

  void isObsecureConfirm() {
    emit(AuthLoading());
    obscureConfirmPassword = !obscureConfirmPassword;
    emit(AuthLoaded());
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Individual field validation methods
  void onFirstNameChanged(String value) {
    if (!_firstNameTouched && value.isNotEmpty) {
      _firstNameTouched = true;
      emit(AuthLoaded());
    }
  }

  void onLastNameChanged(String value) {
    if (!_lastNameTouched && value.isNotEmpty) {
      _lastNameTouched = true;
      emit(AuthLoaded());
    }
  }

  void onEmailChanged(String value) {
    if (!_emailTouched && value.isNotEmpty) {
      _emailTouched = true;
      emit(AuthLoaded());
    }
  }

  void onPhoneChanged(String value) {
    if (!_phoneTouched && value.isNotEmpty) {
      _phoneTouched = true;
      emit(AuthLoaded());
    }
  }

  void onPasswordChanged(String value) {
    if (!_passwordTouched && value.isNotEmpty) {
      _passwordTouched = true;
      emit(AuthLoaded());
    }
  }

  void onConfirmPasswordChanged(String value) {
    if (!_confirmPasswordTouched && value.isNotEmpty) {
      _confirmPasswordTouched = true;
      emit(AuthLoaded());
    }
  }

  // Get validation error for individual fields (only if touched)
  String? getFirstNameError() {
    return _firstNameTouched ? validateName(firstNameController.text) : null;
  }

  String? getLastNameError() {
    return _lastNameTouched ? validateName(lastNameController.text) : null;
  }

  String? getEmailError() {
    return _emailTouched ? validateEmail(emailController.text) : null;
  }

  String? getPhoneError() {
    return _phoneTouched ? validatePhoneNumber(phoneController.text) : null;
  }

  String? getPasswordError() {
    return _passwordTouched ? validatePassword(passwordController.text) : null;
  }

  String? getConfirmPasswordError() {
    return _confirmPasswordTouched
        ? validateConfirmPassword(
            confirmPasswordController.text,
            passwordController.text,
          )
        : null;
  }

  void loadCountry() {
    emit(AuthLoading());
    loadCountries().then((countries) {
      selectedCountry = countries.firstWhere(
        (c) => c.iso == 'US',
        orElse: () => countries.first,
      );
      emit(AuthLoaded());
    });
  }

  int a = 3;
  int b = 8;

  int getAwithB(int x) {
    return 11 - x;
  }

  // write function to make anagram is or not
  bool isAnagram(String str1, String str2) {
    if (str1.length != str2.length) {
      return false;
    }
    final charCount = <String, int>{};
    for (var char in str1.split('')) {
      charCount[char] = (charCount[char] ?? 0) + 1;
    }
    for (var char in str2.split('')) {
      if (!charCount.containsKey(char) || charCount[char] == 0) {
        return false;
      }
      charCount[char] = charCount[char]! - 1;
    }
    return true;
  }

  void swap() {
    emit(AuthLoading());
    a = a + b;
    b = a - b;
    a = a - b;
    emit(AuthLoaded());
  }
}
