import 'package:rediones/components/group_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/user_data.dart';
import 'base.dart';
import 'package:rediones/api/profile_service.dart';
import 'post_service.dart';

export 'base.dart' show RedionesResponse, Status, imgPrefix;

Future<RedionesResponse<List<GroupData>>> getGroups() async {
  try {
    Response response =
        await dio.get("/groups/all", options: configuration(accessToken!));

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> eventList = response.data as List<dynamic>;
      List<GroupData> groups = [];
      for (var element in eventList) {
        groups.add(_processGroup(element as Map<String, dynamic>));
      }

      return RedionesResponse(
        message: "Groups Fetched",
        payload: groups,
        status: Status.success,
      );
    }
  } catch (e) {
    log("Get Groups Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<List<Post>>> getGroupPosts(String id) async {
  try {
    Response response =
    await dio.get("/post/by-group/$id", options: configuration(accessToken!));

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      //log(response.data.toString());
      List<dynamic> eventList = response.data["payload"] as List<dynamic>;
      List<Post> posts = [];
      for (var element in eventList) {
        posts.add(processPost(element as Map<String, dynamic>));
      }

      return RedionesResponse(
        message: "Group Posts Fetched",
        payload: posts,
        status: Status.success,
      );
    }
  } catch (e) {
    log("Get Group Posts Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

GroupData _processGroup(Map<String, dynamic> map) {
  log(map.toString());
  map["members"] = processUsers(map["members"]);
  return GroupData.fromJson(map);
}

Future<RedionesResponse<GroupData?>> createGroup(
    Map<String, dynamic> data) async {
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
        message: "Group Created",
        payload: group,
        status: Status.success,
      );
    }
  } catch (e) {
    log("Create Group Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}
