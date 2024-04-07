import 'package:rediones/components/user_data.dart';

class CommentData
{
  final String id;
  final User postedBy;
  final String content;
  final String relatedContent;
  final List<String> likes;
  final DateTime created;

  const CommentData({
    required this.id,
    required this.postedBy,
    required this.content,
    required this.relatedContent,
    required this.likes,
    required this.created,
  });

  CommentData.fromJson(Map<String, dynamic> data) :
      postedBy = User.fromJson(data["postedBy"]),
      content = data["content"],
      relatedContent = data["relatedContent"],
      id = data["_id"],
      likes = data["likes"],
      created = DateTime.parse(data["createdAt"]);
}