import 'package:get_it/get_it.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/repositories/base_repository.dart';
import 'package:sqflite/sqflite.dart';

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

  Future<List<MessageData>> getMessagesWith(String conversationID) async {
    final Database database = GetIt.I.get();

    List<Map<String, dynamic>>? response = await database.query(
      table,
      where: "(conversationID = ?)",
      whereArgs: [conversationID],
      orderBy: "createdAt ASC",
    );

    List<MessageData> messages = [];
    for (var element in response) {
      MessageData msg = await fromJson(element);
      messages.add(msg);
    }

    return messages;
  }
}
