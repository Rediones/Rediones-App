import 'package:rediones/components/postable.dart';

import 'package:isar/isar.dart';

part 'post_data.g.dart';

@collection
class Post extends PostObject {
  final Id id = Isar.autoIncrement;
  final List<String> media;

  const Post({
    super.uuid,
    super.text,
    required super.timestamp,
    this.media = const [],
    required super.poster,
    super.likes,
    super.shares,
  });

  factory Post.fromJson(Map<String, dynamic> map) => Post(
        text: map["content"],
        uuid: map["_id"],
        timestamp: DateTime.parse(map["createdAt"]),
        likes: map["likes"],
        shares: (map["shares"] as num).toInt(),
        media: map["media"],
        poster: map["postedBy"]["_id"],
      );

  Map<String, dynamic> toJson() => {
        'content': text,
        '_id': uuid,
        'shares': shares,
        'createdAt': timestamp.toIso8601String(),
        'likes': likes,
        'postedBy': poster,
        'media': media
      };

  @ignore
  bool get has => media.isNotEmpty;

  @ignore
  MediaType get type => has ? MediaType.imageAndText : MediaType.textOnly;
}

enum MediaType {
  textOnly,
  imageAndText,
  videoAndText,
}
