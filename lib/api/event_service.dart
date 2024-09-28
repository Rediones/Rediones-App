import 'package:rediones/api/base.dart';
import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/event_data.dart';

export 'package:rediones/api/base.dart' show RedionesResponse, Status;

Future<RedionesResponse> createEvent(
    Map<String, dynamic> data) async {
  String errorHeader = "Create Event:";
  try {
    Response response = await dio.post(
      "/events/",
      data: data,
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      return const RedionesResponse(
        message: "Event Created",
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
    log("Create Event Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}

EventData _processEvent(Map<String, dynamic> result, String currentUserID) {
  Map<String, dynamic> user = result["postedBy"] as Map<String, dynamic>;
  processUser(user);

  result["postedBy"] = user;
  result["interested"] = fromArrayString(result["interested"] as List<dynamic>);
  result["going"] = fromArrayString(result["going"] as List<dynamic>);
  result["categories"] = fromArrayString(result["categories"] as List<dynamic>);

  int rated = 0, total = 0, count = 0;
  if (currentUserID.isNotEmpty) {
    List<dynamic> ratings = result["ratings"];
    for (var element in ratings) {
      if (element["user"] == currentUserID && rated == 0) {
        rated = element["value"];
      }
      total += element["value"] as int;
    }
    count = ratings.length;
  }

  result["rated"] = rated;
  result["totalRatings"] = total;
  result["count"] = count;

  return EventData.fromJson(result);
}

Future<RedionesResponse<List<EventData>>> getEvents(
    String currentUserID) async {
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
        events
            .add(_processEvent(element as Map<String, dynamic>, currentUserID));
      }

      return RedionesResponse(
        message: "Events Fetched",
        payload: events,
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
      return const RedionesResponse(
        message: "Event Created",
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
    log("Create Event Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse> rateEvent(String eventID, double rating) async {
  String errorHeader = "Rate Event:";
  try {
    Response response = await dio.patch(
      "/events/rate/$eventID",
      data: {
        "rating": rating.toInt(),
      },
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      return const RedionesResponse(
        message: "Event Rated",
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
    log("Create Event Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<List<EventData>>> getAllInterestedEvents(
    String currentUserID) async {
  String errorHeader = "Get Interested Events:";
  try {
    Response response = await dio.get(
      "/events/user-interested",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> eventList = response.data["payload"] as List<dynamic>;
      List<EventData> events = [];
      for (var element in eventList) {
        events
            .add(_processEvent(element as Map<String, dynamic>, currentUserID));
      }

      return RedionesResponse(
        message: "Interested Events Fetched",
        payload: events,
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
    log("Get Interested Events Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again.",
    payload: [],
    status: Status.failed,
  );
}

