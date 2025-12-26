import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_cubit.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatefulWidget {
  final String? selectedGender;
  final Function(String)? onGenderSelected;

  const GenderSelectionWidget({
    super.key,
    this.selectedGender,
    this.onGenderSelected,
  });

  @override
  State<GenderSelectionWidget> createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  final KycCubit _kycCubit = Di().sl<KycCubit>();

  @override
  void initState() {
    super.initState();
    _kycCubit.selectedGender = widget.selectedGender;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.5,
      ),
      itemCount: _kycCubit.genders.length,
      itemBuilder: (context, index) {
        final gender = _kycCubit.genders[index];
        final isSelected = _kycCubit.selectedGender == gender;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _kycCubit.selectedGender = gender;
            widget.onGenderSelected?.call(gender);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorPalette.primary
                  : ColorPalette.secondry.withValues(alpha: 0.3),
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
