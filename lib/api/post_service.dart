import 'dart:async';
import 'dart:convert';

import 'package:rediones/api/base.dart';
import 'package:rediones/api/profile_service.dart';
import 'package:rediones/components/comment_data.dart';
import 'package:rediones/components/poll_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/providers.dart' show dummyPosts;

export 'package:rediones/api/base.dart' show RedionesResponse, Status;

Future<RedionesResponse<PostObject?>> createPost(
    Map<String, dynamic> data) async {
  String errorHeader = "Create Post:";
  try {
    Response response = await dio.post(
      "/post/create-post",
      data: data,
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> result =
          response.data["payload"] as Map<String, dynamic>;
      PostObject post = processPost(result);
      return RedionesResponse(
        message: "Post Created",
        payload: post,
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
    log("Create Post Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}

PostObject processPost(Map<String, dynamic> result, {User? user}) {
  if(user == null) {
    Map<String, dynamic> user = result["postedBy"] as Map<String, dynamic>;
    processUser(user);
    // result["postedBy"] = user;
  } else {
    result["postedBy"] = user.toJson();
  }

  result["likes"] = fromArrayString(result["likes"] as List<dynamic>);

  if (result["type"] == "POST") {
    result["media"] = fromArrayString(result["media"] as List<dynamic>);
    return Post.fromJson(result);
  } else if (result["type"] == "POLL") {
    return PollData.fromJson(result);
  }

  return dummyPosts.first;
}

Future<RedionesResponse<List<PostObject>>> getPosts() async {
  if (accessToken == null) {
    return const RedionesResponse(
      message: "",
      payload: [],
      status: Status.success,
    );
  }

  String errorHeader = "Get Posts:";

  try {
    Response response = await dio.get(
      "/posts/all",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> postList = response.data["payload"] as List<dynamic>;
      List<PostObject> posts = [];
      for (var element in postList) {
        posts.add(processPost(element as Map<String, dynamic>));
      }

      return RedionesResponse(
        message: "Posts Fetched",
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
    log("Get Posts Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<List<PostObject>>> getUsersPosts({String? id, User? currentUser}) async {
  String errorHeader = "Get Users Posts:";

  if((id == null && currentUser == null) || (id != null && currentUser != null)) {
    return RedionesResponse(
      message: "$errorHeader You can only provide either the ID or the User object but not both nor neither.",
      payload: [],
      status: Status.failed,
    );
  }


  try {
    Response response = await dio.post(
      "/post/get-post-by-user",
      data: {"userId": currentUser == null ? id : currentUser.uuid},
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> postList = response.data["payload"] as List<dynamic>;
      List<PostObject> posts = [];
      for (var element in postList) {
        posts.add(processPost(element as Map<String, dynamic>, user: currentUser));
      }

      return RedionesResponse(
        message: "Posts Fetched",
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
    log("Get User Posts Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<List<PostObject>>> getUsersSavedPosts() async {
  String errorHeader = "Get User Saved Posts:";
  try {
    Response response = await dio.get(
      "/auth/saved",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> postList = response.data["payload"] as List<dynamic>;
      List<PostObject> posts = [];
      for (var element in postList) {
        posts.add(processPost(element as Map<String, dynamic>));
      }

      return RedionesResponse(
        message: "Saved Posts Fetched",
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
    log("Get User Saved Posts Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

CommentData _processComment(Map<String, dynamic> result) {
  Map<String, dynamic> user = result["postedBy"] as Map<String, dynamic>;
  processUser(user);
  result["likes"] = fromArrayString(result["likes"] as List<dynamic>);
  return CommentData.fromJson(result);
}

Future<RedionesResponse<List<CommentData>>> getComments(String postID) async {
  if (accessToken == null || postID.contains("Dummy")) {
    return const RedionesResponse(
      message: "",
      payload: [],
      status: Status.success,
    );
  }
  String errorHeader = "Get Comments";
  try {
    Response response = await dio.get(
      "/comments/$postID",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> list = response.data["payload"] as List<dynamic>;
      List<CommentData> comments = [];

      for (var element in list) {
        CommentData comment = _processComment(element as Map<String, dynamic>);
        comments.add(comment);
      }

      return RedionesResponse(
        message: "Comments Fetched",
        payload: comments,
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
    log("Get Comments Error: $e");
  }
  return const RedionesResponse<List<CommentData>>(
    message: "An unknown error occurred. Please try again!",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<CommentData?>> createComment(
  String postID,
  String content,
) async {
  String errorHeader = "Create Comment:";
  try {
    Response response = await dio.post("/comments/",
        data: {"relatedContent": postID, "content": content},
        options: configuration(accessToken!));
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> map = response.data["payload"];
      CommentData data = _processComment(map);
      return RedionesResponse<CommentData>(
        message: "Comment Created",
        payload: data,
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
    log("Create Comment Error: $e");
  }

  return RedionesResponse<CommentData?>(
    message: "$errorHeader An unknown error occurred. Please try again!",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<List<String>>> likePost(String postID) async {
  String errorHeader = "Like Post";
  try {
    Response response = await dio.patch(
      "/post/like/$postID",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> map = response.data["payload"] == null
          ? []
          : response.data["payload"] as List<dynamic>;
      List<String> likes = fromArrayString(map);
      return RedionesResponse<List<String>>(
        message: response.data["message"],
        payload: likes,
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
    log("Like Post Error: $e");
  }

  return RedionesResponse<List<String>>(
    message: "$errorHeader An unknown error occurred. Please try again!",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse> votePoll(String pollOptionID) async {
  String errorHeader = "Vote Poll:";
  try {
    Response response = await dio.patch(
      "/post/vote/$pollOptionID",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      return const RedionesResponse(
        message: "",
        payload: null,
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
    log("Vote Poll Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again!",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<List<String>>> savePost(String postID) async {
  String errorHeader = "Save Posts:";

  try {
    Response response = await dio.patch(
      "/post/save/$postID",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> map = response.data["payload"] == null
          ? []
          : response.data["payload"] as List<dynamic>;
      List<String> saved = fromArrayString(map);
      return RedionesResponse(
        message: response.data["message"],
        payload: saved,
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
    log("Save Post Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again!",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse> delete(String postID) async {
  String errorHeader = "Delete Post:";

  try {
    Response response = await dio.delete(
      "/post/delete/$postID",
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      log(response.data.toString());
      return const RedionesResponse(
        message: "Deleted Successfully",
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
    log("Delete Post Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again!",
    payload: null,
    status: Status.failed,
  );
}
