import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/pocket_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/components/providers.dart';
import 'profile_service.dart';

import 'base.dart';

export 'base.dart' show RedionesResponse, Status;

//ignore_for_file: empty_catches

bool _has(List<Conversation> conversations, String conversationID) {
  for (Conversation c in conversations) {
    if (c.id == conversationID) return true;
  }
  return false;
}

Future<void> initConversations(WidgetRef ref) async {
  try {
    Response response = await dio.get(
      "/conversations/user-conversations",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> conversationData = response.data as List<dynamic>;
      List<Conversation> conversations = ref.watch(conversationsProvider);
      conversations.clear();

      for (var element in conversationData) {
        List<dynamic> memberList = element["members"] as List<dynamic>;
        List<User> profiles = _getUsers(memberList);
        Map<String, dynamic> body = element as Map<String, dynamic>;
        if (_has(conversations, element["_id"])) continue;

        body["_id"] = element["_id"];
        body["members"] = profiles;
        body["lastMessage"] = element["lastMessage"];
        body["timestamp"] = element["timestamp"];
        conversations.add(Conversation.fromJson(body));
      }
    }
  } catch (e) {
    log("Init Conversation Error: $e");
  }
}

Future<Conversation?> createConversation(String id) async {
  try {
    Response response = await dio.post(
      "/conversations/new-conversation/$id",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> body = response.data as Map<String, dynamic>;
      List<dynamic> memberList = body["members"] as List<dynamic>;
      List<User> profiles = _getUsers(memberList);
      body["members"] = profiles;
      return Conversation.fromJson(body);
    }
  } catch (e) {
    log("Create Conversation Error: $e");
  }
  return null;
}

Future<RedionesResponse<MessageData?>> sendMessage(MessageData message) async {
  emit(messageSignal, message.toJson());

  try {
    Response response = await dio.post(
      "/messages/send-message",
      queryParameters: {"conversationId": message.conversationID},
      data: {
        "messageContent": message.content,
        "conversationId": message.conversationID,
        "timestamp": message.timestamp.toString(),
      },
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> map = response.data as Map<String, dynamic>;
      return RedionesResponse(
        payload: MessageData(
          timestamp: DateTime.parse(map["timestamp"]),
          id: map["_id"],
          content: map["lastMessage"],
          sender: message.sender,
          conversationID: message.conversationID,
        ),
        message: "Success",
        status: Status.success,
      );
    }
  } catch (e) {
    log("Send Message Error: $e");
  }
  return const RedionesResponse(
    payload: null,
    message: "An error occurred. Please try again",
    status: Status.failed,
  );
}

List<User> _getUsers(List<dynamic> list) {
  List<User> users = [];
  for (var element in list) {
    Map<String, dynamic> map = element as Map<String, dynamic>;
    processUser(map);
    users.add(User.fromJson(map));
  }
  return users;
}

Future<List<MessageData>> getMessagesFor(
    String conversationID, String otherID) async {
  List<MessageData> messages = [];

  try {
    Response response = await dio.get(
      "/messages/$conversationID",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      log(response.data.toString());
      List<dynamic> result = response.data as List<dynamic>;
      for (var element in result) {
        String? message = element["messageContent"];
        if (message == null || message.isEmpty) {
          continue;
        }

        String time = element["createdAt"];
        String senderID = element["sender"]["_id"];

        MessageData data = MessageData(
          sender: senderID,
          content: message,
          timestamp: DateTime.parse(time),
          conversationID: conversationID,
          id: element["_id"],
        );
        messages.add(data);
      }

      return messages;
    }
  } catch (e) {
    log("Get Message Error: $e");
  }

  return messages;
}

Future<RedionesResponse<PocketResponse?>> getPocket() async {
  try {
    Response response = await dio.get(
      "/pocket",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! <= 201) {
      log(response.data.toString());
      List<dynamic> pocketData =
          response.data["payload"]["pocketMessages"] as List<dynamic>;
      List<dynamic> stickyData =
          response.data["payload"]["stickyNotes"] as List<dynamic>;

      List<PocketMessageData> pocket = [];
      List<StickyData> sticky = [];

      for(var element in pocketData) {
        pocket.add(PocketMessageData.fromJson(element));
      }

      for (var element in stickyData) {
        sticky.add(StickyData.fromJson(element));
      }

      return RedionesResponse(
        message: "Success",
        payload: PocketResponse(
          pocketMessages: pocket,
          stickyNotes: sticky,
        ),
        status: Status.success,
      );
    }
  } catch (e) {
    log("Get Pocket Message Data Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<PocketMessageData?>> createPocketMessageData(
    String text) async {
  try {
    Response response = await dio.post(
      "/pocket",
      data: {"text": text},
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! <= 201) {
      log(response.data.toString());
      return RedionesResponse(
        message: "Successful",
        payload: PocketMessageData.fromJson(response.data["payload"]),
        status: Status.success,
      );
    }
  } catch (e) {
    log("Create Pocket Message Data Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again",
    payload: null,
    status: Status.failed,
  );
}


Future<RedionesResponse<StickyData?>> makeSticky(String id) async {
  try {
    Response response = await dio.patch(
      "/pocket/make-note/$id",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! <= 201) {
      return RedionesResponse(
        message: "Successful",
        payload: StickyData.fromJson(response.data),
        status: Status.success,
      );
     }
  } catch (e) {
    log("Create Sticky Note Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again",
    payload: null,
    status: Status.failed,
  );
}


class PocketResponse {
  final List<StickyData> stickyNotes;
  final List<PocketMessageData> pocketMessages;

  const PocketResponse({
    required this.stickyNotes,
    required this.pocketMessages,
  });
}
