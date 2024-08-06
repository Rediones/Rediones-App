import 'package:rediones/components/media_data.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/pocket_data.dart';
import 'package:rediones/components/user_data.dart';

import 'base.dart';
import 'user_service.dart';

export 'base.dart' show RedionesResponse, Status;

//ignore_for_file: empty_catches

bool _has(List<Conversation> conversations, String conversationID) {
  for (Conversation c in conversations) {
    if (c.id == conversationID) return true;
  }
  return false;
}

Future<RedionesResponse<List<Conversation>>> getConversations() async {


  String errorHeader = "Get Conversations:";
  try {
    Response response = await dio.get(
      "/conversations/user-conversations",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> conversationData = response.data as List<dynamic>;
      List<Conversation> conversations = [];

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

        return RedionesResponse(
          message: "Success",
          payload: conversations,
          status: Status.success,
        );
      }
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: [],
      status: Status.failed,
    );
  } catch (e) {
    log("Create Conversation Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<Conversation?>> createConversation(String id) async {
  String errorHeader = "Create Conversation:";
  try {
    Response response = await dio.post(
      "/conversations/new-conversation/$id",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      log("${response.data}");
      Map<String, dynamic> body = response.data as Map<String, dynamic>;
      List<dynamic> memberList = body["members"] as List<dynamic>;
      List<User> profiles = _getUsers(memberList);
      body["members"] = profiles;

      return RedionesResponse(
        payload: Conversation.fromJson(body),
        message: "Success",
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: null,
      status: Status.failed,
    );
  } catch (e) {
    log("Create Conversation Error: $e");
  }
  return RedionesResponse(
    payload: null,
    message: "$errorHeader An error occurred. Please try again",
    status: Status.failed,
  );
}

Future<RedionesResponse<MessageData?>> sendMessage(MessageData message) async {
  emit(sendMessageSignal, {
    "message" : message.content,
    "senderId": message.sender,
    "receiverId": message.id,
  });

  String errorHeader = "Send Message:";
  try {
    Response response = await dio.post(
      "/messages/send-message",
      queryParameters: {"conversationId": message.conversationID},
      data: {
        "messageContent": message.content,
        "conversationId": message.conversationID,
        "timestamp": message.timestamp.toString(),
        "otherUserId": message.id,
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
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: null,
      status: Status.failed,
    );
  } catch (e) {
    log("Send Message Error: $e");
  }
  return RedionesResponse(
    payload: null,
    message: "$errorHeader An error occurred. Please try again",
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

Future<RedionesResponse<List<MessageData>>> getMessagesFor(
    String conversationID, String otherID) async {
  String errorHeader = "Get Messages:";
  try {
    Response response = await dio.get(
      "/messages/$conversationID",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> result = response.data as List<dynamic>;
      List<MessageData> messages = [];
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

      return RedionesResponse(
        message: "Success",
        payload: messages,
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: [],
      status: Status.failed,
    );
  } catch (e) {
    log("Get Message Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An error occurred. Please try again",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<PocketResponse?>> getPocket() async {
  String errorHeader = "Get Pocket";
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

      for (var element in pocketData) {
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
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: null,
      status: Status.failed,
    );
  } catch (e) {
    log("Get Pocket Message Data Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An error occurred. Please try again",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<PocketMessageData?>> createPocketMessageData(
    String text) async {
  String errorHeader = "Create Pocket:";
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
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: null,
      status: Status.failed,
    );
  } catch (e) {
    log("Create Pocket Message Data Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An error occurred. Please try again",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<StickyData?>> makeSticky(String id) async {
  String errorHeader = "Make Sticky:";
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
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: null,
      status: Status.failed,
    );
  } catch (e) {
    log("Create Sticky Note Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An error occurred. Please try again",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<MediaData?>> createStory(Map<String, dynamic> data) async {
  String errorHeader = "Create Story:";
  try {
    Response response = await dio.post(
      "/stories",
      data: data,
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! <= 201) {
      // Map<String, dynamic> data = response.data;
      // MediaData md = MediaData(
      //   id: data["_id"],
      //   mediaUrl: data["media"],
      //   caption: (data["caption"] ?? ""),
      //   timestamp: DateTime.parse(data["timestamp"]),
      //   views: data["views"].length,
      //   type: (data["type"] as num).toInt() == 1
      //       ? MediaType.imageAndText
      //       : MediaType.videoAndText,
      // );

      return const RedionesResponse(
        message: "Successful",
        payload: null,
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: null,
      status: Status.failed,
    );
  } catch (e) {
    log("Create Story Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An error occurred. Please try again",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse> viewStory(String id) async {
  String errorHeader = "View Story:";
  try {
    Response response = await dio.post(
      "/stories/$id/view",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! <= 201) {
      return const RedionesResponse(
        message: "Successful",
        payload: null,
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: null,
      status: Status.failed,
    );
  } catch (e) {
    log("View Story Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An error occurred. Please try again",
    payload: null,
    status: Status.failed,
  );
}



class JointStoryData {
  StoryData currentUserStory;
  final List<StoryData> otherStories;

  JointStoryData({
    this.currentUserStory = const StoryData(),
    this.otherStories = const [],
  });
}

Future<RedionesResponse<JointStoryData>> getStories(
    String currentUserID) async {
  if(accessToken == null) {
    return RedionesResponse(
      message: "Success",
      payload: JointStoryData(),
      status: Status.success,
    );
  }

  String errorHeader = "Get Stories:";
  try {
    Response response = await dio.get(
      "/stories",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> data = response.data as List<dynamic>;
      List<StoryData> stories = [];
      JointStoryData jointStoryData = JointStoryData(otherStories: stories);

      for (var element in data) {
        List<dynamic> storyData = element["stories"];
        List<MediaData> mediaData = [];
        for (var sd in storyData) {
          MediaData md = MediaData(
            id: sd["_id"],
            mediaUrl: sd["media"],
            caption: (sd["caption"] ?? ""),
            timestamp: DateTime.parse(sd["timestamp"]),
            views: sd["views"].length,
            type: (sd["type"] as num).toInt() == 1
                ? MediaType.imageAndText
                : MediaType.videoAndText,
          );

          mediaData.add(md);
        }

        StoryData parsedData = StoryData(
          postedBy: processUserSubData(element["user"]),
          stories: mediaData,
        );

        if (parsedData.postedBy.id == currentUserID) {
          jointStoryData.currentUserStory = parsedData;
        } else {
          stories.add(parsedData);
        }
      }

      return RedionesResponse(
        message: "Success",
        payload: jointStoryData,
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: JointStoryData(),
      status: Status.failed,
    );
  } catch (e) {
    log("Get Stories Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: JointStoryData(),
    status: Status.failed,
  );
}

UserSubData processUserSubData(Map<String, dynamic> map) {
  String profile = map["profilePicture"] ??
      "https://gravatar.com/avatar/${map["_id"].hashCode.toString()}?s=400&d=robohash&r=x";

  return UserSubData(
    id: map["_id"],
    firstName: map["firstName"],
    lastName: map["lastName"],
    username: map["username"],
    profilePicture: profile,
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
