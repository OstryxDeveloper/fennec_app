import 'package:fennac_app/pages/kyc/presentation/bloc/state/kyc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KycCubit extends Cubit<KycState> {
  KycCubit() : super(KycInitial()) {
    shortBioController = TextEditingController();
    jobTitleController = TextEditingController();
    educationController = TextEditingController();
  }

  final genders = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];
  final sexualOrientations = [
    'Straight',
    'Gay',
    'Lesbian',
    'Bisexual',
    'Pansexual',
    'Asexual',
    'Queer',
    'Questioning',
    'Prefer not to say',
  ];
  final pronouns = [
    'He/Him',
    'She/Her',
    'They/Them',
    'He/They',
    'She/They',
    'Any pronouns',
    'Prefer not to say',
  ];
  final months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  final lifestyles = [
    'Adventure seeker 🏞️',
    'Coffee enthusiast ☕',
    'Foodie 🍽️',
    'Gym lover 💪',
    'Dog parent 🐶',
    'Early riser 🌅',
    'Nature explorer 🌲',
    'Gamer 🎮',
    'Cyclist 🚴‍♀️',
    'Movie buff 🎥',
  ];

  String? selectedGender;
  List<String> selectedSexualOrientations = [];
  String? selectedPronoun;
  List<String> selectedLifestyles = [];

  late final TextEditingController shortBioController;
  late final TextEditingController jobTitleController;
  late final TextEditingController educationController;

  DateTime? selectedDate;
  FixedExtentScrollController? dayController;
  FixedExtentScrollController? monthController;
  FixedExtentScrollController? yearController;

  void toggleLifestyle(String lifestyle) {
    emit(KycLoading());
    if (selectedLifestyles.contains(lifestyle)) {
      selectedLifestyles.remove(lifestyle);
    } else {
      selectedLifestyles.add(lifestyle);
    }
    emit(KycLoaded());
  }

  // In your Cubit
  void updateDate(Function(DateTime)? onDateSelected) {
    if (selectedDate == null ||
        dayController == null ||
        monthController == null ||
        yearController == null) {
      return;
    }

    emit(KycLoading());
    final daysInMonth = DateTime(
      selectedDate!.year,
      selectedDate!.month + 1,
      0,
    ).day;
    final day = (dayController!.selectedItem % daysInMonth) + 1;
    final month = (monthController!.selectedItem % 12) + 1;
    final year = DateTime.now().year - (yearController!.selectedItem % 100);

    selectedDate = DateTime(year, month, day);
    onDateSelected?.call(selectedDate!);
    emit(KycLoaded());
  }

  @override
  Future<void> close() {
    shortBioController.dispose();
    jobTitleController.dispose();
    educationController.dispose();
    dayController?.dispose();
    monthController?.dispose();
    yearController?.dispose();
    return super.close();
  }
}
