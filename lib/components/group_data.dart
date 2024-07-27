import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/user_data.dart';

class GroupData {
  final String id;
  final String groupCoverImage;
  final String groupName;
  final String groupDescription;
  final List<Post> groupPosts;
  final List<String> groupUsers;
  final List<String> categories;
  final DateTime created;

  const GroupData({
    required this.id,
    required this.groupCoverImage,
    required this.groupName,
    required this.groupDescription,
    required this.created,
    this.groupPosts = const [],
    this.groupUsers = const [],
    this.categories = const [],
  });

  factory GroupData.fromJson(Map<String, dynamic> map) {
    return GroupData(
      id: map["_id"],
      groupCoverImage: map["cover"],
      groupName: map["title"],
      groupDescription: map["description"],
      groupUsers: map["members"],
      categories: map["categories"],
      created: DateTime.parse(map["createdAt"]),
    );
  }
}


