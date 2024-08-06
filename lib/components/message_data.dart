import 'package:rediones/components/user_data.dart';

export 'package:rediones/components/post_data.dart' show MediaType;

class MessageData {
  final DateTime timestamp;
  final String id;
  final bool repliedMessage;
  final String? repliedMessageID;
  final String content;
  final String sender;
  final String conversationID;

  const MessageData({
    required this.timestamp,
    required this.id,
    this.repliedMessage = false,
    this.repliedMessageID,
    required this.content,
    required this.sender,
    required this.conversationID,
  });

  Map<String, dynamic> toJson() => {
        "_id": id,
        "createdAt": timestamp.toString(),
        "content": content,
        "sentBy": sender,
        "conversationID": conversationID,
      };
}

class Conversation {
  final String id;
  final List<User> users;
  String lastMessage;
  final DateTime? timestamp;

  Conversation({
    this.id = "",
    this.users = const [],
    this.timestamp,
    this.lastMessage = "",
  });

  factory Conversation.fromJson(Map<String, dynamic> map) => Conversation(
        id: map["_id"],
        users: map["members"],
        lastMessage: map["lastMessage"],
        timestamp: DateTime.parse(map["timestamp"]),
      );
}
