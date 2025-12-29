import 'package:fennac_app/generated/assets.gen.dart';
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

  // Profile data
  final List<ProfileModel> profiles = [
    ProfileModel(
      id: '1',
      name: 'Brenda Taylor',
      firstName: 'Brenda',
      age: 23,
      bio:
          'Design by day, discover new coffee shops by night. Always planning the next weekend escape.',
      coverImage: Assets.dummy.a1.path,
      gender: 'Female',
      orientation: 'Straight',
      pronouns: 'She/Her',
      location: 'Austin, TX',
      distance: '2 miles',
      education: 'Stanford University',
      profession: 'Software Engineer',
      promptTitle: 'A perfect weekend for me looks like...',
      promptAnswer:
          'A morning hike, brunch with friends, and a movie marathon.',
      lifestyle: [
        'Adventure seeker 🏞️',
        'Nature explorer 🌲',
        'Foodie 🍽️',
        'Dog parent 🐶',
        'Early riser 🌅',
      ],
      interests: [
        'Hiking 🧗',
        'Coffee culture ☕',
        'Design 🎨',
        'Travel ✈️',
        'Photography 📸',
      ],
      images: [
        Assets.dummy.a1.path,
        Assets.dummy.a2.path,
        Assets.dummy.a3.path,
        Assets.dummy.a4.path,
        Assets.dummy.a5.path,
        Assets.dummy.a6.path,
      ],
    ),
    ProfileModel(
      id: '2',
      name: 'Jack Wilson',
      firstName: 'Jack',
      age: 25,
      bio:
          'Adventure seeker and coffee enthusiast. Living for the next road trip.',
      coverImage: Assets.dummy.b1.path,
      gender: 'Male',
      orientation: 'Straight',
      pronouns: 'He/Him',
      location: 'Austin, TX',
      distance: '3 miles',
      education: 'MIT',
      profession: 'Product Designer',
      promptTitle: 'My ideal road trip would include...',
      promptAnswer:
          'Good company, great music, and discovering hidden gems off the beaten path.',
      interests: [
        'Road trips 🚗',
        'Coffee ☕',
        'Product design 🏗️',
        'Outdoor adventures 🏔️',
        'Music 🎵',
      ],
      images: [
        Assets.dummy.b1.path,
        Assets.dummy.b2.path,
        Assets.dummy.b3.path,
        Assets.dummy.b4.path,
        Assets.dummy.b5.path,
        Assets.dummy.b6.path,
      ],
    ),
    ProfileModel(
      id: '3',
      name: 'Nancy Chen',
      firstName: 'Nancy',
      age: 24,
      bio:
          'Foodie by day, concert goer by night. Love exploring the city with friends.',
      coverImage: Assets.dummy.c1.path,
      gender: 'Female',
      orientation: 'Straight',
      pronouns: 'She/Her',
      location: 'Austin, TX',
      distance: '1 mile',
      education: 'UC Berkeley',
      profession: 'Marketing Manager',
      promptTitle: 'My favorite dining experience would be...',
      promptAnswer:
          'Trying a new restaurant with friends, great food, and even better conversation.',
      interests: [
        'Foodie 🍽️',
        'Live music 🎤',
        'Urban exploration 🏙️',
        'Cooking 👨‍🍳',
        'Social gatherings 🎉',
      ],
      images: [
        Assets.dummy.c1.path,
        Assets.dummy.c2.path,
        Assets.dummy.c3.path,
        Assets.dummy.c4.path,
        Assets.dummy.c5.path,
        Assets.dummy.c6.path,
      ],
    ),
    ProfileModel(
      id: '4',
      name: 'Jeff Martinez',
      firstName: 'Jeff',
      age: 26,
      bio:
          'Tech enthusiast and outdoor adventurer. Always down for spontaneous plans.',
      coverImage: Assets.dummy.d1.path,
      gender: 'Male',
      orientation: 'Straight',
      pronouns: 'He/Him',
      location: 'Austin, TX',
      distance: '4 miles',
      education: 'University of Texas',
      profession: 'Data Scientist',
      promptTitle: 'My perfect adventure would involve...',
      promptAnswer:
          'Hiking to breathtaking views, camping under the stars, and genuine connections.',
      interests: [
        'Technology 💻',
        'Hiking 🧗',
        'Data science 📊',
        'Camping 🏕️',
        'Spontaneous fun 🎲',
      ],
      images: [
        Assets.dummy.d1.path,
        Assets.dummy.d2.path,
        Assets.dummy.d3.path,
        Assets.dummy.d4.path,
        Assets.dummy.d5.path,
        Assets.dummy.d6.path,
      ],
    ),
    ProfileModel(
      id: '5',
      name: 'Anna Rodriguez',
      firstName: 'Anna',
      age: 22,
      bio: 'Artist and dreamer. Love rooftop sunsets and good vibes.',
      coverImage: Assets.dummy.e1.path,
      gender: 'Female',
      orientation: 'Straight',
      pronouns: 'She/Her',
      location: 'Austin, TX',
      distance: '5 miles',
      education: 'NYU',
      profession: 'Graphic Designer',
      promptTitle: 'The best creative collaboration for me would be...',
      promptAnswer:
          'Working with passionate people who share a vision and aren\'t afraid to dream big.',
      interests: [
        'Art 🎨',
        'Design 🖌️',
        'Sunsets 🌅',
        'Creative projects 💡',
        'Travel 🌍',
      ],
      images: [
        Assets.dummy.e1.path,
        Assets.dummy.e2.path,
        Assets.dummy.e3.path,
        Assets.dummy.e4.path,
        Assets.dummy.e5.path,
        Assets.dummy.e6.path,
      ],
    ),
  ];

  // ========== NUMERIC VARIABLES ==========
  int? selectedIndex;
  int isDeclined = 0;

  // ========== CUSTOM OBJECTS ==========
  ProfileModel? selectedProfile;

  // ========== METHODS ==========
  void selectGroupIndex(int? index) {
    emit(HomeLoading());
    selectedIndex = index;

    // Update selected profile based on index
    if (index != null && index < profiles.length) {
      selectedProfile = profiles[index];
    } else {
      selectedProfile = null;
    }

    emit(HomeLoaded());
  }

  void selectProfileById(String? id) {
    emit(HomeLoading());
    if (id == null) {
      selectedProfile = null;
      selectedIndex = null;
      emit(HomeLoaded());
      return;
    }

    final idx = profiles.indexWhere((p) => p.id == id);
    if (idx != -1) {
      selectedIndex = idx;
      selectedProfile = profiles[idx];
    } else {
      selectedIndex = null;
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
      return profiles.firstWhere((profile) => profile.id == id);
    } catch (e) {
      return null;
    }
  }
}
