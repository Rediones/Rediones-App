import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'base.dart' show imgPrefix, vidPrefix;
export 'package:file_picker/file_picker.dart' show FileType;

class FileHandler
{
  static Future<void> saveAuthDetails(Map<String, String>? auth) async
  {
    SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.setString("user_rediones_email", auth == null ? "" : auth["email"]!);
    await instance.setString("user_rediones_password", auth == null ? "" : auth["password"]!);
  }

  static Future<Map<String, String>?> loadAuthDetails() async
  {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String? email = instance.getString("user_rediones_email");
    String? password = instance.getString("user_rediones_password");

    if(email == null || password == null || email.isEmpty || password.isEmpty) return null;
    return {
      "email" : email,
      "password" : password
    };
  }

  static Future<List<Uint8List>> loadToBytes({FileType type = FileType.custom}) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: type, allowMultiple: true);
    if (result != null)
    {
      List<Uint8List> data = [];
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for(var file in files) {
        data.add(await file.readAsBytes());
      }
      return data;
    }
    return [];
  }


  static Future<List<Uint8List>> loadFilesAsBytes(List<String> extensions, {bool many = true}) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: extensions, type: FileType.custom, allowMultiple: many);
    if (result != null)
    {
      List<Uint8List> data = [];
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for(var file in files) {
        data.add(await file.readAsBytes());
      }
      return data;
    }
    return [];
  }

  static Future<String?> pickFile(String extension) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: [extension], type: FileType.custom, allowMultiple: false);
    if (result != null)
    {
      return result.files.single.path;
    }
    return null;
  }

  static Future<List<String?>> pickFiles(List<String> extensions) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: extensions, type: FileType.custom, allowMultiple: true);
    if (result != null)
    {
      return result.paths;
    }
    return [];
  }



  static Future<Uint8List> convertSingleToData(String path) async => File(path).readAsBytes();


  static List<Uint8List> convertToData(List<String?> data)
  {
    List<Uint8List> response = [];
    for(var path in data)
    {
      File f = File(path!);
      response.add(f.readAsBytesSync());
    }
    return response;
  }

  static List<Uint8List> decodeToBytes(List<String> encodedData)
  {
    List<Uint8List> response = [];
    for(var data in encodedData)
    {
      response.add(base64.decode(data));
    }
    return response;
  }

  static String convertTo64(Uint8List data) => base64.encode(data);

  static Future<SingleFileResponse?> single({List<String> extensions = const [], FileType type = FileType.custom}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: type == FileType.custom ? extensions : null,
      type: type,
      allowMultiple: false,
    );
    if (result != null) {
      return _convert(result.files.single);
    }
    return null;
  }

  static Future<List<SingleFileResponse>?> multiple({List<String> extensions = const [], FileType type = FileType.custom}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: type == FileType.custom ? extensions : null,
      type: type,
      allowMultiple: true,
    );

    if (result != null) {
      List<SingleFileResponse> response = [];
      List<PlatformFile> files = result.files;
      for (PlatformFile file in files) {
        response.add(_convert(file));
      }
      return response;
    }

    return null;
  }

  static SingleFileResponse _convert(PlatformFile file) => SingleFileResponse(
    path: file.path!,
    extension: file.extension!,
    filename: file.name,
    size: file.size,
  );
}


class SingleFileResponse {
  String path;
  String filename;
  String extension;
  int size;

  SingleFileResponse({
    this.path = "",
    this.filename = "",
    this.extension = "",
    this.size = 0,
  });

  @override
  String toString() =>
      "{name: $filename, path: $path, extension: $extension, size: $size}";
}
