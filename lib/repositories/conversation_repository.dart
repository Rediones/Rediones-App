import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/repositories/base_repository.dart';
import 'package:rediones/repositories/user_repository.dart';

class ConversationRepository extends BaseRepository<Conversation> {
  static const String conversationTable = "Conversations";

  final UserRepository userRepository = UserRepository();

  @override
  Future<Conversation> fromJson(Map<String, dynamic> map) async {
    User firstUser = (await userRepository.getById(map["firstUser"]))!;
    User secondUser = (await userRepository.getById(map["secondUser"]))!;

    return Conversation(
      id: map["serverID"],
      lastMessage: map["lastMessage"],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map["timestamp"]),
      users: [firstUser, secondUser]
    );
  }

  @override
  String get table => conversationTable;

  @override
  Future<Map<String, dynamic>> toJson(Conversation value) async {
    userRepository.addAll(value.users);

    return {
      "serverID": value.id,
      "lastMessage": value.lastMessage,
      "timestamp": value.timestamp!.millisecondsSinceEpoch,
      "firstUser": value.users[0].id,
      "secondUser": value.users[1].id,
    };
  }
}
