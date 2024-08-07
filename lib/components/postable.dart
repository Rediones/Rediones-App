import 'package:isar/isar.dart';


abstract class PostObject{
  final String uuid;

  final String text;

  @Index()
  final String posterID;

  final String posterPicture;
  final String posterName;
  final String posterUsername;

  final List<String> likes;
  final int shares;

  @Index()
  final DateTime timestamp;

  const PostObject({
    this.uuid = "",
    this.text = "",
    this.posterID = "",
    this.posterName = "",
    this.posterPicture = "",
    this.posterUsername = "",
    this.likes = const [],
    this.shares = 0,
    required this.timestamp,
  });
}
