import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme/app_colors.dart';
import '../app/theme/text_styles.dart';

class CustomOtpField extends StatefulWidget {
  final int length;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const CustomOtpField({
    super.key,
    this.length = 6,
    required this.controller,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<CustomOtpField> createState() => _CustomOtpFieldState();
}

class _CustomOtpFieldState extends State<CustomOtpField> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );

    // Initialize controllers with existing text if any
    for (
      int i = 0;
      i < widget.controller.text.length && i < widget.length;
      i++
    ) {
      _controllers[i].text = widget.controller.text[i];
    }

    // Listen to the main controller changes
    widget.controller.addListener(_syncFromMainController);
  }

  void _syncFromMainController() {
    String text = widget.controller.text;
    for (int i = 0; i < widget.length; i++) {
      if (i < text.length) {
        if (_controllers[i].text != text[i]) {
          _controllers[i].text = text[i];
        }
      } else {
        _controllers[i].clear();
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncFromMainController);
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    // Update main controller
    String otp = _controllers.map((c) => c.text).join();
    widget.controller.text = otp;

    if (widget.onChanged != null) {
      widget.onChanged!(otp);
    }

    if (otp.length == widget.length && widget.onCompleted != null) {
      widget.onCompleted!(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 48, // Adjust width as needed
          height: 56, // Adjust height as needed
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorPalette.white.withOpacity(0.2),
              width: 1,
            ),
            color: Colors.transparent,
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: AppTextStyles.h2(
              context,
            ).copyWith(color: ColorPalette.white, fontWeight: FontWeight.bold),
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => _onChanged(value, index),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        );
      }),
    );
  }
}
