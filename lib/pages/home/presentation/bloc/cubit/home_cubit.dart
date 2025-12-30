import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/home/data/models/group_model.dart';
import 'package:fennac_app/pages/home/data/models/profile_model.dart';
import 'package:fennac_app/pages/home/presentation/bloc/state/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // ========== BOOLEAN VARIABLES ==========
  final bool isGroupAudioAvailable = true;

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

  // ========== COLLECTION VARIABLES ==========
  List<String> groupImages = [
    Assets.dummy.groupNight.path,
    Assets.dummy.groupFire.path,
    Assets.dummy.groupSunset.path,
    Assets.dummy.groupGlasses.path,
    Assets.dummy.groupSelfieBeach.path,
    Assets.dummy.groupSwiming.path,
  ];

  // Avatar paths matching the cover images
  final List<String> avatarPaths = [
    Assets.dummy.a1.path,
    Assets.dummy.b1.path,
    Assets.dummy.c1.path,
    Assets.dummy.d1.path,
    Assets.dummy.e1.path,
  ];

  // group data
  final List<GroupModel> groups = [
    GroupModel(
      id: '1',
      name: 'Weekend Warriors',
      coverImage: Assets.dummy.groupNight.path,
      groupTag: "#WeekendVibes",
      description:
          'A group for those who love to make the most of their weekends.',
    ),
    GroupModel(
      id: '2',
      name: 'City Explorers',
      groupTag: "#CityLife",
      coverImage: Assets.dummy.groupFire.path,
      description:
          'Discover the hidden gems and vibrant life of the city together.',
    ),
    GroupModel(
      id: '3',
      name: 'Adventure Squad',
      groupTag: "#AdventureTime",
      coverImage: Assets.dummy.groupSunset.path,
      description: 'For the thrill-seekers and outdoor enthusiasts.',
    ),
    GroupModel(
      id: '4',
      name: 'Foodie Friends',
      groupTag: "#Foodies",
      coverImage: Assets.dummy.groupGlasses.path,
      description:
          'Sharing a passion for delicious food and culinary adventures.',
    ),
    GroupModel(
      id: '5',
      name: 'Tech Enthusiasts',
      groupTag: "#TechTalk",
      coverImage: Assets.dummy.groupSelfieBeach.path,
      description: 'Connecting over the latest in technology and innovation.',
    ),
    GroupModel(
      id: '6',
      name: 'Creative Crew',
      groupTag: "#CreativeMinds",
      coverImage: Assets.dummy.groupSwiming.path,
      description:
          'A space for artists, writers, and creators to collaborate and inspire.',
    ),
  ];

  // ========== NUMERIC VARIABLES ==========
  int? selectedProfileIndex;
  int isDeclined = 0;

  int selectedGroupIndex = 0;
  // ========== CUSTOM OBJECTS ==========
  List<ProfileModel> get selectedProfiles => groups[selectedGroupIndex].members;
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
