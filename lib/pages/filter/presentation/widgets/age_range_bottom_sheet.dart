import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/pages/filter/presentation/bloc/cubit/filter_cubit.dart';
import 'package:fennac_app/pages/filter/presentation/widgets/dual_border_range_thumb_shape.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class AgeRangeBottomSheet extends StatefulWidget {
  final FilterCubit filterCubit;

  const AgeRangeBottomSheet({super.key, required this.filterCubit});

  @override
  State<AgeRangeBottomSheet> createState() => _AgeRangeBottomSheetState();
}

class _AgeRangeBottomSheetState extends State<AgeRangeBottomSheet> {
  late RangeValues _values;
  static const double _minAge = 18;
  static const double _maxAge = 60;

  @override
  void initState() {
    super.initState();
    _values = RangeValues(
      widget.filterCubit.selectedAgeMin.toDouble(),
      widget.filterCubit.selectedAgeMax.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.5;
    final primary = ColorPalette.primary;

    return Container(
      height: height,
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
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 32),
              AppText(
                text: "What's the preferred age group?",
                textAlign: TextAlign.center,
                style: AppTextStyles.h1(context).copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: _values.start.round().toString(),
                    style: AppTextStyles.h1Large(context).copyWith(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      width: 32,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.7),
                            Colors.white.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppText(
                    text: _values.end.round().toString(),
                    style: AppTextStyles.h1Large(context).copyWith(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  color: const Color(0x4016003F),
                  border: Border.all(color: const Color(0xFF16003F), width: 2),
                ),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(
                    // horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: ColorPalette.primary, width: 1.5),
                  ),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 60,
                      activeTrackColor: ColorPalette.primary.withValues(
                        alpha: 0.8,
                      ),
                      inactiveTrackColor: Colors.transparent,
                      overlayColor: primary.withValues(alpha: 0.16),
                      rangeThumbShape: DualBorderRangeThumbShape(
                        radius: 32,
                        strokeWidth: 3,
                        fillColor: primary,
                        outerBorderColor: Colors.black,
                        innerBorderColor: ColorPalette.primary,
                      ),
                      rangeTrackShape: const RectangularRangeSliderTrackShape(),
                    ),
                    child: RangeSlider(
                      values: _values,
                      min: _minAge,
                      max: _maxAge,
                      divisions: (_maxAge - _minAge).round(),
                      labels: RangeLabels(
                        _values.start.round().toString(),
                        _values.end.round().toString(),
                      ),
                      onChanged: (values) {
                        setState(() {
                          _values = RangeValues(
                            values.start.roundToDouble(),
                            values.end.roundToDouble(),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),

              CustomSizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: _minAge.toInt().toString(),
                      style: AppTextStyles.bodyLarge(
                        context,
                      ).copyWith(color: Colors.white.withValues(alpha: 0.6)),
                    ),
                    AppText(
                      text: _maxAge.toInt().toString(),
                      style: AppTextStyles.bodyLarge(
                        context,
                      ).copyWith(color: Colors.white.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomElevatedButton(
                text: 'Done',
                onTap: () {
                  widget.filterCubit.updateAgeRangeValues(
                    _values.start.round(),
                    _values.end.round(),
                  );
                  Navigator.of(context).pop();
                },
                width: double.infinity,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
