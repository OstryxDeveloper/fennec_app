import 'package:fennac_app/app/constants/dummy_constants.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_cubit.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatefulWidget {
  final String? selectedGender;
  final Function(String)? onGenderSelected;
  final List<String>? genders;

  const GenderSelectionWidget({
    super.key,
    this.selectedGender,
    this.onGenderSelected,
    this.genders,
  });

  @override
  State<GenderSelectionWidget> createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  final KycCubit _kycCubit = Di().sl<KycCubit>();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender =
        widget.selectedGender ??
        (_usesKycCubit ? _kycCubit.selectedGender : null);

    if (_usesKycCubit) {
      _kycCubit.selectedGender = _selectedGender;
    }
  }

  bool get _usesKycCubit => widget.genders == null;

  @override
  Widget build(BuildContext context) {
    final genderOptions = widget.genders ?? DummyConstants.genders;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.5,
      ),
      itemCount: genderOptions.length,
      itemBuilder: (context, index) {
        final gender = genderOptions[index];
        final isSelected = _selectedGender == gender;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _selectedGender = gender;
            });

            if (_usesKycCubit) {
              _kycCubit.selectedGender = gender;
            }
            widget.onGenderSelected?.call(gender);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorPalette.primary
                  : ColorPalette.secondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: AppText(
                text: gender,
                style: AppTextStyles.subHeading(context).copyWith(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
