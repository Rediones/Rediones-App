import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/notification_data.dart';

import 'base.dart';
import 'user_service.dart' as ps;

export 'base.dart';

Future<RedionesResponse<List<NotificationData>>> getNotifications() async {
  if (ps.accessToken == null) {
    return const RedionesResponse(
      message: "",
      payload: [],
      status: Status.success,
    );
  }

  String errorHeader = "Get Notification:";

  try {
    Response response = await dio.get(
      "/notifications/",
      options: configuration(ps.accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> data = response.data["payload"] as List<dynamic>;
      List<NotificationData> notifications = [];
      for (var notification in data) {
        NotificationData notificationData = _process(notification);
        notifications.add(notificationData);
      }

      return RedionesResponse(
        message: "Successful",
        payload: notifications,
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
    log("Get Notification Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again!",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse> readNotification(String id) async {
  String errorHeader = "Read Notification:";
  try {
    Response response = await dio.get(
      "/notifications/read/$id",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      return const RedionesResponse(
        message: "Notification Read",
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
    log("Read Notification Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again later.",
    payload: null,
    status: Status.failed,
  );
}

NotificationData _process(Map<String, dynamic> map) {
  Map<String, dynamic> user = map["sentBy"];
  ps.processUser(user);
  map["sentBy"] = user;

  return NotificationData.fromJson(map);
}
