import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PocketData extends Equatable {
  final DateTime created;
  final DateTime dateDue;
  final TimeOfDay timeDue;
  final String heading;
  final String content;
  final String id;

  const PocketData({
    required this.created,
    required this.dateDue,
    required this.timeDue,
    required this.heading,
    required this.content,
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class StickyData extends Equatable {
  final DateTime created;
  final DateTime dateDue;
  final String heading;
  final String content;
  final String id;

  const StickyData({
    required this.created,
    required this.dateDue,
    required this.heading,
    required this.content,
    required this.id,
  });

  @override
  List<Object?> get props => [id];


  factory StickyData.fromJson(Map<String, dynamic> map) =>
      StickyData(created: DateTime.parse(map["createdAt"]),
          dateDue: DateTime(2025),
          heading: map["header"] ?? "",
          content: map["text"] ?? "",
          id: map["_id"],
      );
}


class PocketMessageData {
  final String? text;
  final String? image;
  final String id;

  const PocketMessageData({
    this.text,
    this.image,
    required this.id,
  });


  factory PocketMessageData.fromJson(Map<String, dynamic> map ) => PocketMessageData(id: map["_id"], text: map["text"]);
}
