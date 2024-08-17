import 'package:rediones/components/postable.dart';

import 'package:isar/isar.dart';
import 'package:rediones/tools/functions.dart';

part 'post_data.g.dart';

@collection
class Post extends PostObject {

  final List<String> media;

  const Post({
    super.uuid,
    super.text,
    super.saved,
    required super.timestamp,
    this.media = const [],
    required super.posterID,
    required super.posterUsername,
    required super.posterName,
    required super.posterPicture,
    super.comments,
    super.likes,
    super.shares,
  });



  factory Post.fromJson(Map<String, dynamic> map) {
    return Post(
      text: map["content"],
      uuid: map["_id"],
      timestamp: DateTime.parse(map["createdAt"]),
      likes: map["likes"],
      shares: (map["shares"] as num).toInt(),
      media: map["media"],
      saved: map["saved"],
      comments: map["comments"],
      posterID: map["postedBy"]["_id"],
      posterName: "${map["postedBy"]["firstName"]} ${map["postedBy"]["lastName"]}",
      posterPicture: map["postedBy"]["profilePicture"],
      posterUsername: map["postedBy"]["username"],
    );
  }

  @override
  Post copyWith({int? newComments}) {
    return Post(
      text: text,
      comments: newComments ?? comments,
      uuid: uuid,
      timestamp: timestamp,
      likes: likes,
      shares: shares,
      media: media,
      posterID: posterID,
      posterName: posterName,
      posterPicture: posterPicture,
      posterUsername: posterUsername,
    );
  }

  @ignore
  bool get has => media.isNotEmpty;

  Id get isarId => fastHash(uuid);

  @ignore
  MediaType get type => has ? MediaType.imageAndText : MediaType.textOnly;

  @override
  String toString() {
    return "Post { text: $text: uuid: $uuid }";
  }
}

enum MediaType {
  textOnly,
  imageAndText,
  videoAndText,
}
