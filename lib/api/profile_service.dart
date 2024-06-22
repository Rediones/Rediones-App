import 'package:rediones/api/base.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';

export 'package:rediones/api/base.dart' show RedionesResponse, Status;
//ignore_for_file: empty_catches

String? accessToken;

Future<RedionesResponse<User?>> authenticate(
    Map<String, String> authDetails, String authPath) async {
  bool isLogin = authPath == Pages.login;
  String errorHeader = "Authentication:";
  try {
    Response response = await dio.post(
      "/auth/${isLogin ? "sign-in" : "sign-up"}",
      data: authDetails,
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
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
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: null,
      status: Status.failed,
    );
  } catch (e) {
    log("Authentication Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again later.",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse> followUser(String userID) async {
  String errorHeader = "Follow User:";
  try {
    Response response = await dio.post("/auth/follow-user",
        data: {
          "userId": userID,
        },
        options: configuration(accessToken!));

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      log(response.data.toString());

      return const RedionesResponse(
        message: "Posts Fetched",
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
    log("Follow User Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again later.",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<User?>> updateUser(Map<String, dynamic> data) async {
  String errorHeader = "Update User:";
  try {
    Response response = await dio.patch(
      "/auth/update-profile",
      data: data,
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> processedUser =
          response.data["payload"] as Map<String, dynamic>;
      processUser(processedUser);
      User user = User.fromJson(processedUser);
      return RedionesResponse(
        message: "Successful",
        payload: user,
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
    log("Update User Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again later.",
    payload: null,
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
  data["profilePicture"] ??=
      "https://gravatar.com/avatar/${data["_id"].hashCode.toString()}?s=400&d=robohash&r=x";

  data["following"] = fromArrayString(data["following"]);
  data["followers"] = fromArrayString(data["followers"]);
  data["saved"] = fromArrayString(data["saved"]);
}

List<User> processUsers(List<dynamic> list) {
  List<User> result = [];
  for (Map<String, dynamic> element in list) {
    processUser(element);
    User user = User.fromJson(element);
    result.add(user);
  }
  return result;
}
