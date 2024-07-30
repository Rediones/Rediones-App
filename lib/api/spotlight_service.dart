import 'package:rediones/api/user_service.dart';
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
    {required String data, String? caption}) async {
  String errorHeader = "Create Spotlight:";

  Map<String, dynamic> map = {
    "link": {
      "base64": data,
    },
  };
  if (caption != null) {
    map["caption"] = caption;
  }

  try {
    Response response = await dio.post(
      "/spotlights/create",
      data: map,
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      return const RedionesResponse(
        message: "Success",
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
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: [],
      status: Status.failed,
    );
  } catch (e) {
    log("Like Spotlight Error: $e");
  }

  return RedionesResponse<List<String>>(
    message: "$errorHeader An error occurred. Please try again!",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<List<SpotlightData>>> getUserSpotlights(String userID) async {
  String errorHeader = "Get User Spotlights:";
  try {
    Response response = await dio.get(
      "/spotlights/all/$userID",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> data = response.data["payload"] as List<dynamic>;
      List<SpotlightData> spotlights = [];
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
    }
  } on DioException catch (e) {
    return RedionesResponse(
      message: dioErrorResponse(errorHeader, e),
      payload: [],
      status: Status.failed,
    );
  } catch (e) {
    log("Get User Spotlights Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again later.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse<List<SpotlightData>>> getCurrentSavedSpotlights() async {
  String errorHeader = "Get Saved Spotlights:";
  try {
    Response response = await dio.get(
      "/saved/spotlights",
      options: configuration(accessToken!),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      List<dynamic> data = response.data["payload"] as List<dynamic>;
      List<SpotlightData> spotlights = [];
      for (var element in data) {
        processUser(element["user"]);
        element["itemId"]["likes"] = fromArrayString(element["itemId"]["likes"]);
        element["itemId"]["postedBy"] = element["user"];
        SpotlightData spotlight = SpotlightData.fromJson(element["itemId"]);
        spotlights.add(spotlight);
      }
      return RedionesResponse(
        message: "Successful",
        payload: spotlights,
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
    log("Get Saved Spotlights Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again later.",
    payload: [],
    status: Status.failed,
  );
}

Future<RedionesResponse> saveSpotlight(String spotlightID) async {
  String errorHeader = "Save Spotlight:";

  try {
    Response response = await dio.post(
      "/saved",
      data: {"itemType": "Spotlight", "itemId": spotlightID},
      options: configuration(accessToken!),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      return RedionesResponse(
        message: response.data["message"],
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
    log("Save Post Error: $e");
  }

  return RedionesResponse(
    message: "$errorHeader An unknown error occurred. Please try again!",
    payload: null,
    status: Status.failed,
  );
}
