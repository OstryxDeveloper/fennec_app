import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/text_styles.dart';
import 'custom_sized_box.dart';
import 'custom_text.dart';

class CustomLabelTextField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? keyboardType;
  final String? hintText;
  final Color? labelColor;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final double? borderRadius;
  final bool? filled;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final TextStyle? errorStyle;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final int? minLines;

  const CustomLabelTextField({
    super.key,
    this.label,
    this.controller,
    this.onChanged,
    this.onSubmit,
    this.validator,
    this.readOnly,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.suffix,
    this.prefix,
    this.keyboardType,
    this.hintText,
    this.labelColor,
    this.labelStyle,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.borderRadius,
    this.filled,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.errorStyle,
    this.contentPadding,
    this.maxLines,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          AppText(
            text: label!,
            style:
                labelStyle ??
                AppTextStyles.bodyLarge(context).copyWith(
                  color: labelColor ?? ColorPalette.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        if (label != null) CustomSizedBox(height: 8),

        // Check if using default rounded style or underline style
        if (filled == false || border != null || enabledBorder != null)
          // Underline style (for login screen)
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            onFieldSubmitted: onSubmit,
            validator: validator,
            keyboardType: keyboardType,
            readOnly: readOnly ?? false,
            obscureText: obscureText ?? false,
            maxLines: obscureText == true ? 1 : maxLines,
            minLines: minLines,
            style:
                textStyle ??
                AppTextStyles.bodyLarge(context).copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  hintStyle ?? TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: filled ?? false,
              fillColor: fillColor,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              suffix: suffix,
              prefix: prefix,
              border: border,
              enabledBorder:
                  enabledBorder ??
                  const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
              focusedBorder:
                  focusedBorder ??
                  const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
              errorBorder:
                  errorBorder ??
                  const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
              focusedErrorBorder:
                  focusedErrorBorder ??
                  const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
              errorStyle:
                  errorStyle ??
                  const TextStyle(color: Colors.red, fontSize: 12),
              contentPadding:
                  contentPadding ?? const EdgeInsets.symmetric(vertical: 12),
            ),
          )
        else
          // Rounded style (default - your original style)
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius ?? 15),
            child: TextFormField(
              controller: controller,
              onChanged: onChanged,
              onFieldSubmitted: onSubmit,
              validator: validator,
              keyboardType: keyboardType,
              readOnly: readOnly ?? false,
              obscureText: obscureText ?? false,
              maxLines: obscureText == true ? 1 : (maxLines ?? 1),
              minLines: minLines,
              style: textStyle ?? AppTextStyles.bodyLarge(context),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: hintStyle,
                border: InputBorder.none,
                filled: true,
                fillColor: fillColor ?? ColorPalette.secondry,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                suffix: suffix,
                prefix: prefix,
                contentPadding:
                    contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
      ],
    );
  }
}
