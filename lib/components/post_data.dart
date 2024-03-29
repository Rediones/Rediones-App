import 'package:equatable/equatable.dart';
import 'package:rediones/components/user_data.dart';

class Post extends Equatable {
  final String id;
  final String text;
  final List<String> media;
  final int postCategory;
  final User poster;
  final List<String> likes;
  final int shares;
  final DateTime timestamp;

  const Post({
    required this.id,
    required this.text,
    required this.postCategory,
    required this.timestamp,
    this.media = const [],
    required this.poster,
    this.likes = const [],
    required this.shares,
  });

  PostCategory get category => toCategory(postCategory);

  factory Post.fromJson(Map<String, dynamic> map) => Post(
      text: map["content"],
      id: map["_id"],
      postCategory: map["category"],
      timestamp: DateTime.parse(map["createdAt"]),
      likes: map["likes"],
      shares: (map["shares"] as num).toInt(),
      media: map["media"],
      poster: User.fromJson(map["postedBy"])
  );


  Map<String, dynamic> toJson() => {
    'content': text,
    '_id': id,
    'category': postCategory,
    'shares': shares,
    'createdAt': timestamp.toIso8601String(),
    'likes': likes,
    'postedBy': poster.toJson(),
    'media': media
  };


  bool get has => media.isNotEmpty;

  MediaType get type => has ? MediaType.imageAndText : MediaType.textOnly;

  static PostCategory toCategory(int type) {
    switch (type) {
      case 0:
        return PostCategory.personal;
      case 1:
        return PostCategory.life;
      case 2:
        return PostCategory.travel;
      default:
        return PostCategory.none;
    }
  }

  static int fromCategory(PostCategory category) {
    switch (category) {
      case PostCategory.personal:
        return 0;
      case PostCategory.life:
        return 1;
      case PostCategory.travel:
        return 2;
      default:
        return -1;
    }
  }

  @override
  List<Object> get props => [id];
}


enum MediaType {
  textOnly,
  imageAndText,
  videoAndText,
}

enum PostCategory {
  none,
  personal,
  life,
  travel,
}
