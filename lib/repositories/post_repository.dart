import 'package:rediones/components/post_data.dart';
import 'package:rediones/repositories/base_repository.dart';
import 'package:rediones/repositories/string_list_repository.dart';
import 'package:rediones/repositories/user_repository.dart';

class PostRepository extends BaseRepository<Post> {

  static const String postsTable = "Posts";

  static const String mediaTable = "PostMedia";
  static const String likesTable = "PostLikes";

  final StringListModelRepository mediaRepository =
      StringListModelRepository(tableName: mediaTable);
  final StringListModelRepository likesRepository =
      StringListModelRepository(tableName: likesTable);

  final UserRepository userRepository = UserRepository();

  @override
  String get table => postsTable;

  @override
  Future<Post> fromJson(Map<String, dynamic> map) async {
    var response = await mediaRepository.getAll(
        where: "${StringListModel.referenceColumn} = ?",
        whereArgs: [map["serverID"]]);
    List<String> media = response.map((resp) => resp.value).toList();

    response = await likesRepository.getAll(
        where: "${StringListModel.referenceColumn} = ?",
        whereArgs: [map["serverID"]]);
    List<String> likes = response.map((resp) => resp.value).toList();

    var poster = await userRepository.getById(map["posterID"]);

    return Post(
      text: map["content"],
      uuid: map["serverID"],
      shares: map["shares"],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map["createdAt"]),
      media: media,
      likes: likes,
      poster: poster!,
    );
  }

  @override
  Future<Map<String, dynamic>> toJson(Post value) async {

    var response = value.likes.map((val) => StringListModel(referenceID: value.uuid, value: val)).toList();
    await likesRepository.addAll(response);

    response = value.media.map((val) => StringListModel(referenceID: value.uuid, value: val)).toList();
    await mediaRepository.addAll(response);

    userRepository.add(value.poster);

    return {
      'content': value.text,
      'serverID': value.uuid,
      'shares': value.shares,
      'createdAt': value.timestamp.millisecondsSinceEpoch,
      'posterID': value.poster.uuid,
    };
  }

  Future<Post?> getById(String id) async {
    Post? post = await super.getByIdAndColumn("serverID", id);
    return post;
  }
}
