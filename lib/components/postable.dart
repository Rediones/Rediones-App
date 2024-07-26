import 'package:isar/isar.dart';


abstract class PostObject{
  final String uuid;

  final String text;

  @Index()
  final String poster;

  final List<String> likes;
  final int shares;

  @Index()
  final DateTime timestamp;

  const PostObject({
    this.uuid = "",
    this.text = "",
    this.poster = "",
    this.likes = const [],
    this.shares = 0,
    required this.timestamp,
  });
}
