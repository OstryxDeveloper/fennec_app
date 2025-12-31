import 'package:fennac_app/app/constants/dummy_constants.dart';
import 'package:fennac_app/pages/home/data/models/profile_model.dart';
import 'package:fennac_app/pages/home/presentation/bloc/state/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // ========== BOOLEAN VARIABLES ==========
  final bool isGroupAudioAvailable = true;

  final cardSwiperController = CardSwiperController();

  double xAxisCardValue = 0;

  // update values
  void updateCardPosition(double x) {
    emit(HomeLoading());
    if (x != 0) {
      xAxisCardValue = x;
    }
    emit(HomeLoaded());
  }

  // is disliking
  bool isDisliking() {
    return xAxisCardValue < -100;
  }

  // is liking
  bool isLiking() {
    return xAxisCardValue > 100;
  }

  // is value reset
  bool isValueReset() {
    return xAxisCardValue < 100 && xAxisCardValue > -100;
  }

  // ========== NUMERIC VARIABLES ==========
  int? selectedProfileIndex;
  int isDeclined = 0;

  int selectedGroupIndex = 0;
  // ========== CUSTOM OBJECTS ==========
  List<ProfileModel> get selectedProfiles =>
      DummyConstants.groups[selectedGroupIndex].members;
  ProfileModel? selectedProfile;

  // ========== METHODS ==========
  void selectProfileIndex(int? index) {
    emit(HomeLoading());
    selectedProfileIndex = index;
    // Update selected profile based on index
    if (index != null && index < selectedProfiles.length) {
      selectedProfile = selectedProfiles[index];
    } else {
      selectedProfile = null;
    }
    emit(HomeLoaded());
  }

  void selectGroupIndex(int? index) {
    emit(HomeLoading());
    selectedGroupIndex = index ?? 0;
    emit(HomeLoaded());
  }

  void selectProfileById(String? id) {
    emit(HomeLoading());
    if (id == null) {
      selectedProfile = null;
      selectedProfileIndex = null;
      emit(HomeLoaded());
      return;
    }

    final idx = selectedProfiles.indexWhere((p) => p.id == id);
    if (idx != -1) {
      selectedProfileIndex = idx;
      selectedProfile = selectedProfiles[idx];
    } else {
      selectedProfileIndex = null;
      selectedProfile = null;
    }
    emit(HomeLoaded());
  }

  void selectDeclined(int value) {
    emit(HomeLoading());
    isDeclined = value;
    emit(HomeLoaded());
  }

  ProfileModel? getProfileById(String id) {
    try {
      return selectedProfiles.firstWhere((profile) => profile.id == id);
    } catch (e) {
      return null;
    }
  }
}
