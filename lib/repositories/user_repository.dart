import 'package:rediones/components/user_data.dart';
import 'package:rediones/repositories/base_repository.dart';
import 'package:rediones/repositories/string_list_repository.dart';

class UserRepository extends BaseRepository<User> {

  static const String userTable = "Users";

  static const String followerTable = "UserFollowers";
  static const String followingTable = "UserFollowing";
  static const String savedTable = "SavedPosts";

  final StringListModelRepository followersRepository = StringListModelRepository(tableName: followerTable);
  final StringListModelRepository followingRepository = StringListModelRepository(tableName: followingTable);
  final StringListModelRepository savedPostsRepository = StringListModelRepository(tableName: savedTable);


  @override
  String get table => userTable;

  @override
  Future<User> fromJson(Map<String, dynamic> map) async {
    var response = await followersRepository.getAll(
      where: "${StringListModel.referenceColumn} = ?",
      whereArgs: [map["serverID"]]
    );
    List<String> followers = response.map((resp) => resp.value).toList();

    response = await followingRepository.getAll(
      where: "${StringListModel.referenceColumn} = ?",
      whereArgs: [map["serverID"]]
    );
    List<String> following = response.map((resp) => resp.value).toList();

    response = await savedPostsRepository.getAll(
        where: "${StringListModel.referenceColumn} = ?",
        whereArgs: [map["serverID"]]
    );
    List<String> saved = response.map((resp) => resp.value).toList();

    return User(
      uuid: map["serverID"],
      profilePicture: map["profilePicture"],
      email: map["email"],
      nickname: map["nickname"],
      firstName: map["firstName"],
      lastName: map["lastName"],
      otherName: map["otherName"],
      school: map["school"],
      address: map["address"],
      description: map["description"],
      gender: map["gender"],
      followers: followers,
      following: following,
      savedPosts: saved,
    );
  }

  @override
  Future<Map<String, dynamic>> toJson(User value) async {

    var response = value.followers.map((val) => StringListModel(referenceID: value.uuid, value: val)).toList();
    await followersRepository.addAll(response);

    response = value.following.map((val) => StringListModel(referenceID: value.uuid, value: val)).toList();
    await followingRepository.addAll(response);

    response = value.savedPosts.map((val) => StringListModel(referenceID: value.uuid, value: val)).toList();
    await savedPostsRepository.addAll(response);

    return {
      'serverID': value.uuid,
      'profilePicture': value.profilePicture,
      'email': value.email,
      'nickname': value.nickname,
      'firstName': value.firstName,
      'lastName': value.lastName,
      'otherName': value.otherName,
      'school': value.school,
      'address': value.address,
      'description': value.description,
      'gender': value.gender,
    };
  }


  Future<User?> getById(String id) async {
    User? user = await super.getByIdAndColumn("serverID", id);
    return user;
  }
}
