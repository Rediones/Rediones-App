class CommunityData {
  final String name;
  final String image;
  final String description;
  final String members;

  const CommunityData({
    required this.name,
    required this.image,
    required this.description,
    required this.members,
  });
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
