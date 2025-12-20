import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/text_styles.dart';

class CustomOtpField extends StatefulWidget {
  final int length;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final Color? color;

  const CustomOtpField({
    super.key,
    this.length = 6,
    required this.controller,
    this.onChanged,
    this.onCompleted,
    this.color,
  });

  @override
  State<CustomOtpField> createState() => _CustomOtpFieldState();
}

class _CustomOtpFieldState extends State<CustomOtpField> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: AppTextStyles.h2(
        context,
      ).copyWith(color: ColorPalette.white, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: ColorPalette.black.withOpacity(.3),
        border: Border.all(color: widget.color ?? Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: widget.color ?? Colors.white70, width: 1),
      borderRadius: BorderRadius.circular(16),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.transparent,
      ),
    );

    return Pinput(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      length: widget.length,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (pin) => widget.onChanged?.call(pin),
      showCursor: true,
      controller: widget.controller,
      onCompleted: (pin) => widget.onCompleted?.call(pin),
    );
  }
}
