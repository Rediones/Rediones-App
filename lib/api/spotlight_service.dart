import 'package:rediones/api/profile_service.dart';
import 'package:rediones/components/spotlight_data.dart';

import 'base.dart';

export 'base.dart';

Future<RedionesResponse<List<SpotlightData>>> getAllSpotlights() async {
  String errorHeader = "Get All Spotlights:";
  try {
    Response response = await dio.get(
      "/spotlights/all",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> data = response.data["payload"] as List<dynamic>;
      List<SpotlightData> spotlights = [];
      log(data.toString());
      for (var element in data) {
        processUser(element["postedBy"]);
        element["likes"] = fromArrayString(element["likes"]);
        SpotlightData spotlight = SpotlightData.fromJson(element);
        spotlights.add(spotlight);
      }
      return RedionesResponse(
        message: "Successful",
        payload: spotlights,
        status: Status.success,
      );
      ;
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: [],
      status: Status.failed,
    );
  } catch (e) {
    log("Get Spotlight Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again later.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse> createSpotlight(
    {required String data, String name = "", String extension = ""}) async {
  String errorHeader = "Create Spotlight:";
  try {
    Response response = await dio.post(
      "/spotlights/create",
      data: {
        "link": {
          "base64": data,
        },
      },
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      log(response.data.toString());
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: null,
      status: Status.failed,
    );
  } catch (e) {
    log("Create Spotlight Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again!",
    payload: null,
    status: Status.failed,
  );
}

Future<RedionesResponse<List<String>>> likeSpotlight(String spotlightID) async {
  String errorHeader = "Like Spotlight:";
  try {
    Response response = await dio.patch(
      "/spotlights/like/$spotlightID",
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
  }  on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: [],
      status: Status.failed,
    );
  }  catch (e) {
    log("Like Spotlight Error: $e");
  }

  return RedionesResponse<List<String>>(
    message: "$errorHeader An error occurred. Please try again!",
    payload: [],
    status: Status.failed,
  );
}
