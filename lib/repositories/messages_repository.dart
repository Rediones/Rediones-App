import 'package:rediones/components/message_data.dart';
import 'package:rediones/repositories/base_repository.dart';

class MessageRepository extends BaseRepository<MessageData> {
  static const String messagesTable = "Messages";

  @override
  String get table => messagesTable;

  @override
  Future<MessageData> fromJson(Map<String, dynamic> map) async {
    return MessageData(
      timestamp: DateTime.fromMillisecondsSinceEpoch(map["createdAt"]),
      id: map["serverID"],
      content: map["content"],
      sender: map["sender"],
      conversationID: map["conversationID"],
    );
  }

  @override
  Future<Map<String, dynamic>> toJson(MessageData value) async {
    return {
      "serverID": value.id,
      "createdAt": value.timestamp.millisecondsSinceEpoch,
      "content": value.content,
      "sentBy": value.sender,
      "conversationID": value.conversationID,
    };
  }
}
