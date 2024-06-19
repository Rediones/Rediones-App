import 'user_data.dart';

class SpotlightData {
  final String id;
  final String url;
  final User poster;
  final DateTime createdAt;

  final List<String> likes;
  final int comments;

  const SpotlightData({
    required this.id,
    required this.url,
    required this.poster,
    required this.createdAt,
    this.likes = const [],
    this.comments = 0,
  });

  factory SpotlightData.fromJson(Map<String, dynamic> data) => SpotlightData(
        id: data["_id"],
        url:
            "https://medbolt-website.vercel.app/static/media/doctors_talking.80509c04b8b459ccc95f.mp4",
        //   data["link"],
        poster: data['postedBy'],
        likes: data['likes'],
        comments: 0,
        createdAt: DateTime.now(),
      );
}
