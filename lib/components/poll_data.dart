import 'package:isar/isar.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/tools/functions.dart';

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
  final int totalVotes;
  final List<PollChoice> polls;
  final int durationInHours;
  final String pollID;

  const Poll({
    super.uuid,
    super.text,
    required super.timestamp,
    required super.posterID,
    required super.posterUsername,
    required super.posterName,
    required super.posterPicture,
    super.likes,
    super.shares,
    this.pollID = "",
    this.polls = const [],
    this.totalVotes = 0,
    this.durationInHours = 0,
  });

  @override
  String toString() {
    return "Poll { totalVotes: $totalVotes, text: $text: polls: $polls }";
  }

  Id get isarId => fastHash(uuid);

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
      posterID: map["postedBy"]["_id"],
      posterName:
          "${map["postedBy"]["firstName"]} ${map["postedBy"]["lastName"]}",
      posterPicture: map["postedBy"]["profilePicture"],
      posterUsername: map["postedBy"]["username"],
      uuid: map["_id"],
      likes: map["likes"],
      polls: choices,
      pollID: poll["_id"],
      shares: 0,
      text: poll["title"],
      totalVotes: count,
      durationInHours: poll["duration"],
    );
  }
}
