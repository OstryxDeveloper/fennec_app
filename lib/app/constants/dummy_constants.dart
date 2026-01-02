import 'package:fennac_app/app/theme/app_emojis.dart';
import 'package:fennac_app/generated/assets.gen.dart';
import 'package:fennac_app/pages/home/data/models/group_model.dart';

class DummyConstants {
  // Available options
  static final List<String> categories = [
    '${AppEmojis.backpack} Travel & Adventure',
    '${AppEmojis.musicalNote} Music & Arts',
    '${AppEmojis.hamburger} Food & Drink',
    '${AppEmojis.yoga} Wellness & Lifestyle',
    '${AppEmojis.football} Sports & Outdoors',
    '${AppEmojis.partyPopper} Events & Parties',
    '${AppEmojis.gameController} Tech & Gaming',
    '${AppEmojis.books} Study & Learning',
  ];

  static final List<String> genders = [
    'All genders',
    'Male',
    'Female',
    'Non-binary',
  ];

  static final List<String> groupSizes = [
    'Max 3 people',
    'Max 5 people',
    'Max 10 people',
    'Any size',
  ];

  static final List<String> distances = [
    'Max 5 miles',
    'Max 10 miles',
    'Max 15 miles',
    'Max 25 miles',
    'Any distance',
  ];

  static final List<String> ageRanges = [
    '18 - 25 years old',
    '25 - 35 years old',
    '35 - 45 years old',
    '45 - 55 years old',
    '55+ years old',
  ];

  static final List<String> sexualOrientations = [
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

  static final List<String> pronouns = [
    'He/Him',
    'She/Her',
    'They/Them',
    'He/They',
    'She/They',
    'Any pronouns',
    'Prefer not to say',
  ];

  static final List<String> months = [
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

  static final List<String> lifestyles = [
    'Adventure seeker ${AppEmojis.mountain}',
    'Coffee enthusiast ${AppEmojis.coffee}',
    'Foodie ${AppEmojis.plateWithCutlery}',
    'Gym lover ${AppEmojis.flexedBiceps}',
    'Dog parent ${AppEmojis.dogFace}',
    'Early riser ${AppEmojis.sunrise}',
    'Nature explorer ${AppEmojis.evergreenTree}',
    'Gamer ${AppEmojis.gameController}',
    'Cyclist ${AppEmojis.personBiking}',
    'Movie buff ${AppEmojis.movieCamera}',
  ];

  // Interest categories
  static final Map<String, List<String>> interestCategories = {
    'Sports & Outdoors': [
      '${AppEmojis.hiking} Hiking',
      '${AppEmojis.yoga} Yoga',
      '${AppEmojis.surfing} Surfing',
      '${AppEmojis.football} Football',
      '${AppEmojis.basketball} Basketball',
      '${AppEmojis.cycling} Cycling',
      '${AppEmojis.camping} Camping',
      '${AppEmojis.fishing} Fishing',
      '${AppEmojis.trailRunning} Trail Running',
      '${AppEmojis.snowboarding} Snowboarding',
      '${AppEmojis.musicFestivals} Music Festivals',
      '${AppEmojis.skiing} Skiing',
      '${AppEmojis.horseRiding} Horse Riding',
      '${AppEmojis.kayaking} Kayaking',
      '${AppEmojis.swimming} Swimming',
      '${AppEmojis.rockClimbing} Rock Climbing',
    ],
    'Food & Drink': [
      '${AppEmojis.coffeeLover} Coffee Lover',
      '${AppEmojis.sushiNights} Sushi Nights',
      '${AppEmojis.pizzaFridays} Pizza Fridays',
      '${AppEmojis.wineTasting} Wine Tasting',
      '🚚 Street Food Explorer',
      '🧁 Baking',
    ],
  };

  // ========== COLLECTION VARIABLES ==========
  static final List<String> groupImages = [
    Assets.dummy.groupNight.path,
    Assets.dummy.groupFire.path,
    Assets.dummy.groupSunset.path,
    Assets.dummy.groupGlasses.path,
    Assets.dummy.groupSelfieBeach.path,
    Assets.dummy.groupSwiming.path,
  ];

  // Avatar paths matching the cover images
  static final List<String> avatarPaths = [
    Assets.dummy.a1.path,
    Assets.dummy.b1.path,
    Assets.dummy.c1.path,
    Assets.dummy.d1.path,
    Assets.dummy.e1.path,
  ];

  // group data
  static final List<GroupModel> groups = [
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
  // List of predefined prompts
  static final List<String> predefinedPrompts = [
    'A perfect weekend for me looks like...',
    'The most spontaneous thing I\'ve done...',
    'My friends describe me as...',
    'Two truths and a lie...',
    'What I\'d bring to a group trip...',
    'The fastest way to make me smile...',
    'How my group describes me in one word...',
    'My ideal group activity is...',
  ];
}
