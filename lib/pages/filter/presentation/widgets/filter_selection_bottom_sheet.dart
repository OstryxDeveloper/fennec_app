import 'package:fennac_app/app/constants/media_query_constants.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'filter_pill.dart';

class FilterSelectionBottomSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onOptionSelected;

  const FilterSelectionBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  State<FilterSelectionBottomSheet> createState() =>
      _FilterSelectionBottomSheetState();
}

class _FilterSelectionBottomSheetState
    extends State<FilterSelectionBottomSheet> {
  late String _tempSelectedOption;

  @override
  void initState() {
    super.initState();
    _tempSelectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: getHeight(context) * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorPalette.secondary, ColorPalette.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    text: widget.title,
                    style: AppTextStyles.h1(context).copyWith(
                      color: ColorPalette.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  ),
                ),
                CustomSizedBox(width: 12),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter options
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: widget.options
                    .map(
                      (option) => FilterPill(
                        label: option,
                        isSelected: _tempSelectedOption == option,
                        onTap: () {
                          setState(() {
                            _tempSelectedOption = option;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          CustomSizedBox(height: 24),

          // Done button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: CustomElevatedButton(
              text: 'Done',
              onTap: () {
                widget.onOptionSelected(_tempSelectedOption);
                Navigator.pop(context);
              },
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
