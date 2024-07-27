import 'package:rediones/api/user_service.dart';
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
      // for (var element in forYouList) {
      //   forYou.add(_processGroup(element as Map<String, dynamic>));
      // }

      return RedionesResponse(
        message: "Groups Fetched",
        payload: JointGroup(forYou: forYou, myGroups: myGroups),
        status: Status.success,
      );
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
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
      message: dioErrorResponse(errorHeader, e),
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
  map["members"] = fromArrayString(map["members"]);
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
      message: dioErrorResponse(errorHeader, e),
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
      log(response.data.toString());
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
      message: dioErrorResponse(errorHeader, e),
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
