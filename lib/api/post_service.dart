import 'dart:async';

import 'package:rediones/api/base.dart';
import 'package:rediones/api/user_service.dart';
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
      message: dioErrorResponse(e),
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
  if (user == null) {
    Map<String, dynamic> user = result["postedBy"] as Map<String, dynamic>;
    processUser(user);

  } else {
    result["postedBy"] = user.toJson();
  }

  result["likes"] = fromArrayString(result["likes"] as List<dynamic>);
  result["saved"] = fromArrayString(result["saved"] as List<dynamic>);

  if (result["type"] == "POST") {
    result["media"] = fromArrayString(result["media"] as List<dynamic>);
    return Post.fromJson(result);
  } else if (result["type"] == "POLL") {
    return Poll.fromJson(result);
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
      message: dioErrorResponse(e),
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

Future<RedionesResponse<PostObject?>> getPostById(String id) async {
  String errorHeader = "Get Post:";

  try {
    Response response = await dio.get(
      "/post/$id",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      PostObject p =
          processPost(response.data["payload"] as Map<String, dynamic>);

      return RedionesResponse(
        message: "Post Fetched",
        payload: p,
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
    log("Get Post by ID Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<List<PostObject>>> getUserPosts(String id) async {
  String errorHeader = "Get User Saved Posts:";
  try {
    Response response = await dio.get(
      "/post/get-post-by-user/$id",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> postList = response.data["payload"] as List<dynamic>;
      List<PostObject> posts = [];
      for (var element in postList) {
        try {
          PostObject post = processPost(element as Map<String, dynamic>);
          posts.add(post);
        } catch (e) {
          log("$errorHeader: $e");
        }
      }

      return RedionesResponse(
        message: "Saved Posts Fetched",
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
    log("Get User Saved Posts Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<List<PostObject>>> getUserSavedPosts() async {
  String errorHeader = "Get User Saved Posts:";
  try {
    Response response = await dio.get(
      "/saved/posts",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> postList = response.data["payload"] as List<dynamic>;
      List<PostObject> posts = [];
      for (var element in postList) {
        element["itemId"]["postedBy"] = element["user"];
        PostObject post =
            processPost(element["itemId"] as Map<String, dynamic>);
        posts.add(post);
      }

      return RedionesResponse(
        message: "Saved Posts Fetched",
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

class CommentInfo {
  final CommentData data;
  final int count;

  const CommentInfo({required this.data, required this.count,});
}

Future<List<CommentData>?> getComments(String postID) async {
  if (accessToken == null || postID.contains("Dummy")) {
    return null;
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

      return comments;
    }
  } on DioException catch (e) {
    return null;
  } catch (e) {
    log("Get Comments Error: $e");
  }
  return null;
}

Future<RedionesResponse<CommentInfo?>> createComment(
  String id,
  String content,
) async {
  String errorHeader = "Create Comment:";
  try {
    Response response = await dio.post("/comments/",
        data: {
          "relatedContent": id,
          "content": content,
        },
        options: configuration(accessToken!));
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      log("${response.data}");
      Map<String, dynamic> map = response.data["payload"]["comment"];
      int noOfComments = response.data["payload"]["noOfComments"];
      CommentData data = _processComment(map);
      return RedionesResponse<CommentInfo>(
        message: "Comment Created",
        payload: CommentInfo(data: data, count: noOfComments,),
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
    log("Create Comment Error: $e");
  }

  return RedionesResponse<CommentInfo?>(
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
      message: dioErrorResponse(e),
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
      message: dioErrorResponse(e),
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

Future<RedionesResponse> savePost(String postID) async {
  String errorHeader = "Save Posts:";

  try {
    Response response = await dio.post(
      "/saved",
      data: {"itemType": "Post", "itemId": postID},
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      // Map<String, dynamic> data = response.data;
      // bool saved = false;
      // if(data["payload"] != null) {
      //   saved = true;
      // }

      return RedionesResponse(
        message: response.data["message"],
        // payload: (savedInitially && !saved) || (!savedInitially && saved),
        payload: null,
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
    log("Save Post Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again!",
    payload: null,
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
      message: dioErrorResponse(e),
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
