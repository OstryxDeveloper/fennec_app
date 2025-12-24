import 'package:fennac_app/pages/filter/presentation/bloc/state/filter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());

  // Filter state variables
  String selectedCategory = 'Travel & Adventure';
  String selectedGender = 'All genders';
  String selectedGroupSize = 'Max 3 people';
  String selectedDistance = 'Max 15 miles';
  String selectedAgeRange = '25 - 35 years old';

  // Available options
  final List<String> categories = [
    'Travel & Adventure',
    'Sports',
    'Music & Arts',
    'Outdoor',
    'Food & Dining',
    'Gaming',
    'Tech & Innovation',
    'Photography',
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
    emit(FilterLoaded());
  }

  void updateDistance(String distance) {
    emit(FilterLoading());
    selectedDistance = distance;
    emit(FilterLoaded());
  }

  void updateAgeRange(String ageRange) {
    selectedAgeRange = ageRange;
    emit(FilterLoaded());
  }

  // Reset all filters
  void resetFilters() {
    emit(FilterLoading());

    selectedCategory = 'Travel & Adventure';
    selectedGender = 'All genders';
    selectedGroupSize = 'Max 3 people';
    selectedDistance = 'Max 15 miles';
    selectedAgeRange = '25 - 35 years old';
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
