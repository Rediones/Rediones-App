import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rediones/components/poll_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/search_data.dart';
import 'package:rediones/components/user_data.dart';

class DatabaseManager {
  static Future<void> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Isar isar = await Isar.open(
      [UserSchema, PollSchema, PostSchema, SearchDataSchema,],
      directory: dir.path,
    );
    GetIt.I.registerSingleton<Isar>(isar);
  }

  static Future<void> clearDatabase() async {
    Isar isar = GetIt.I.get();
    isar.clear();
  }
}
