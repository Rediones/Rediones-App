import 'package:rediones/components/user_data.dart';
import 'package:rediones/api/base.dart';
import 'package:rediones/tools/constants.dart';

export 'package:rediones/api/base.dart' show RedionesResponse, Status;
//ignore_for_file: empty_catches

String? accessToken;

Future<RedionesResponse<User?>> authenticate(
    Map<String, String> authDetails, String authPath) async {
  bool isLogin = authPath == Pages.login;

  try {
    Response response = await dio.post(
      "/auth/${isLogin ? "sign-in" : "sign-up"}",
      // "/search?q=Hello",
      data: authDetails,
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      if (response.data["payload"] == null) {
        return RedionesResponse(
            message:
                "Could not ${isLogin ? "sign you in" : "sign you up"}. Please try again",
            payload: null,
            status: Status.failed);
      }

      Map<String, dynamic> processedUser =
          response.data["payload"]["user"] as Map<String, dynamic>;
      processUser(processedUser);
      User user = User.fromJson(processedUser);
      accessToken = response.data["payload"]["token"] as String;
      return RedionesResponse(
        message: "Successful",
        payload: user,
        status: Status.success,
      );
    }
  } catch (e) {
    String res = e.toString();
    log(res);
    if (res.contains("403")) {
      return RedionesResponse(
          message: !isLogin
              ? "This username or email already exists"
              : "Incorrect password",
          payload: null,
          status: Status.failed,
      );
    }

    return RedionesResponse(
      message: e.toString(),
      payload: null,
      status: Status.failed,
    );
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again later.",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse> followUser(String userID) async {
  try {
    Response response = await dio.post("/auth/follow-user",
        data: {
          "userId": userID,
        },
        options: configuration(accessToken!));

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      log(response.data.toString());

      return const RedionesResponse(
          message: "Posts Fetched", payload: null, status: Status.success);
    }
  } catch (e) {
    log("Follow User Error: $e");
  }

  return const RedionesResponse(
    message: "An error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<User>> updateUser(
    User oldUser, Map<String, dynamic> data) async {
  try {
    Response response = await dio.patch("/auth/update-profile",
        data: data, options: configuration(accessToken!));

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> processedUser =
          response.data["payload"] as Map<String, dynamic>;
      processUser(processedUser);
      User user = User.fromJson(processedUser);
      return RedionesResponse(
          message: "Successful", payload: user, status: Status.success);
    }
  } catch (e) {
    log(e.toString());
  }

  return RedionesResponse(
    message: "An error occurred. Please try again later.",
    payload: oldUser,
    status: Status.failed,
  );
}

List<String> fromArrayString(List<dynamic> data) {
  List<String> response = [];
  for (var element in data) {
    response.add(element as String);
  }
  return response;
}

void processUser(Map<String, dynamic> data) {
  data["following"] = fromArrayString(data["following"]);
  data["followers"] = fromArrayString(data["followers"]);
  data["saved"] = fromArrayString(data["saved"]);
}


List<User> processUsers(List<dynamic> list) {
  List<User> result = [];
  for(Map<String, dynamic> element in list) {
    processUser(element);
    User user = User.fromJson(element);
    result.add(user);
  }
  return result;
}