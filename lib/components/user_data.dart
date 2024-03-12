import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
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
  final String level;

  const User({
    required this.id,
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
    this.level = "",
  });

  String get username => "$firstName $lastName";

  bool get isProfileComplete {
    return true;
  }

  @override
  List<Object> get props => [id];

  factory User.fromJson(Map<String, dynamic> map) => User(
      id: map["_id"],
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
      level: map["level"] ?? "");

  Map<String, dynamic> toJson() => {
        'id': id,
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
        'level': level,
        'followers': followers,
        'following': following,
        'saved': []
      };
}
