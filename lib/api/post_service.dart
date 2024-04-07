import 'dart:async';
import 'dart:convert';

import 'package:rediones/api/base.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/comment_data.dart';
import 'package:rediones/api/profile_service.dart';

export 'package:rediones/api/base.dart' show RedionesResponse, Status;

Future<RedionesResponse<Post?>> createPost(Map<String, dynamic> data) async {
  try {
    Response response = await dio.post("/post/create-post",
        data: data, options: configuration(accessToken!));

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> result =
          response.data["payload"] as Map<String, dynamic>;
      Post post = processPost(result);
      return RedionesResponse(
          message: "Post Created", payload: post, status: Status.success);
    }
  } catch (e) {
    log("Create Post Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}

Post processPost(Map<String, dynamic> result) {
  Map<String, dynamic> user = result["postedBy"] as Map<String, dynamic>;
  processUser(user);

  result["postedBy"] = user;
  result["category"] = (result["category"] as num).toInt();
  result["likes"] = fromArrayString(result["likes"] as List<dynamic>);
  result["media"] = fromArrayString(result["media"] as List<dynamic>);

  //log("$result");

  return Post.fromJson(result);
}

Future<RedionesResponse<List<Post>>> getPosts() async {
  try {
    Response response =
        await dio.get("/posts/all", options: configuration(accessToken!));

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> postList = response.data["payload"] as List<dynamic>;
      List<Post> posts = [];
      for (var element in postList) {
        posts.add(processPost(element as Map<String, dynamic>));
      }

      return RedionesResponse(
          message: "Posts Fetched", payload: posts, status: Status.success);
    }
  } catch (e) {
    log("Get Posts Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<List<Post>>> getUsersPosts({required String id}) async {
  try {
    Response response = await dio.post("/post/get-post-by-user",
        data: {"userId": id}, options: configuration(accessToken!));

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> postList = response.data["payload"] as List<dynamic>;
      List<Post> posts = [];
      for (var element in postList) {
        posts.add(processPost(element as Map<String, dynamic>));
      }

      return RedionesResponse(
          message: "Posts Fetched", payload: posts, status: Status.success);
    }
  } catch (e) {
    log("Get User Posts Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<List<Post>>> getUsersSavedPosts() async {
  try {
    Response response =
        await dio.get("/auth/saved", options: configuration(accessToken!));

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> postList = response.data["payload"] as List<dynamic>;
      List<Post> posts = [];
      for (var element in postList) {
        posts.add(processPost(element as Map<String, dynamic>));
      }

      return RedionesResponse(
        message: "Saved Posts Fetched",
        payload: posts,
        status: Status.success,
      );
    }
  } catch (e) {
    log("Get User Saved Posts Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again.",
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
  try {
    Response response = await dio.get("/comments/$postID",
        options: configuration(accessToken!));
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
          status: Status.success);
    }
  } catch (e) {
    log("Get Comments Error: $e");
  }
  return const RedionesResponse<List<CommentData>>(
    message: "An error occurred. Please try again!",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<CommentData?>> createComment(
    String postID, String content) async {
  try {
    Response response = await dio.post("/comments/",
        data: {"relatedContent": postID, "content": content},
        options: configuration(accessToken!));
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> map = response.data["payload"];
      CommentData data = _processComment(map);
      return RedionesResponse<CommentData>(
          message: "Comment Created", payload: data, status: Status.success);
    }
  } catch (e) {
    log("Create Comment Error: $e");
  }

  return const RedionesResponse<CommentData?>(
    message: "An error occurred. Please try again!",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<List<String>>> likePost(String postID) async {
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
          status: Status.success);
    }
  } catch (e) {
    log("Like Post Error: $e");
  }

  return const RedionesResponse<List<String>>(
    message: "An error occurred. Please try again!",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<List<String>>> savePost(String postID) async {
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
  } catch (e) {
    log("Save Post Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again!",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse> delete(String postID) async {
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
          status: Status.success);
    }
  } catch (e) {
    log("Delete Post Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again!",
    payload: null,
    status: Status.failed,
  );
}
