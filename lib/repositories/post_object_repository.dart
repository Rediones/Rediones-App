import 'dart:developer' show log;

import 'package:rediones/components/poll_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/repositories/poll_repository.dart';
import 'package:rediones/repositories/post_repository.dart';

class PostObjectRepository {
  final PostRepository postRepository = PostRepository();
  final PollRepository pollRepository = PollRepository();

  Future<List<PostObject>> getAll(
      {String? where, List<String>? whereArgs, String? orderBy}) async {
    List<PostObject> posts = await postRepository.getAll(
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );

    List<PostObject> polls = await pollRepository.getAll(
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );

    List<PostObject> response = [];
    response.addAll(posts);
    response.addAll(polls);

    response.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return response;
  }

  Future<void> add(PostObject object) async {
    if (object is Post) {
      await postRepository.add(object);
    } else if (object is PollData) {
      await pollRepository.add(object);
    }
  }

  Future<void> addAll(List<PostObject> objects) async {
    List<Post> posts = [];
    List<PollData> polls = [];

    for(var object in objects) {
      if(object is Post) {
        posts.add(object);
      } else if(object is PollData) {
        polls.add(object);
      }
    }

    await postRepository.addAll(posts);
    await pollRepository.addAll(polls);
  }

  Future<void> deleteAll() async {
    await postRepository.deleteAll();
    await pollRepository.deleteAll();
  }

  Future<void> clearAllAndAddAll(List<PostObject> objects) async {
    await deleteAll();
    await addAll(objects);
  }
}
