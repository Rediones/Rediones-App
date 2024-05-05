import 'package:equatable/equatable.dart';

import 'user_data.dart';

enum Type { task, information }

class NotificationData extends Equatable {
  final String id;
  final String header;
  final String content;
  final DateTime date;
  final User postedBy;


  bool opened;

  NotificationData({
    required this.id,
    required this.postedBy,
    this.header = "",
    required this.date,
    this.content = "",
    this.opened = false,
  });

  @override
  List<Object?> get props => [id];

  factory NotificationData.fromJson(Map<String, dynamic> map)
      => NotificationData(
          id: map["_id"],
          header: map["title"],
          content: map["message"],
          postedBy: User.fromJson(map["sentBy"]),
          date: DateTime.parse(map["createdAt"]),
          opened: false
      );

}
