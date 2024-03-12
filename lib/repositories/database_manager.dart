import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:rediones/repositories/post_repository.dart';
import 'package:rediones/repositories/user_repository.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DatabaseManager {
  static Future initialize() async {
    await _initSembast();
    _registerRepositories();
  }

  static Future _initSembast() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, "rediones.db");
    final database = await databaseFactoryIo.openDatabase(databasePath);
    GetIt.I.registerSingleton<Database>(database);
  }


  static _registerRepositories(){
    GetIt.I.registerLazySingleton<PostRepository>(() => PostRepository());
    GetIt.I.registerLazySingleton<UserRepository>(() => UserRepository());
  }
}