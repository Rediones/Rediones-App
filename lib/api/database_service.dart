import 'package:path/path.dart';
import 'package:rediones/api/base.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;
  bool ready = false;

  DatabaseService() {
    _init();
  }

  static _init() => _openDB().then((db) => _database = db);

  static Future<Database> _openDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "database.db");
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
   CREATE TABLE Users (
     id VARCHAR(255) PRIMARY KEY,
     profilePicture TEXT,
     email TEXT,
     nickname TEXT,
     firstName TEXT,
     lastName TEXT,
     otherName TEXT,
     school TEXT,
     address TEXT,
     description TEXT,
     gender TEXT,
     level TEXT
   )
 ''');

        await db.execute('''
   CREATE TABLE Followers (
     id VARCHAR(255) PRIMARY KEY,
     userId VARCHAR(255),
     FOREIGN KEY(userId) REFERENCES Users(id)
   )
 ''');

        await db.execute('''
   CREATE TABLE Following (
     id VARCHAR(255) PRIMARY KEY,
     userId VARCHAR(255),
     FOREIGN KEY(userId) REFERENCES Users(id)
   )
 ''');

        await db.execute('''
    CREATE TABLE Likes (
      id VARCHAR(255) PRIMARY KEY,
      like TEXT,
      postId VARCHAR(255),
      FOREIGN KEY(postId) REFERENCES Posts(id)
    )
''');

        await db.execute(''' 
    CREATE TABLE Media (
      id VARCHAR(255) PRIMARY KEY,
      media TEXT,
      postId VARCHAR(255),
      FOREIGN KEY(postId) REFERENCES Posts(id)
    )
''');

        await db.execute('''
     CREATE TABLE Posts (
        id VARCHAR(255) PRIMARY KEY,
        text TEXT,
        postCategory INT,
        posterId VARCHAR(255),
        shares INT,
        timestamp TIMESTAMP,
        FOREIGN KEY(posterId) REFERENCES Users(id)
    )
''');
      },
    );
  }


  static Future<void> addUser(User user) async {
    if(_database == null) {
      _init();
    }

    await _database?.insert(
      'Users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    Batch? batch = _database?.batch();
    for (String followerId in user.followers) {
      batch?.insert(
        'Followers',
        {'userId': user.id, 'id': followerId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    batch?.commit(noResult: true);

    batch = _database?.batch();
    for (final followingId in user.following) {
      batch?.insert(
        'Following',
        {'userId': user.id, 'id': followingId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    batch?.commit(noResult: true);
  }


}
