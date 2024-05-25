import 'package:rediones/components/postable.dart';
import 'package:rediones/components/user_data.dart';

class Post extends PostObject {
  final List<String> media;

  const Post({
    super.id,
    super.text,
    required super.timestamp,
    this.media = const [],
    required super.poster,
    super.likes,
    super.shares,
  });

  factory Post.fromJson(Map<String, dynamic> map) => Post(
        text: map["content"],
        id: map["_id"],
        timestamp: DateTime.parse(map["createdAt"]),
        likes: map["likes"],
        shares: (map["shares"] as num).toInt(),
        media: map["media"],
        poster: User.fromJson(map["postedBy"]),
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
  List<Object> get props => [super.id];
}

enum MediaType {
  textOnly,
  imageAndText,
  videoAndText,
}
