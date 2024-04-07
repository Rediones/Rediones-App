import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

import 'package:rediones/components/user_data.dart';

class UserRepository {
  final Database _database = GetIt.I.get();
  final StoreRef _store = stringMapStoreFactory.store("user_store");

  Future addUser(User user) async {
    return await _store.record(user.id).add(_database, user.toJson());
  }

  Future updateUser(User user) async {
    await _store.record(user.id).put(_database, user.toJson());
  }

  Future deleteUser(String userId) async {
    await _store.record(userId).delete(_database);
  }

  Future<List<User>> getAllUsers() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map(
            (snapshot) => User.fromJson(snapshot.value as Map<String, dynamic>))
        .toList(growable: false);
  }
}
