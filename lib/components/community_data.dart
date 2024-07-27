import 'package:rediones/components/group_data.dart';

class CommunityData {
  final String id;
  final String name;
  final String image;
  final String description;
  final String members;

  const CommunityData({
    this.id = "",
    required this.name,
    required this.image,
    required this.description,
    required this.members,
  });

  factory CommunityData.fromGroupData(GroupData data) {
    return CommunityData(
      id: data.id,
      name: data.groupName,
      image: data.groupCoverImage,
      description: data.groupDescription,
      members: "data.groupUsers.map((d) => d.uuid).toList()",
    );
  }
}

class CommunityChatData {
  final String id;
  final String userId;
  final String username;
  final String image;
  final String message;
  final DateTime timestamp;

  const CommunityChatData({
    required this.id,
    required this.userId,
    required this.username,
    required this.image,
    required this.message,
    required this.timestamp,
  });
}
