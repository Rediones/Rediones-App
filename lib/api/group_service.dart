import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/community_data.dart';
import 'package:rediones/components/group_data.dart';
import 'package:rediones/components/postable.dart';

import 'base.dart';
import 'post_service.dart';

export 'base.dart' show RedionesResponse, Status, imgPrefix;

class JointGroup {
  final List<GroupData> myGroups;
  final List<GroupData> forYou;

  const JointGroup({
    this.myGroups = const [],
    this.forYou = const [],
  });
}

Future<RedionesResponse<JointGroup>> getGroups() async {
  String errorHeader = "Get Communities:";
  try {
    Response response = await dio.get(
      "/groups/all",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> myGroupList = response.data["myGroups"],
          forYouList = response.data["forYou"];

      List<GroupData> myGroups = [], forYou = [];
      for (var element in myGroupList) {
        myGroups.add(_processGroup(element as Map<String, dynamic>));
      }

      for (var element in forYouList) {
        forYou.add(_processGroup(element as Map<String, dynamic>));
      }

      return RedionesResponse(
        message: "Groups Fetched",
        payload: JointGroup(forYou: forYou, myGroups: myGroups),
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(e),
      payload: const JointGroup(),
      status: Status.failed,
    );
  } catch (e) {
    log("Get Communities Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: const JointGroup(),
    status: Status.failed,
  );
}

Future<RedionesResponse<List<PostObject>>> getGroupPosts(String id) async {
  String errorHeader = "Get Group Posts:";

  try {
    Response response = await dio.get(
      "/post/by-group/$id",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> eventList = response.data["payload"] as List<dynamic>;
      List<PostObject> posts = [];
      for (var element in eventList) {
        posts.add(processPost(element as Map<String, dynamic>));
      }

      return RedionesResponse(
        message: "Group Posts Fetched",
        payload: posts,
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(e),
      payload: [],
      status: Status.failed,
    );
  } catch (e) {
    log("Get Group Posts Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

GroupData _processGroup(Map<String, dynamic> map) {
  map["members"] = processUsers(map["members"]);
  map["categories"] = fromArrayString(map["categories"]);
  return GroupData.fromJson(map);
}

Future<RedionesResponse<GroupData?>> createGroup(
    Map<String, dynamic> data) async {
  String errorHeader = "Create Group:";
  try {
    Response response = await dio.post(
      "/groups",
      data: data,
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> result =
          response.data["payload"] as Map<String, dynamic>;
      GroupData group = _processGroup(result);
      return RedionesResponse(
        message: "Group Created",
        payload: group,
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(e),
      payload: null,
      status: Status.failed,
    );
  } catch (e) {
    log("Create Group Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}

class CommunityChatServerData {
  final String conversationId;
  final List<CommunityChatData> chats;

  const CommunityChatServerData({
    required this.conversationId,
    required this.chats,
  });
}

Future<RedionesResponse<CommunityChatServerData>> getGroupMessages(
    String id) async {
  String errorHeader = "Get Group Messages:";

  try {
    Response response = await dio.get(
      "/messages/group/$id",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      log(response.data.toString());

      List<dynamic> serverChats = response.data["payload"]["messages"];
      List<CommunityChatData> chats = [];
      for (var element in serverChats) {
        String? message = element["messageContent"];
        if (message == null || message.isEmpty) {
          continue;
        }

        String time = element["createdAt"];

        CommunityChatData data = CommunityChatData(
          image: element["sender"]["profilePicture"] ?? "https://gravatar.com/avatar/${element["sender"]["_id"].hashCode.toString()}?s=400&d=robohash&r=x",
          username: element["sender"]["username"],
          message: message,
          timestamp: DateTime.parse(time),
          userId: element["sender"]["_id"],
          id: element["_id"],
        );
        chats.add(data);
      }

      return RedionesResponse(
        message: "Group Messages Fetched",
        payload: CommunityChatServerData(
          conversationId: response.data["payload"]["conversation"]["_id"],
          chats: chats,
        ),
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(e),
      payload: const CommunityChatServerData(
        chats: [],
        conversationId: ""
      ),
      status: Status.failed,
    );
  } catch (e) {
    log("Get Group Messages Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An error occurred. Please try again.",
    payload: const CommunityChatServerData(
        chats: [],
        conversationId: ""
    ),
    status: Status.failed,
  );
}

Future<RedionesResponse> sendGroupMessage(
    String groupId, String message) async {
  String errorHeader = "Send Group Messages:";

  try {
    Response response = await dio.post(
      "/messages/group/$groupId",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> eventList = response.data["payload"] as List<dynamic>;
      List<PostObject> posts = [];
      for (var element in eventList) {
        posts.add(processPost(element as Map<String, dynamic>));
      }

      return RedionesResponse(
        message: "Group Messages Fetched",
        payload: posts,
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(e),
      payload: [],
      status: Status.failed,
    );
  } catch (e) {
    log("Send Group Message Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<GroupData?>> createCommunity(
    Map<String, dynamic> data) async {
  String errorHeader = "Create Community:";
  try {
    Response response = await dio.post(
      "/groups",
      data: data,
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> result =
          response.data["payload"] as Map<String, dynamic>;
      GroupData group = _processGroup(result);
      return RedionesResponse(
        message: "Community Created",
        payload: group,
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(e),
      payload: null,
      status: Status.failed,
    );
  } catch (e) {
    log("Create Group Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}
