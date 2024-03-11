import 'package:rediones/api/base.dart';
import 'package:rediones/components/event_data.dart';
import 'package:rediones/api/profile_service.dart';

export 'package:rediones/api/base.dart' show RedionesResponse, Status;


Future<RedionesResponse<EventData?>> createEvent(Map<String, dynamic> data) async
{
  try
  {
    Response response = await dio.post("/events/",
        data: data, options: configuration(accessToken!));

    if(response.statusCode! >= 200 && response.statusCode! < 400) {

      Map<String, dynamic> result = response.data["payload"] as Map<String, dynamic>;
      EventData event = _processEvent(result);
      return RedionesResponse(message: "Event Created", payload: event, status: Status.success);
    }
  }
  catch(e)
  {
    log(e.toString());
  }

  return const RedionesResponse(message: "An error occurred. Please try again.", payload: null, status: Status.failed);
}

EventData _processEvent(Map<String, dynamic> result)
{
  Map<String, dynamic> user = result["postedBy"] as Map<String, dynamic>;
  processUser(user);

  result["postedBy"] = user;
  result["interested"] = fromArrayString(result["interested"] as List<dynamic>);
  result["going"] = fromArrayString(result["going"] as List<dynamic>);
  result["categories"] = fromArrayString(result["categories"] as List<dynamic>);

  return EventData.fromJson(result);
}

Future<RedionesResponse<List<EventData>>> getEvents() async {
  try
  {
    Response response = await dio.get("/events/", options: configuration(accessToken!));

    if(response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> eventList = response.data["payload"] as List<dynamic>;
      List<EventData> events = [];
      for (var element in eventList) {
        events.add(_processEvent(element as Map<String, dynamic>));
      }

      return RedionesResponse(message: "Events Fetched", payload: events, status: Status.success);
    }
  }
  catch(e)
  {
    log(e.toString());
  }

  return const RedionesResponse(message: "An error occurred. Please try again.", payload: [], status: Status.failed);

}