// import 'package:rediones/components/poll_data.dart';
// import 'package:rediones/repositories/base_repository.dart';
// import 'package:rediones/repositories/string_list_repository.dart';
//
// class PollChoiceRepository extends BaseRepository<PollChoice> {
//
//   static const String pollChoicesTable = "PollsChoices";
//   static const String pollVotersTable = "PollsVoters";
//
//   final StringListModelRepository votersRepository = StringListModelRepository(
//       tableName: pollVotersTable);
//
//
//   @override
//   String get table => pollChoicesTable;
//
//
//   @override
//   Future<PollChoice> fromJson(Map<String, dynamic> map) async {
//     var response = await votersRepository.getAll(
//       where: "${StringListModel.referenceColumn} = ?",
//       whereArgs: [map["choiceServerID"]],
//     );
//     List<String> voters = response.map((resp) => resp.value).toList();
//
//     return PollChoice(
//       voters: voters,
//       name: map["title"],
//       uuid: map["choiceServerID"],
//       rootID: map["pollID"],
//     );
//   }
//
//
//   @override
//   Future<Map<String, dynamic>> toJson(PollChoice value) async {
//     var response = value.voters
//         .map((val) => StringListModel(referenceID: value.uuid, value: val))
//         .toList();
//
//     await votersRepository.clearAllAndAddAllWhere(response,
//       whereArgs: [value.uuid],
//       where: "${StringListModel.referenceColumn} = ?",
//     );
//
//     return {
//       'title': value.name,
//       'choiceServerID': value.uuid,
//       'pollID': value.rootID,
//     };
//   }
//
//
// }