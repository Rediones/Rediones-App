import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/user_data.dart';


class MediaData {
  final String mediaUrl;
  final String caption;
  final MediaType type;
  final DateTime timestamp;
  final int views;

  const MediaData({
    required this.mediaUrl,
    this.caption = "",
    required this.type,
    required this.views,
    required this.timestamp,
  });

  MediaData.fromJson(Map<String, dynamic> data)
      : mediaUrl = data['mediaUrl'],
        caption = data['caption'],
        type = data['type'],
        timestamp = data['createdAt'],
        views = data['views'];

  Map<String, dynamic> toJson() => {
    'mediaUrl': mediaUrl,
    'caption': caption,
    'type': type,
    'createdAt': timestamp,
    'views': views,
  };
}

class StoryData {
  final User postedBy;
  final List<MediaData> stories;

  const StoryData({required this.postedBy, this.stories = const []});

  StoryData.fromJson(Map<String, dynamic> map)
      : postedBy = User.fromJson(map['postedBy']),
        stories = map['stories'];

}