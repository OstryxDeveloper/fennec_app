import '../../../../app/theme/app_emojis.dart';
import '../../../../generated/assets.gen.dart';
import 'profile_model.dart';

class GroupModel {
  final String id;
  final String name;
  final String description;
  final String? coverImage;
  final String? groupTag;
  final List<ProfileModel> members;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    this.coverImage,
    this.groupTag,
    List<ProfileModel>? members,
  }) : members = members ?? profiles;

  // Profile data
  static List<ProfileModel> profiles = [
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
        'Adventure seeker ${AppEmojis.nationalPark}',
        'Nature explorer ${AppEmojis.evergreenTree}',
        'Foodie ${AppEmojis.plateWithCutlery}',
        'Dog parent ${AppEmojis.dogFace}',
        'Early riser ${AppEmojis.sunrise}',
      ],
      interests: [
        'Hiking ${AppEmojis.rockClimbing}',
        'Coffee culture ${AppEmojis.coffee}',
        'Design ${AppEmojis.artistPalette}',
        'Travel ${AppEmojis.airplane}',
        'Photography ${AppEmojis.camera}',
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
        'Road trips ${AppEmojis.car}',
        'Coffee ${AppEmojis.coffee}',
        'Product design ${AppEmojis.building}',
        'Outdoor adventures ${AppEmojis.mountain}',
        'Music ${AppEmojis.musicalNote}',
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
        'Foodie ${AppEmojis.plateWithCutlery}',
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
        'Technology ${AppEmojis.laptop}',
        'Hiking ${AppEmojis.rockClimbing}',
        'Data science ${AppEmojis.chartIncreasing}',
        'Camping ${AppEmojis.camping}',
        'Spontaneous fun ${AppEmojis.gameDie}',
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
        'Art ${AppEmojis.artistPalette}',
        'Design ${AppEmojis.paintbrush}',
        'Sunsets ${AppEmojis.sunrise}',
        'Creative projects ${AppEmojis.lightBulb}',
        'Travel ${AppEmojis.globeShowingEuropeAfrica}',
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
}
