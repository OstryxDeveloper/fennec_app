import 'package:fennac_app/app/constants/dummy_constants.dart';
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

    selectedCategory = DummyConstants.categories.first;
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
