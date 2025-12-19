import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SelectionType { single, multiple }

class DropdownFieldWidget extends StatelessWidget {
  final String label;
  final String subtitle;
  final String? selectedValue;
  final List<String>? selectedValues;
  final List<String> options;
  final Function(String)? onSelected;
  final Function(List<String>)? onMultipleSelected;
  final SelectionType selectionType;

  const DropdownFieldWidget({
    super.key,
    required this.label,
    required this.subtitle,
    this.selectedValue,
    this.selectedValues,
    required this.options,
    this.onSelected,
    this.onMultipleSelected,
    this.selectionType = SelectionType.single,
  });

  @override
  Widget build(BuildContext context) {
    String displayText;
    if (selectionType == SelectionType.multiple) {
      if (selectedValues == null || selectedValues!.isEmpty) {
        displayText = 'Select';
      } else if (selectedValues!.length == 1) {
        displayText = selectedValues!.first;
      } else {
        displayText = '${selectedValues!.length} selected';
      }
    } else {
      displayText = selectedValue ?? 'Select';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          style: AppTextStyles.bodyLarge(
            context,
          ).copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white24)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    text: displayText,
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: displayText == 'Select'
                          ? Colors.white.withOpacity(0.5)
                          : Colors.white,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white70,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    if (selectionType == SelectionType.multiple) {
      _showCheckboxBottomSheet(context);
    } else {
      _showRadioBottomSheet(context);
    }
  }

  void _showCheckboxBottomSheet(BuildContext context) {
    final selected = List<String>.from(selectedValues ?? []);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ColorPalette.secondry, ColorPalette.black],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Column(
                    children: [
                      AppText(
                        text: label,
                        style: AppTextStyles.h1(context).copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        text: subtitle,
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: options.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = selected.contains(option);

                      return InkWell(
                        onTap: () {
                          setModalState(() {
                            if (isSelected) {
                              selected.remove(option);
                            } else {
                              selected.add(option);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ColorPalette.white
                                      : Colors.black,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: SvgPicture.asset(
                                          Assets.icons.verified.path,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: AppText(
                                  text: option,
                                  style: AppTextStyles.bodyLarge(
                                    context,
                                  ).copyWith(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: CustomElevatedButton(
                    onTap: () {
                      onMultipleSelected?.call(selected);
                      Navigator.pop(context);
                    },
                    text: 'Done',
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRadioBottomSheet(BuildContext context) {
    String? selected = selectedValue;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ColorPalette.secondry, ColorPalette.black],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Column(
                    children: [
                      AppText(
                        text: label,
                        style: AppTextStyles.h1(context).copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        text: subtitle,
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: options.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = selected == option;

                      return InkWell(
                        onTap: () {
                          setModalState(() {
                            selected = option;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: AppText(
                                  text: option,
                                  style: AppTextStyles.bodyLarge(
                                    context,
                                  ).copyWith(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: CustomElevatedButton(
                    onTap: () {
                      if (selected != null && onSelected != null) {
                        onSelected!(selected!);
                      }
                      Navigator.pop(context);
                    },
                    text: 'Done',
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
