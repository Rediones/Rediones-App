import 'package:rediones/components/postable.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/functions.dart';

import 'package:isar/isar.dart';

part 'poll_data.g.dart';

@embedded
class PollChoice {
  final String uuid;
  final String name;
  final List<String> voters;


  const PollChoice({
    this.uuid = "",
    this.name = "",
    this.voters = const [],
  });

  @override
  String toString() {
    return "Choice { name: $name, id: $uuid, voters: ${voters.length} }";
  }
}

@collection
class Poll extends PostObject {
  final Id id = Isar.autoIncrement;


  final int totalVotes;
  final List<PollChoice> polls;
  final int durationInHours;


  const Poll({
    super.uuid,
    super.text,
    required super.timestamp,
    required super.poster,
    super.likes,
    super.shares,
    this.polls = const [],
    this.totalVotes = 0,
    this.durationInHours = 0,
  });

  @override
  String toString() {
   return "Poll { totalVotes: $totalVotes, text: $text: polls: $polls }";
  }


  factory Poll.fromJson(Map<String, dynamic> map) {
    Map<String, dynamic> poll = map["poll"];

    List<PollChoice> choices = [];
    List<dynamic> options = poll["options"];
    int count = 0;
    for (var element in options) {
      List<String> voters = toStringList(element["voters"]);
      PollChoice choice = PollChoice(
        name: element["title"],
        uuid: element["_id"],
        voters: voters,
      );
      choices.add(choice);
      count += voters.length;
    }

    return Poll(
        timestamp: DateTime.parse(poll["createdAt"]),
        poster: map["postedBy"]["_id"],
        uuid: poll["_id"],
        likes: map["likes"],
        polls: choices,
        shares: 0,
        text: poll["title"],
        totalVotes: count,
        durationInHours: poll["duration"],
    );
  }
}
