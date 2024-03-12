import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

import 'package:rediones/components/post_data.dart';

class PostRepository {
  final Database _database = GetIt.I.get();
  final StoreRef _store = stringMapStoreFactory.store("post_store");

  Future addPost(Post post) async {
    return await _store.record(post.id).add(_database, post.toJson());
  }

  Future addPosts(List<Post> posts) async {
    return await _store.records(posts.map((post) => post.id)).add(
        _database, posts.map((post) => post.toJson()).toList(growable: false));
  }

  Future updateCake(Post post) async {
    await _store.record(post.id).update(_database, post.toJson());
  }

  Future deletePost(String postId) async {
    await _store.record(postId).delete(_database);
  }

  Future clearAll() async {
    await _store.drop(_database);
  }

  Future<List<Post>> getAllPosts() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map(
            (snapshot) => Post.fromJson(snapshot.value as Map<String, dynamic>))
        .toList(growable: false);
  }
}
