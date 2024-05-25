import 'package:get_it/get_it.dart';
import 'package:rediones/repositories/conversation_repository.dart';
import 'package:rediones/repositories/messages_repository.dart';
import 'package:rediones/repositories/poll_repository.dart';
import 'package:rediones/repositories/post_object_repository.dart';
import 'package:rediones/repositories/post_repository.dart';
import 'package:rediones/repositories/string_list_repository.dart';
import 'package:rediones/repositories/user_repository.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static Future<void> init() async {
    Database database = await openDatabase(
      "rediones.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
   CREATE TABLE ${UserRepository.userTable} (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     serverID TEXT NOT NULL,
     profilePicture TEXT NOT NULL,
     email TEXT NOT NULL,
     nickname TEXT NOT NULL,
     firstName TEXT NOT NULL,
     lastName TEXT NOT NULL,
     otherName TEXT NOT NULL,
     school TEXT NOT NULL,
     address TEXT NOT NULL,
     description TEXT NOT NULL,
     gender TEXT NOT NULL
   )
 ''');

        await db.execute('''
   CREATE TABLE ${PostRepository.postsTable} (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     serverID TEXT NOT NULL,
     content TEXT NOT NULL,
     shares INTEGER NOT NULL,
     createdAt INTEGER NOT NULL,
     posterID TEXT NOT NULL
   )
 ''');

        await db.execute('''
   CREATE TABLE ${PollRepository.pollsTable} (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     serverID TEXT NOT NULL,
     votes INTEGER NOT NULL,
     content TEXT NOT NULL,
     shares INTEGER NOT NULL,
     createdAt INTEGER NOT NULL,
     posterID TEXT NOT NULL
   )
 ''');

        await db.execute('''
    CREATE TABLE ${UserRepository.followerTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ${StringListModel.referenceColumn} TEXT NOT NULL,
      ${StringListModel.valueColumn} TEXT NOT NULL
    )
 ''');

        await db.execute('''
    CREATE TABLE ${UserRepository.followingTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ${StringListModel.referenceColumn} TEXT NOT NULL,
      ${StringListModel.valueColumn} TEXT NOT NULL
    )
 ''');

        await db.execute('''
    CREATE TABLE ${UserRepository.savedTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ${StringListModel.referenceColumn} TEXT NOT NULL,
      ${StringListModel.valueColumn} TEXT NOT NULL
    )
 ''');

        await db.execute('''
    CREATE TABLE ${PostRepository.likesTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ${StringListModel.referenceColumn} TEXT NOT NULL,
      ${StringListModel.valueColumn} TEXT NOT NULL
    )
 ''');

        await db.execute('''
    CREATE TABLE ${PollRepository.likesTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ${StringListModel.referenceColumn} TEXT NOT NULL,
      ${StringListModel.valueColumn} TEXT NOT NULL
    )
 ''');

        await db.execute('''
    CREATE TABLE ${PostRepository.mediaTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ${StringListModel.referenceColumn} TEXT NOT NULL,
      ${StringListModel.valueColumn} TEXT NOT NULL
    )
 ''');

        await db.execute('''
    CREATE TABLE ${ConversationRepository.conversationTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
     serverID TEXT NOT NULL,
      lastMessage TEXT NOT NULL,
      firstUser TEXT NOT NULL,
      secondUser TEXT NOT NULL,
      timestamp INTEGER NOT NULL
    )
 ''');

        await db.execute('''
    CREATE TABLE ${MessageRepository.messagesTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
     serverID TEXT NOT NULL,
      content TEXT NOT NULL,
      sentBy TEXT NOT NULL,
      conversationID TEXT NOT NULL,
      createdAt INTEGER NOT NULL
    )
 ''');
      },
    );
    GetIt.I.registerSingleton<Database>(database);
    GetIt.I.registerLazySingleton<UserRepository>(() => UserRepository());
    GetIt.I.registerLazySingleton<PostRepository>(() => PostRepository());
    GetIt.I.registerLazySingleton<PollRepository>(() => PollRepository());
    GetIt.I.registerLazySingleton<PostObjectRepository>(() => PostObjectRepository());
    GetIt.I.registerLazySingleton<ConversationRepository>(
        () => ConversationRepository());
    GetIt.I.registerLazySingleton<MessageRepository>(() => MessageRepository());
  }
}
