import 'package:rediones/api/base.dart';
import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/event_data.dart';

export 'package:rediones/api/base.dart' show RedionesResponse, Status;

Future<RedionesResponse<EventData?>> createEvent(
    Map<String, dynamic> data) async {
  String errorHeader = "Create Event:";
  try {
    Response response = await dio.post(
      "/events/",
      data: data,
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> result =
          response.data["payload"] as Map<String, dynamic>;
      EventData event = _processEvent(result);
      return RedionesResponse(
        message: "Event Created",
        payload: event,
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
    log("Create Event Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}

EventData _processEvent(Map<String, dynamic> result) {
  Map<String, dynamic> user = result["postedBy"] as Map<String, dynamic>;
  processUser(user);

  result["postedBy"] = user;
  result["interested"] = fromArrayString(result["interested"] as List<dynamic>);
  result["going"] = fromArrayString(result["going"] as List<dynamic>);
  result["categories"] = fromArrayString(result["categories"] as List<dynamic>);

  return EventData.fromJson(result);
}

Future<RedionesResponse<List<EventData>>> getEvents() async {
  String errorHeader = "Get Events:";
  try {
    Response response = await dio.get(
      "/events/",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> eventList = response.data["payload"] as List<dynamic>;
      List<EventData> events = [];
      for (var element in eventList) {
        events.add(_processEvent(element as Map<String, dynamic>));
      }

      return RedionesResponse(
        message: "Events Fetched",
        payload: events,
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
    log("Get Events Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse> eventInterest(String eventID, String status) async {
  String errorHeader = "Go/Interested Event:";
  try {
    Response response = await dio.patch(
      "/events/$status/$eventID",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> result = response.data;
      log(result.toString());

      return const RedionesResponse(
        message: "Event Created",
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
    log("Create Event Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}




Future<RedionesResponse> rateEvent(String eventID, int rating) async {
  String errorHeader = "Rate Event:";
  try {
    Response response = await dio.patch(
      "/events/rate/$eventID",
      data: {
        "rating": rating,
      },
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      Map<String, dynamic> result =
      response.data["payload"] as Map<String, dynamic>;
      EventData event = _processEvent(result);
      return RedionesResponse(
        message: "Event Created",
        payload: event,
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
    log("Create Event Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}