import 'dart:async';
import 'package:fennac_app/pages/auth/presentation/bloc/state/auth_state.dart';
import 'package:fennac_app/widgets/custom_country_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // UI states
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmNewPassword = true;
  bool isEmail = true;

  // OTP states
  int _remainingSeconds = 120; // 2 minutes
  Timer? _otpTimer;
  bool _canResendOtp = false;
  String? _otpErrorMessage;
  bool _isOtpBlurred = false;

  int get remainingSeconds => _remainingSeconds;
  bool get canResendOtp => _canResendOtp;
  String? get otpErrorMessage => _otpErrorMessage;
  bool get isOtpBlurred => _isOtpBlurred;

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  Country? selectedCountry;

  bool _firstNameTouched = false;
  bool _lastNameTouched = false;
  bool _emailTouched = false;
  bool _phoneTouched = false;
  bool _passwordTouched = false;
  bool _confirmPasswordTouched = false;
  bool _newPasswordTouched = false;
  bool _confirmNewPasswordTouched = false;

  int _validationCounter = 0;

  void togglePasswordVisibility() {
    emit(AuthValidationLoading());
    obscurePassword = !obscurePassword;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void toggleConfirmPasswordVisibility() {
    emit(AuthValidationLoading());
    obscureConfirmPassword = !obscureConfirmPassword;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void toggleNewPasswordVisibility() {
    emit(AuthValidationLoading());
    obscureNewPassword = !obscureNewPassword;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void toggleConfirmNewPasswordVisibility() {
    emit(AuthValidationLoading());
    obscureConfirmNewPassword = !obscureConfirmNewPassword;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void toggleEmailOrPhone() {
    emit(AuthValidationLoading());
    isEmail = !isEmail;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password must be at least 8 characters';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
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

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password must be at least 8 characters';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? validateConfirmNewPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Passwords don\'t match';
    }
    if (value != password) {
      return 'Passwords don\'t match';
    }
    return null;
  }

  void onFirstNameChanged(String value) {
    _firstNameTouched = true;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void onLastNameChanged(String value) {
    _lastNameTouched = true;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void onEmailChanged(String value) {
    _emailTouched = true;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void onPhoneChanged(String value) {
    _phoneTouched = true;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void onPasswordChanged(String value) {
    _passwordTouched = true;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void onConfirmPasswordChanged(String value) {
    _confirmPasswordTouched = true;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void onNewPasswordChanged(String value) {
    _newPasswordTouched = true;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void onConfirmNewPasswordChanged(String value) {
    _confirmNewPasswordTouched = true;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  String? getFirstNameError() {
    try {
      return _firstNameTouched ? validateName(firstNameController.text) : null;
    } catch (e) {
      return null;
    }
  }

  String? getLastNameError() {
    try {
      return _lastNameTouched ? validateName(lastNameController.text) : null;
    } catch (e) {
      return null;
    }
  }

  String? getEmailError() {
    try {
      return _emailTouched ? validateEmail(emailController.text) : null;
    } catch (e) {
      return null;
    }
  }

  String? getPhoneError() {
    try {
      return _phoneTouched ? validatePhoneNumber(phoneController.text) : null;
    } catch (e) {
      return null;
    }
  }

  String? getPasswordError() {
    try {
      return _passwordTouched
          ? validatePassword(passwordController.text)
          : null;
    } catch (e) {
      return null;
    }
  }

  String? getConfirmPasswordError() {
    try {
      return _confirmPasswordTouched
          ? validateConfirmPassword(
              confirmPasswordController.text,
              passwordController.text,
            )
          : null;
    } catch (e) {
      return null;
    }
  }

  String? getNewPasswordError() {
    try {
      return _newPasswordTouched
          ? validateNewPassword(newPasswordController.text)
          : null;
    } catch (e) {
      return null;
    }
  }

  String? getConfirmNewPasswordError() {
    try {
      return _confirmNewPasswordTouched
          ? validateConfirmNewPassword(
              confirmNewPasswordController.text,
              newPasswordController.text,
            )
          : null;
    } catch (e) {
      return null;
    }
  }

  void submit() {
    _firstNameTouched = true;
    _lastNameTouched = true;
    _emailTouched = true;
    _phoneTouched = true;
    _passwordTouched = true;
    _confirmPasswordTouched = true;
    _validationCounter++;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  bool isFormValid() {
    return getFirstNameError() == null &&
        getLastNameError() == null &&
        getEmailError() == null &&
        getPhoneError() == null &&
        getPasswordError() == null &&
        getConfirmPasswordError() == null;
  }

  void loadCountry() {
    emit(AuthValidationLoading());
    loadCountries().then((countries) {
      selectedCountry = countries.firstWhere(
        (c) => c.iso == 'US',
        orElse: () => countries.first,
      );
      emit(AuthValidation(validationCounter: _validationCounter));
    });
  }

  void submitNewPassword() {
    emit(AuthValidationLoading());
    _newPasswordTouched = true;
    _confirmNewPasswordTouched = true;
    _validationCounter++;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  void updatePassword() {
    emit(AuthLoading());

    emit(AuthLoaded());
  }

  // ============ OTP Verification Methods ============

  /// Start OTP timer (120 seconds / 2 minutes)
  void startOtpTimer() {
    emit(AuthValidationLoading());
    _canResendOtp = false;
    _remainingSeconds = 120;
    _otpErrorMessage = null;
    _isOtpBlurred = false;
    _validationCounter++; // Increment to trigger initial emit
    emit(AuthValidation(validationCounter: _validationCounter));

    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _validationCounter++; // Increment counter each tick to trigger rebuild
        emit(AuthValidation(validationCounter: _validationCounter));
      } else {
        _otpTimer?.cancel();
        _canResendOtp = true;
        _validationCounter++;
        emit(AuthValidation(validationCounter: _validationCounter));
      }
    });
  }

  /// Format time for display (MM:SS)
  String formatOtpTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Verify OTP code
  Future<bool> verifyOtpCode(String otpCode, String expectedCode) async {
    try {
      if (otpCode != expectedCode) {
        _otpErrorMessage = 'Incorrect OTP code. Please try again.';
        emit(AuthValidation(validationCounter: _validationCounter));
        return false;
      }

      _otpErrorMessage = null;
      _isOtpBlurred = true;
      emit(AuthValidation(validationCounter: _validationCounter));
      return true;
    } catch (e) {
      _otpErrorMessage = 'An error occurred. Please try again.';
      emit(AuthValidation(validationCounter: _validationCounter));
      return false;
    }
  }

  /// Resend OTP code
  void resendOtpCode() {
    if (!_canResendOtp) return;

    startOtpTimer();
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  /// Clear OTP error message
  void clearOtpError() {
    _otpErrorMessage = null;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  /// Reset OTP blur state
  void resetOtpBlur() {
    _isOtpBlurred = false;
    emit(AuthValidation(validationCounter: _validationCounter));
  }

  /// Cleanup OTP timer
  void disposeOtpTimer() {
    _otpTimer?.cancel();
  }

  @override
  Future<void> close() {
    disposeOtpTimer();
    return super.close();
  }
}
