import 'package:rediones/components/postable.dart';

class PollChoice {
  final String name;
  final int count;

  const PollChoice({
    this.name = "",
    this.count = 0,
  });
}

class PollData extends PostObject {
  final int totalVotes;
  final List<PollChoice> polls;

  const PollData({
    super.id,
    super.text,
    required super.timestamp,
    required super.poster,
    super.likes,
    super.shares,
    this.polls = const [],
    this.totalVotes = 0,
  });

  @override
  List<Object> get props => [id];
}
