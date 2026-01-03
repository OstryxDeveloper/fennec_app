import 'dart:ui';
import 'package:fennac_app/app/constants/dummy_constants.dart';
import 'package:fennac_app/app/constants/media_query_constants.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_cubit.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;

  const DatePickerWidget({super.key, this.initialDate, this.onDateSelected});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  final KycCubit _kycCubit = Di().sl<KycCubit>();
  FixedExtentScrollController? _dayController;
  FixedExtentScrollController? _monthController;
  FixedExtentScrollController? _yearController;
  DateTime? _currentDate;
  List<String> _months = [];
  int _previousDaysInMonth = 31;

  @override
  void initState() {
    super.initState();
    _initializeWidget();
  }

  void _initializeWidget() {
    _currentDate = widget.initialDate ?? DateTime(2003, 4, 16);
    _kycCubit.selectedDate = _currentDate;
    _months = DummyConstants.months;
    _previousDaysInMonth = DateTime(
      _currentDate!.year,
      _currentDate!.month + 1,
      0,
    ).day;
    _initializeControllers();
  }

  void _initializeControllers() {
    if (_currentDate == null) return;

    // Dispose existing controllers if they exist
    _dayController?.dispose();
    _monthController?.dispose();
    _yearController?.dispose();

    // Create new controllers
    _dayController = FixedExtentScrollController(
      initialItem: _currentDate!.day - 1,
    );
    _monthController = FixedExtentScrollController(
      initialItem: _currentDate!.month - 1,
    );
    _yearController = FixedExtentScrollController(
      initialItem: DateTime.now().year - _currentDate!.year,
    );
  }

  @override
  void didUpdateWidget(DatePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      _currentDate = widget.initialDate ?? DateTime(2003, 4, 16);
      _kycCubit.selectedDate = _currentDate;
      _previousDaysInMonth = DateTime(
        _currentDate!.year,
        _currentDate!.month + 1,
        0,
      ).day;
      _initializeControllers();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _dayController?.dispose();
    _monthController?.dispose();
    _yearController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if everything is initialized
    if (_currentDate == null ||
        _dayController == null ||
        _monthController == null ||
        _yearController == null ||
        _months.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentYear = DateTime.now().year;
    final years = List.generate(100, (i) => currentYear - i);

    return Container(
      height: getWidth(context) > 500 ? 250 : 200,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: ColorPalette.secondary.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    // Day Column
                    Expanded(
                      child: _buildPickerColumn(
                        controller: _dayController!,
                        maxItems: _previousDaysInMonth,
                        formatter: (value) => value.toString().padLeft(2, '0'),
                        onChanged: () => _updateDate(),
                      ),
                    ),
                    // Month Column
                    Expanded(
                      child: _buildPickerColumn(
                        controller: _monthController!,
                        items: _months,
                        formatter: (value) => value.toString().toUpperCase(),
                        onChanged: () => _updateDate(),
                      ),
                    ),
                    // Year Column
                    Expanded(
                      child: _buildPickerColumn(
                        controller: _yearController!,
                        items: years,
                        formatter: (value) => value.toString(),
                        onChanged: () => _updateDate(),
                      ),
                    ),
                  ],
                ),
                // Gradient blur overlays - top
                _buildGradientBlur(isTop: true),
                // Gradient blur overlays - bottom
                _buildGradientBlur(isTop: false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateDate() {
    if (_dayController == null ||
        _monthController == null ||
        _yearController == null ||
        _currentDate == null) {
      return;
    }

    final day = _dayController!.selectedItem + 1;
    final month = _monthController!.selectedItem + 1;
    final year = DateTime.now().year - _yearController!.selectedItem;

    try {
      // Calculate days in the new month/year
      final daysInMonth = DateTime(year, month + 1, 0).day;

      // Adjust day if it exceeds the days in the new month
      final validDay = day > daysInMonth ? daysInMonth : day;

      final newDate = DateTime(year, month, validDay);
      _currentDate = newDate;
      _kycCubit.selectedDate = newDate;

      // If the day was adjusted, smoothly animate to the valid day
      if (day > daysInMonth &&
          _dayController!.selectedItem != daysInMonth - 1) {
        _dayController!.animateToItem(
          daysInMonth - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }

      if (widget.onDateSelected != null) {
        widget.onDateSelected!(newDate);
      }

      // Update the UI if the number of days in the month changed
      if (daysInMonth != _previousDaysInMonth) {
        _previousDaysInMonth = daysInMonth;
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      debugPrint('Invalid date selected: $year-$month-$day');
    }
  }

  Widget _buildGradientBlur({required bool isTop}) {
    return Positioned(
      top: isTop ? 0 : null,
      bottom: isTop ? null : 0,
      left: 0,
      right: 0,
      height: getWidth(context) > 500 ? 90 : 70,
      child: IgnorePointer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            int steps = 60;
            return Stack(
              children: List.generate(steps, (index) {
                double fraction = index / (steps);
                // Both top and bottom now use the same pattern
                double effectiveFraction = 1 - fraction;
                double sigmaY = 0.5 + effectiveFraction * 10;
                double sigmaX = 0.3 + effectiveFraction * 6;

                return Positioned(
                  top: isTop ? (constraints.maxHeight * fraction) : null,
                  bottom: isTop ? null : (constraints.maxHeight * fraction),
                  left: 0,
                  right: 0,
                  height: constraints.maxHeight / steps,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPickerColumn<T>({
    required FixedExtentScrollController controller,
    List<T>? items,
    int? maxItems,
    required String Function(dynamic) formatter,
    required VoidCallback onChanged,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: 55,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (_) => onChanged(),
          perspective: 0.002,
          diameterRatio: 2,
          squeeze: 1.25,
          useMagnifier: false,
          magnification: 1.0,
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              final dynamic item;

              if (items != null) {
                item = items[index % items.length];
              } else if (maxItems != null) {
                final actualIndex = index % maxItems;
                item = actualIndex + 1;
              } else {
                return const SizedBox.shrink();
              }

              // Simple distance calculation that works for all columns
              final selectedItem = controller.selectedItem;
              final distance = (index - selectedItem).abs();
              final opacity = distance == 0 ? 1.0 : (distance == 1 ? 0.3 : 0.2);

              return Center(
                child: Text(
                  formatter(item),
                  style: AppTextStyles.h2(context).copyWith(
                    color: Colors.white.withValues(alpha: opacity),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    height: 1.0,
                  ),
                ),
              );
            },
            childCount: 10000,
          ),
        );
      },
    );
  }
}
