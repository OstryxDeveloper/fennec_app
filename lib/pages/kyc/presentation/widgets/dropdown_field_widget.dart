import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SelectionType { single, multiple }

class DropdownFieldWidget extends StatefulWidget {
  final String label;
  final String subtitle;
  final String? selectedValue;
  final List<String>? selectedValues;
  final List<String> options;
  final Function(String)? onSelected;
  final Function(List<String>)? onMultipleSelected;
  final SelectionType selectionType;
  final ValueNotifier<bool>? blurNotifier;

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
    this.blurNotifier,
  });

  @override
  State<DropdownFieldWidget> createState() => _DropdownFieldWidgetState();
}

class _DropdownFieldWidgetState extends State<DropdownFieldWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceInOut),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    _bounceController.reset();
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });

    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;

    widget.blurNotifier?.value = true;
    await _showBottomSheet(context);
    if (mounted) {
      widget.blurNotifier?.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText;
    if (widget.selectionType == SelectionType.multiple) {
      if (widget.selectedValues == null || widget.selectedValues!.isEmpty) {
        displayText = 'Select';
      } else if (widget.selectedValues!.length == 1) {
        displayText = widget.selectedValues!.first;
      } else {
        displayText = '${widget.selectedValues!.length} selected';
      }
    } else {
      displayText = widget.selectedValue ?? 'Select';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: widget.label,
          style: AppTextStyles.inputLabel(
            context,
          ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ScaleTransition(
          scale: _bounceAnimation,
          child: InkWell(
            onTap: () => _handleTap(context),
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
                            ? Colors.white.withValues(alpha: 0.5)
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
        ),
      ],
    );
  }

  Future<void> _showBottomSheet(BuildContext context) {
    if (widget.selectionType == SelectionType.multiple) {
      return _showCheckboxBottomSheet(context);
    } else {
      return _showRadioBottomSheet(context);
    }
  }

  Future<void> _showCheckboxBottomSheet(BuildContext context) {
    final selected = List<String>.from(widget.selectedValues ?? []);

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _AnimatedBottomSheet(
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ColorPalette.secondary, ColorPalette.black],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Column(
                      children: [
                        AppText(
                          text: widget.label,
                          style: AppTextStyles.h1(context).copyWith(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        AppText(
                          text: widget.subtitle,
                          style: AppTextStyles.bodyLarge(context).copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
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
                      itemCount: widget.options.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      itemBuilder: (context, index) {
                        final option = widget.options[index];
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
                                    style: AppTextStyles.bodyLarge(context)
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
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
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 60,
                    ),
                    child: CustomElevatedButton(
                      onTap: () {
                        widget.onMultipleSelected?.call(selected);
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
      ),
    );
  }

  Future<void> _showRadioBottomSheet(BuildContext context) {
    String? selected = widget.selectedValue;

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _AnimatedBottomSheet(
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ColorPalette.secondary, ColorPalette.black],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Column(
                      children: [
                        AppText(
                          text: widget.label,
                          style: AppTextStyles.h1(context).copyWith(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        AppText(
                          text: widget.subtitle,
                          style: AppTextStyles.bodyLarge(context).copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
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
                      itemCount: widget.options.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 2,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      itemBuilder: (context, index) {
                        final option = widget.options[index];
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
                                SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Outer ring
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      // Middle dark ring
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black,
                                        ),
                                      ),
                                      // Inner fill toggles selected state
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: !isSelected
                                              ? Colors.black.withValues(
                                                  alpha: 0.9,
                                                )
                                              : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: AppText(
                                    text: option,
                                    style: AppTextStyles.bodyLarge(context)
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
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
                        if (selected != null && widget.onSelected != null) {
                          widget.onSelected!(selected!);
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
      ),
    );
  }
}

// Animated bottom sheet wrapper with smooth popup animation
class _AnimatedBottomSheet extends StatefulWidget {
  final Widget child;

  const _AnimatedBottomSheet({required this.child});

  @override
  State<_AnimatedBottomSheet> createState() => _AnimatedBottomSheetState();
}

class _AnimatedBottomSheetState extends State<_AnimatedBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Smooth slide up animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Fade in animation for backdrop
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
