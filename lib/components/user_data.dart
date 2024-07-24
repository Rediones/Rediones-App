import 'package:isar/isar.dart';
part 'user_data.g.dart';

@collection
class User {
  final Id id = Isar.autoIncrement;


  final String uuid;
  final String profilePicture;
  final String email;
  final String nickname;
  final String firstName;
  final String lastName;
  final String otherName;
  final List<String> followers;
  final List<String> following;
  final List<String> savedPosts;
  final String school;
  final String address;
  final String description;
  final String gender;

  const User({
    required this.uuid,
    this.profilePicture = "",
    this.gender = "",
    this.nickname = "",
    this.firstName = "",
    this.otherName = "",
    this.lastName = "",
    this.email = "",
    this.followers = const [],
    this.following = const [],
    this.savedPosts = const [],
    this.address = "",
    this.description = "",
    this.school = "",
  });

  String get username => "$firstName $lastName";

  bool get isProfileComplete {
    return true;
  }

  // @override
  // @ignore List<Object> get props => [uuid];

  factory User.fromJson(Map<String, dynamic> map) => User(
      uuid: map["_id"],
      email: map["email"],
      profilePicture: map["profilePicture"],
      firstName: map["firstName"] ?? "",
      lastName: map["lastName"] ?? "",
      otherName: map["otherName"] ?? "",
      nickname: map["username"] ?? "",
      followers: map["followers"] ?? [],
      following: map["following"] ?? [],
      savedPosts: map["saved"] ?? [],
      address: map["address"] ?? "",
      description: map["bio"],
      school: map["schoolAddress"] ?? "",
      gender: map["gender"] ?? "",
  );

  Map<String, dynamic> toJson() => {
        '_id': uuid,
        'profilePicture': profilePicture,
        'email': email,
        'nickname': nickname,
        'firstName': firstName,
        'lastName': lastName,
        'otherName': otherName,
        'school': school,
        'address': address,
        'description': description,
        'gender': gender,
        'followers': followers,
        'following': following,
        'saved': []
      };
}
