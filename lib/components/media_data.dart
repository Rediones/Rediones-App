import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/user_data.dart';

class MediaData {
  final String id;
  final String mediaUrl;
  final String caption;
  final MediaType type;
  final DateTime timestamp;
  final int views;

  const MediaData({
    this.mediaUrl = "",
    this.caption = "",
    this.id = "",
    this.type = MediaType.textOnly,
    this.views = 0,
    required this.timestamp,
  });

}

class UserSubData {
  final String id;
  final String username;
  final String lastName;
  final String firstName;
  final String profilePicture;

  const UserSubData({
    this.id = "",
    this.profilePicture = "",
    this.username = "",
    this.lastName = "",
    this.firstName = ""
  });
}

class StoryData {
  final String id;
  final UserSubData postedBy;
  final List<MediaData> stories;

  const StoryData({
    this.id = "",
    this.postedBy = const UserSubData(),
    this.stories = const [],
  });

  StoryData.fromJson(Map<String, dynamic> map)
      : id = map["_id"],
        postedBy = map['postedBy'],
        stories = map['stories'];
}
