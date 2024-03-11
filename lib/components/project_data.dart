import 'dart:typed_data';

import 'user_data.dart';
import 'package:equatable/equatable.dart';


class ProjectData extends Equatable
{
  final String id;
  final User? user;
  final Uint8List? cover;
  final String title;
  final String description;
  final int duration;
  final String durationType;
  final List<User> moderators;
  final List<User> participants;
  final List<String> categories;
  final List<String> skillsRequired;
  final List<String> skillsPossessed;

  const ProjectData({
    required this.id,
    this.user,
    this.cover,
    this.title = "",
    this.description = "",
    this.duration = 0,
    this.durationType = "Days",
    this.moderators = const [],
    this.participants = const [],
    this.categories = const [],
    this.skillsRequired = const [],
    this.skillsPossessed = const [],
  });

  @override
  List<Object?> get props => [id];
}
