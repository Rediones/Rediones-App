import 'package:equatable/equatable.dart';
import 'package:rediones/components/user_data.dart';

import 'package:isar/isar.dart';



abstract class PostObject{
  final String uuid;
  final String text;

  final User poster;

  final List<String> likes;
  final int shares;
  final DateTime timestamp;

  const PostObject({
    this.uuid = "",
    this.text = "",
    required this.poster,
    this.likes = const [],
    this.shares = 0,
    required this.timestamp,
  });
}
