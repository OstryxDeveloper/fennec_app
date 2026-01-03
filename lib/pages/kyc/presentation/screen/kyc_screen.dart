import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/constants/app_enums.dart';
import 'package:fennac_app/app/constants/dummy_constants.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/continue_button.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/date_picker_widget.dart';
import 'package:fennac_app/reusable_widgets/dropdown_field_widget.dart';
import 'package:fennac_app/reusable_widgets/gender_selection_widget.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final KycCubit _kycCubit = Di().sl<KycCubit>();
  final ValueNotifier<bool> _isBlurNotifier = ValueNotifier(false);

  @override
  void dispose() {
    _isBlurNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: MovableBackground(
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: BlocBuilder(
                  bloc: _kycCubit,
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSizedBox(height: 24),
                          // Greeting
                          AppText(
                            text: 'Hi, John!',
                            style: AppTextStyles.h1(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomSizedBox(height: 16),
                          AppText(
                            text: "Let's start with the basics",
                            style: AppTextStyles.h4(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          CustomSizedBox(height: 32),

                          // Date of Birth
                          AppText(
                            text: 'Select Your Date of Birth',
                            style: AppTextStyles.inputLabel(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomSizedBox(height: 10),
                          DatePickerWidget(
                            initialDate: _kycCubit.selectedDate,
                            onDateSelected: (date) {
                              _kycCubit.selectedDate = date;
                            },
                          ),
                          CustomSizedBox(height: 32),

                          // Gender Selection
                          AppText(
                            text: 'Select Gender',
                            style: AppTextStyles.inputLabel(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomSizedBox(height: 10),
                          GenderSelectionWidget(
                            selectedGender: _kycCubit.selectedGender,
                            onGenderSelected: (gender) {
                              _kycCubit.selectGender(gender);
                            },
                          ),
                          CustomSizedBox(height: 32),

                          // Sexual Orientation
                          DropdownFieldWidget(
                            label: 'Your Sexual Orientation',
                            subtitle: 'Choose all that describe you best.',
                            selectedValues:
                                _kycCubit.selectedSexualOrientations,
                            options: DummyConstants.sexualOrientations,
                            selectionType: SelectionType.multiple,
                            onMultipleSelected: (values) {
                              _kycCubit.selectSexualOrientations(values);
                            },
                            blurNotifier: _isBlurNotifier,
                          ),
                          CustomSizedBox(height: 20),

                          // Pronouns
                          DropdownFieldWidget(
                            label: 'Your Pronouns',
                            subtitle: 'Select what feels right for you.',
                            selectedValue: _kycCubit.selectedPronoun,
                            options: DummyConstants.pronouns,
                            selectionType: SelectionType.single,
                            onSelected: (value) {
                              _kycCubit.selectPronouns(value);
                            },
                            blurNotifier: _isBlurNotifier,
                          ),
                          CustomSizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isBlurNotifier,
              builder: (context, isBlurred, child) {
                return IgnorePointer(
                  ignoring: !isBlurred,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isBlurred ? 1 : 0.0,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ContinueButton(
          onTap: () {
            AutoRouter.of(context).push(const KycDetailsRoute());
          },
          text: 'Continue',
        ),
      ),
    );
  }
}
