import 'package:rediones/components/poll_data.dart';
import 'package:rediones/repositories/base_repository.dart';
import 'package:rediones/repositories/poll_choice_repository.dart';
import 'package:rediones/repositories/string_list_repository.dart';
import 'package:rediones/repositories/user_repository.dart';

class PollRepository extends BaseRepository<PollData> {
  static const String pollsTable = "Polls";
  static const String likesTable = "PollLikes";
  static const String pollsDataTable = "PollsData";

  final StringListModelRepository likesRepository =
      StringListModelRepository(tableName: likesTable);

  final PollChoiceRepository pollChoiceRepository = PollChoiceRepository();
  final UserRepository userRepository = UserRepository();

  @override
  String get table => pollsTable;

  @override
  Future<PollData> fromJson(Map<String, dynamic> map) async {
    var response = await likesRepository.getAll(
      where: "${StringListModel.referenceColumn} = ?",
      whereArgs: [map["serverID"]],
    );
    List<String> likes = response.map((resp) => resp.value).toList();

    List<PollChoice> choices = await pollChoiceRepository
        .getAll(where: "pollID = ?", whereArgs: [map["serverID"]]);

    var poster = await userRepository.getById(map["posterID"]);

    return PollData(
      text: map["content"],
      id: map["serverID"],
      shares: map["shares"],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map["createdAt"]),
      totalVotes: map["votes"],
      polls: choices,
      likes: likes,
      poster: poster!,
    );
  }

  @override
  Future<Map<String, dynamic>> toJson(PollData value) async {
    var response = value.likes
        .map((val) => StringListModel(referenceID: value.id, value: val))
        .toList();

    await likesRepository.addAll(response);
    await pollChoiceRepository.clearAllAndAddAllWhere(
      value.polls,
      where: "pollID = ?",
      whereArgs: [value.id],
    );


    userRepository.add(value.poster);

    return {
      'content': value.text,
      'serverID': value.id,
      'shares': value.shares,
      'createdAt': value.timestamp.millisecondsSinceEpoch,
      'posterID': value.poster.id,
      "votes": value.totalVotes,
    };
  }

  Future<PollData?> getById(String id) async {
    PollData? post = await super.getByIdAndColumn("serverID", id);
    return post;
  }
}
