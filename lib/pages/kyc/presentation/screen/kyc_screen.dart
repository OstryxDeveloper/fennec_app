import 'package:auto_route/auto_route.dart';
import 'package:fennac_app/app/theme/text_styles.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/date_picker_widget.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/dropdown_field_widget.dart';
import 'package:fennac_app/pages/kyc/presentation/widgets/gender_selection_widget.dart';
import 'package:fennac_app/routes/routes_imports.gr.dart';
import 'package:fennac_app/widgets/custom_elevated_button.dart';
import 'package:fennac_app/widgets/custom_sized_box.dart';
import 'package:fennac_app/widgets/custom_text.dart';
import 'package:fennac_app/widgets/movable_background.dart';
import 'package:flutter/material.dart';

@RoutePage()
class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  DateTime? _selectedDate;
  String? _selectedGender;
  List<String> _selectedSexualOrientations = [];
  String? _selectedPronouns;

  final List<String> _sexualOrientations = [
    'Straight',
    'Gay',
    'Lesbian',
    'Bisexual',
    'Pansexual',
    'Asexual',
    'Queer',
    'Questioning',
    'Other',
  ];

  final List<String> _pronouns = [
    'He/Him',
    'She/Her',
    'They/Them',
    'He/They',
    'She/They',
    'Any pronouns',
    'Prefer not to say',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      body: MovableBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
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
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                  CustomSizedBox(height: 40),

                  // Date of Birth
                  AppText(
                    text: 'Select Your Date of Birth',
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomSizedBox(height: 12),
                  DatePickerWidget(
                    initialDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  CustomSizedBox(height: 32),

                  // Gender Selection
                  AppText(
                    text: 'Select Gender',
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomSizedBox(height: 12),
                  GenderSelectionWidget(
                    selectedGender: _selectedGender,
                    onGenderSelected: (gender) {
                      setState(() {
                        _selectedGender = gender;
                      });
                    },
                  ),
                  CustomSizedBox(height: 32),

                  // Sexual Orientation
                  DropdownFieldWidget(
                    label: 'Your Sexual Orientation',
                    subtitle: 'Choose all that describe you best.',
                    selectedValues: _selectedSexualOrientations,
                    options: _sexualOrientations,
                    selectionType: SelectionType.multiple,
                    onMultipleSelected: (values) {
                      setState(() {
                        _selectedSexualOrientations = values;
                      });
                    },
                  ),
                  CustomSizedBox(height: 24),

                  // Pronouns
                  DropdownFieldWidget(
                    label: 'Your Pronouns',
                    subtitle: 'Select what feels right for you.',
                    selectedValue: _selectedPronouns,
                    options: _pronouns,
                    selectionType: SelectionType.single,
                    onSelected: (value) {
                      setState(() {
                        _selectedPronouns = value;
                      });
                    },
                  ),
                  CustomSizedBox(height: 40),

                  // Continue Button
                  CustomElevatedButton(
                    onTap: () {
                      AutoRouter.of(context).push(const KycDetailsRoute());
                    },
                    text: 'Continue',
                    width: double.infinity,
                  ),
                  CustomSizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
