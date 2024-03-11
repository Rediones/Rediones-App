import 'package:rediones/api/profile_service.dart';
import 'package:rediones/components/spotlight_data.dart';

import 'base.dart';

Future<List<SpotlightData>> getAllSpotlights() async {
  try {
    Response response = await dio.get(
      "/spotlights/all",
      options: configuration(accessToken!),
    );

    if(response.statusCode! >= 200 && response.statusCode! < 400) {

      List<dynamic> data = response.data["payload"] as List<dynamic>;
      List<SpotlightData> spotlights = [];
      log(data.toString());
      for(var element in data) {
        processUser(element["postedBy"]);
        element["likes"] = fromArrayString(element["likes"]);
        SpotlightData spotlight = SpotlightData.fromJson(element);
        spotlights.add(spotlight);
      }
      return spotlights;
    }
  } catch (e) {
    log("Get Spotlight Error: $e");
  }

  return [];
}


Future<void> createSpotlight({required String data, String name = "", String extension = ""}) async {
  log("Before sending");
  try {
    Response response = await dio.post(
      "/spotlights/create",
      data: {
        "link" : {
          "name": name,
          "extension": ".$extension",
          "base64": data,
        },
      },
      options: configuration(accessToken!),
    );

    if(response.statusCode! >= 200 && response.statusCode! < 400) {

        log(response.data.toString());

    }
  } catch (e) {
    log("Create Spotlight Error: $e");
  }
  log("Ending sending");
}