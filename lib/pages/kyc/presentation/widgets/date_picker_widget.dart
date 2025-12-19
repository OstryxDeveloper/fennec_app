import 'dart:ui';
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

  @override
  void initState() {
    super.initState();
    final initialDate = widget.initialDate ?? DateTime(2003, 4, 16);
    _kycCubit.selectedDate = initialDate;
    _kycCubit.dayController = FixedExtentScrollController(
      initialItem: initialDate.day - 1,
    );
    _kycCubit.monthController = FixedExtentScrollController(
      initialItem: initialDate.month - 1,
    );
    _kycCubit.yearController = FixedExtentScrollController(
      initialItem: DateTime.now().year - initialDate.year,
    );
  }

  @override
  void dispose() {
    _kycCubit.dayController?.dispose();
    _kycCubit.monthController?.dispose();
    _kycCubit.yearController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_kycCubit.selectedDate == null ||
        _kycCubit.dayController == null ||
        _kycCubit.monthController == null ||
        _kycCubit.yearController == null) {
      return const SizedBox.shrink();
    }

    final selectedDate = _kycCubit.selectedDate!;
    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;
    final currentYear = DateTime.now().year;
    final years = List.generate(100, (i) => currentYear - i);

    final days = List.generate(daysInMonth, (i) => i + 1);

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: ColorPalette.secondry.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Day Column
                Expanded(
                  child: _buildPickerColumn(
                    controller: _kycCubit.dayController!,
                    items: days,
                    formatter: (value) => value.toString().padLeft(2, '0'),
                    onChanged: () =>
                        _kycCubit.updateDate(widget.onDateSelected),
                  ),
                ),
                // Month Column
                Expanded(
                  child: _buildPickerColumn(
                    controller: _kycCubit.monthController!,
                    items: _kycCubit.months,
                    formatter: (value) => value,
                    onChanged: () =>
                        _kycCubit.updateDate(widget.onDateSelected),
                  ),
                ),
                // Year Column
                Expanded(
                  child: _buildPickerColumn(
                    controller: _kycCubit.yearController!,
                    items: years,
                    formatter: (value) => value.toString(),
                    onChanged: () =>
                        _kycCubit.updateDate(widget.onDateSelected),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickerColumn<T>({
    required FixedExtentScrollController controller,
    required List<T> items,
    required String Function(T) formatter,
    required VoidCallback onChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 50,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (_) => onChanged(),
      perspective: 0.003,
      diameterRatio: 1.5,
      squeeze: 0.8,
      useMagnifier: true,
      magnification: 1.2,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final item = items[index % items.length];
          final isSelected = index == controller.selectedItem;

          return Center(
            child: Text(
              formatter(item),
              style: AppTextStyles.h2(context).copyWith(
                color: Colors.white,
                fontSize: isSelected ? 20 : 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 0.5,
              ),
            ),
          );
        },
        childCount: 10000, // Infinite scroll
      ),
    );
  }
}
