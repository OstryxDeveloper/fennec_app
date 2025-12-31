class ProfileModel {
  final String? id;
  final String? firstName;
  final String? name;
  final int? age;
  final String? bio;
  final String? gender;
  final String? coverImage;
  final String? orientation;
  final String? pronouns;
  final String? location;
  final String? distance;
  final String? education;
  final String? profession;
  final List<String>? interests;
  final List<String>? images;
  final String? promptTitle;
  final String? promptAnswer;
  final List<String>? lifestyle;

  ProfileModel({
    this.id,
    this.name,
    this.firstName,
    this.age,
    this.bio,
    this.coverImage,
    this.gender,
    this.orientation,
    this.pronouns,
    this.location,
    this.distance,
    this.education,
    this.profession,
    this.interests,
    this.images,
    this.promptTitle,
    this.promptAnswer,
    this.lifestyle,
  });
}
