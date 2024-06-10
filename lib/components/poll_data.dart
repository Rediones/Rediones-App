import 'package:rediones/components/postable.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/functions.dart';

class PollChoice {
  final String name;
  final List<String> voters;
  final String id;
  final String rootID;

  const PollChoice({
    this.id = "",
    this.rootID = "",
    this.name = "",
    this.voters = const [],
  });

  @override
  String toString() {
    return "Choice {name: $name, id: $id, voters: ${voters.length}";
  }
}

class PollData extends PostObject {
  final int totalVotes;
  final List<PollChoice> polls;
  final int durationInHours;


  const PollData({
    super.id,
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
  List<Object> get props => [id];

  factory PollData.fromJson(Map<String, dynamic> map) {
    Map<String, dynamic> poll = map["poll"];

    List<PollChoice> choices = [];
    List<dynamic> options = poll["options"];
    int count = 0;
    for (var element in options) {
      List<String> voters = toStringList(element["voters"]);
      PollChoice choice = PollChoice(
        name: element["title"],
        id: element["_id"],
        voters: voters,
        rootID: poll["_id"],
      );
      choices.add(choice);
      count += voters.length;
    }

    return PollData(
        timestamp: DateTime.parse(poll["createdAt"]),
        poster: User.fromJson(map["postedBy"]),
        id: poll["_id"],
        likes: map["likes"],
        polls: choices,
        shares: 0,
        text: poll["title"],
        totalVotes: count,
        durationInHours: poll["duration"],
    );
  }
}
