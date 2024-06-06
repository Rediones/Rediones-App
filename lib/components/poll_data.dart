import 'package:rediones/components/postable.dart';
import 'package:rediones/components/user_data.dart';

class PollChoice {
  final String name;
  final int count;
  final String id;

  const PollChoice({
    this.id = "",
    this.name = "",
    this.count = 0,
  });
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
      int votes = element["voters"].length;
      PollChoice choice = PollChoice(
        name: element["title"],
        id: element["_id"],
        count: votes,
      );
      choices.add(choice);
      count += votes;
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
