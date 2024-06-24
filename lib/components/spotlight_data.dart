import 'user_data.dart';

class SpotlightData {
  final String id;
  final String url;
  final User postedBy;
  final String caption;
  final DateTime createdAt;

  final List<String> likes;
  final int comments;

  const SpotlightData({
    required this.id,
    required this.url,
    required this.postedBy,
    required this.caption,
    required this.createdAt,
    this.likes = const [],
    this.comments = 0,
  });

  factory SpotlightData.fromJson(Map<String, dynamic> data) => SpotlightData(
        id: data["_id"],
        url: data["link"],
        postedBy: User.fromJson(data['postedBy']),
        likes: data['likes'],
        comments: 0,
        caption: data["caption"] ?? "",
        createdAt: DateTime.parse(data["createdAt"]),
      );
}
