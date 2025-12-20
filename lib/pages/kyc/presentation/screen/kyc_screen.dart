import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/constants/media_query_constants.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/core/di_container.dart';
import 'package:fennac_app/pages/kyc/presentation/bloc/cubit/kyc_cubit.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/date_picker_widget.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/dropdown_field_widget.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/gender_selection_widget.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: MovableBackground(
        child: SafeArea(
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
                      CustomSizedBox(height: 20),
                      // Greeting
                      AppText(
                        text: 'Hi, John!',
                        style: AppTextStyles.h1(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      CustomSizedBox(height: 8),
                      AppText(
                        text: "Let's start with the basics",
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      CustomSizedBox(height: getWidth(context) > 500 ? 30 : 16),

                      // Date of Birth
                      AppText(
                        text: 'Select Your Date of Birth',
                        style: AppTextStyles.bodyLarge(context).copyWith(
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
                      CustomSizedBox(height: 22),

                      // Gender Selection
                      AppText(
                        text: 'Select Gender',
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CustomSizedBox(height: 10),
                      GenderSelectionWidget(
                        selectedGender: _kycCubit.selectedGender,
                        onGenderSelected: (gender) {
                          _kycCubit.selectGender(gender);
                        },
                      ),
                      CustomSizedBox(height: 22),

                      // Sexual Orientation
                      DropdownFieldWidget(
                        label: 'Your Sexual Orientation',
                        subtitle: 'Choose all that describe you best.',
                        selectedValues: _kycCubit.selectedSexualOrientations,
                        options: _kycCubit.sexualOrientations,
                        selectionType: SelectionType.multiple,
                        onMultipleSelected: (values) {
                          _kycCubit.selectSexualOrientations(values);
                        },
                      ),
                      CustomSizedBox(height: 20),

                      // Pronouns
                      DropdownFieldWidget(
                        label: 'Your Pronouns',
                        subtitle: 'Select what feels right for you.',
                        selectedValue: _kycCubit.selectedPronoun,
                        options: _kycCubit.pronouns,
                        selectionType: SelectionType.single,
                        onSelected: (value) {
                          _kycCubit.selectPronouns(value);
                        },
                      ),
                      CustomSizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: CustomElevatedButton(
          onTap: () {
            AutoRouter.of(context).push(const KycDetailsRoute());
          },
          text: 'Continue',
          width: double.infinity,
        ),
      ),
    );
  }
}
