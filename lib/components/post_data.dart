import 'package:equatable/equatable.dart';
import 'package:rediones/components/user_data.dart';

class Post extends Equatable {
  final String id;
  final String text;
  final List<String> media;
  final User poster;
  final List<String> likes;
  final int shares;
  final DateTime timestamp;

  const Post({
    required this.id,
    required this.text,
    required this.timestamp,
    this.media = const [],
    required this.poster,
    this.likes = const [],
    required this.shares,
  });


  factory Post.fromJson(Map<String, dynamic> map) => Post(
      text: map["content"],
      id: map["_id"],
      timestamp: DateTime.parse(map["createdAt"]),
      likes: map["likes"],
      shares: (map["shares"] as num).toInt(),
      media: map["media"],
      poster: User.fromJson(map["postedBy"])
  );


  Map<String, dynamic> toJson() => {
    'content': text,
    '_id': id,
    'shares': shares,
    'createdAt': timestamp.toIso8601String(),
    'likes': likes,
    'postedBy': poster.toJson(),
    'media': media
  };


  bool get has => media.isNotEmpty;

  MediaType get type => has ? MediaType.imageAndText : MediaType.textOnly;

  @override
  List<Object> get props => [id];
}


enum MediaType {
  textOnly,
  imageAndText,
  videoAndText,
}
