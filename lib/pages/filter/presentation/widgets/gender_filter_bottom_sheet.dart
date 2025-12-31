import 'package:fennac_app/app/constants/app_enums.dart';
import 'package:fennac_app/app/constants/dummy_constants.dart';
import 'package:fennac_app/app/theme/app_colors.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/pages/filter/presentation/bloc/cubit/filter_cubit.dart';
import 'package:fennac_app/reusable_widgets/dropdown_field_widget.dart';
import 'package:fennac_app/reusable_widgets/gender_selection_widget.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenderFilterBottomSheet extends StatelessWidget {
  final FilterCubit filterCubit;
  final ValueNotifier<bool>? blurNotifier;

  const GenderFilterBottomSheet({
    super.key,
    required this.filterCubit,
    this.blurNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder(
      bloc: filterCubit,
      builder: (context, state) {
        return Container(
          height: height * 0.63,
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    text: "Adjust the type of members you'd like to meet.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h3(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  CustomSizedBox(height: 20),
                  AppText(
                    text: 'Select Gender',
                    style: AppTextStyles.inputLabel(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomSizedBox(height: 12),
                  GenderSelectionWidget(
                    genders: DummyConstants.genders,
                    selectedGender: filterCubit.selectedGender,
                    onGenderSelected: filterCubit.updateGender,
                  ),
                  CustomSizedBox(height: 24),
                  DropdownFieldWidget(
                    label: 'Your Sexual Orientation',
                    subtitle: 'Select',
                    selectedValues: filterCubit.selectedSexualOrientations,
                    options: DummyConstants.sexualOrientations,
                    selectionType: SelectionType.multiple,
                    onMultipleSelected: filterCubit.updateSexualOrientations,
                    blurNotifier: blurNotifier,
                  ),
                  CustomSizedBox(height: 20),
                  DropdownFieldWidget(
                    label: 'Your Pronouns',
                    subtitle: 'Select',
                    selectedValue: filterCubit.selectedPronoun,
                    options: DummyConstants.pronouns,
                    selectionType: SelectionType.single,
                    onSelected: filterCubit.updatePronoun,
                    blurNotifier: blurNotifier,
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    text: 'Done',
                    onTap: () => Navigator.of(context).pop(),
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
