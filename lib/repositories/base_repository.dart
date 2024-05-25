import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseRepository<T> {
  final Database _database = GetIt.I.get();

  String get table;

  Future<void> add(T t) async {
    await _database.insert(
      table,
      await toJson(t),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addAll(List<T> t) async {
    List<Map<String, dynamic>> data = [];
    for (var val in t) {
      data.add(await toJson(val));
    }

    await _database.transaction((txn) async {
      for (var element in data) {
        await txn.insert(table, element,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> updateByIdAndColumn(String id, String column, T t) async {
    await _database.update(
      table,
      await toJson(t),
      where: "$column = ?",
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id, String column) async {
    await _database.delete(
      table,
      where: "$column = ?",
      whereArgs: [id],
    );
  }

  Future<void> clearAllAndAddAll(List<T> t) async {
    await deleteAll();
    await addAll(t);
  }

  Future<void> deleteAllWhere({String where = "", List<String> whereArgs = const []}) async {
    await _database.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<void> deleteAll() async {
    await _database.delete(table);
  }

  Future<T?> getByIdAndColumn(String column, String id) async {
    List<Map<String, dynamic>> response = await _database.query(
      table,
      where: "$column = ?",
      whereArgs: [id],
    );

    if (response.isEmpty) return null;
    return fromJson(response.first);
  }

  Future<List<T>> getAll(
      {String? where, List<String>? whereArgs, String? orderBy}) async {
    List<Map<String, dynamic>> response = await _database.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );

    if (response.isEmpty) return [];

    List<T> t = [];
    for (var element in response) {
      t.add(await fromJson(element));
    }

    return t;
  }

  Future<T> fromJson(Map<String, dynamic> map);

  Future<Map<String, dynamic>> toJson(T value);
}
