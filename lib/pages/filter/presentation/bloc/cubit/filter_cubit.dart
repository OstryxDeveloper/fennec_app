import 'package:fennac_app/app/theme/app_emojis.dart';
import 'package:fennac_app/pages/filter/presentation/bloc/state/filter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());

  // Filter state variables
  String selectedCategory = '${AppEmojis.backpack} Travel & Adventure';
  String selectedGender = 'All genders';
  String selectedGroupSize = 'Max 3 people';
  int selectedGroupSizeValue = 3;
  String selectedDistance = 'Max 15 miles';
  String selectedAgeRange = '25 - 35 years old';
  int selectedAgeMin = 25;
  int selectedAgeMax = 35;
  List<String> selectedSexualOrientations = [];
  String? selectedPronoun;

  // Available options
  final List<String> categories = [
    '${AppEmojis.backpack} Travel & Adventure',
    '${AppEmojis.musicalNote} Music & Arts',
    '${AppEmojis.hamburger} Food & Drink',
    '${AppEmojis.yoga} Wellness & Lifestyle',
    '${AppEmojis.football} Sports & Outdoors',
    '${AppEmojis.partyPopper} Events & Parties',
    '${AppEmojis.gameController} Tech & Gaming',
    '${AppEmojis.books} Study & Learning',
  ];

  final List<String> genders = ['All genders', 'Male', 'Female', 'Non-binary'];

  final List<String> groupSizes = [
    'Max 3 people',
    'Max 5 people',
    'Max 10 people',
    'Any size',
  ];

  final List<String> distances = [
    'Max 5 miles',
    'Max 10 miles',
    'Max 15 miles',
    'Max 25 miles',
    'Any distance',
  ];

  final List<String> ageRanges = [
    '18 - 25 years old',
    '25 - 35 years old',
    '35 - 45 years old',
    '45 - 55 years old',
    '55+ years old',
  ];

  final List<String> sexualOrientations = [
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

  final List<String> pronouns = [
    'He/Him',
    'She/Her',
    'They/Them',
    'He/They',
    'She/They',
    'Any pronouns',
    'Prefer not to say',
  ];

  // Filter update methods
  void updateCategory(String category) {
    emit(FilterLoading());

    selectedCategory = category;
    emit(FilterLoaded());
  }

  void updateGender(String gender) {
    emit(FilterLoading());

    selectedGender = gender;
    emit(FilterLoaded());
  }

  void updateGroupSize(String size) {
    emit(FilterLoading());

    selectedGroupSize = size;
    final parsed = int.tryParse(size.replaceAll(RegExp(r'[^0-9]'), ''));
    if (parsed != null) {
      selectedGroupSizeValue = parsed;
    }
    emit(FilterLoaded());
  }

  void updateGroupSizeValue(int value) {
    emit(FilterLoading());
    selectedGroupSizeValue = value;
    selectedGroupSize = 'Max $value people';
    emit(FilterLoaded());
  }

  void updateDistance(String distance) {
    emit(FilterLoading());
    selectedDistance = distance;
    emit(FilterLoaded());
  }

  void updateAgeRange(String ageRange) {
    emit(FilterLoading());
    selectedAgeRange = ageRange;
    emit(FilterLoaded());
  }

  void updateAgeRangeValues(int minAge, int maxAge) {
    emit(FilterLoading());
    selectedAgeMin = minAge;
    selectedAgeMax = maxAge;
    selectedAgeRange = '$minAge - $maxAge years old';
    emit(FilterLoaded());
  }

  void updateSexualOrientations(List<String> orientations) {
    emit(FilterLoading());
    selectedSexualOrientations = List.from(orientations);
    emit(FilterLoaded());
  }

  void updatePronoun(String pronoun) {
    emit(FilterLoading());
    selectedPronoun = pronoun;
    emit(FilterLoaded());
  }

  // Reset all filters
  void resetFilters() {
    emit(FilterLoading());

    selectedCategory = categories.first;
    selectedGender = 'All genders';
    selectedGroupSize = 'Max 3 people';
    selectedGroupSizeValue = 3;
    selectedDistance = 'Max 15 miles';
    selectedAgeMin = 25;
    selectedAgeMax = 35;
    selectedAgeRange = '25 - 35 years old';
    selectedSexualOrientations = [];
    selectedPronoun = null;
    emit(FilterLoaded());
  }

  // Apply filters
  void applyFilters() {
    emit(FilterLoading());
    // Simulate API call or processing
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      emit(FilterLoaded());
    });
  }
}
