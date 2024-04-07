import 'package:flutter/material.dart' show TimeOfDay;

import 'user_data.dart';

class EventData {
  final String id;
  final String cover;
  final String header;
  final String description;
  final String location;
  final List<String> categories;
  final List<String> going;
  final List<String> interested;
  final DateTime date;
  final TimeOfDay time;
  final double rating;
  final User author;

  const EventData({
    required this.id,
    required this.cover,
    required this.header,
    required this.description,
    required this.location,
    required this.date,
    required this.categories,
    required this.interested,
    required this.going,
    required this.time,
    required this.author,
    this.rating = 0.0,
  });

  EventData.fromJson(Map<String, dynamic> data)
      : cover = data["cover"],
        header = data["title"],
        description = data["description"],
        location = data["location"],
        date = DateTime.parse(data["startDate"]),
        categories = data["categories"],
        interested = data["interested"],
        going = data["going"],
        rating = (data["rating"] as num).toDouble(),
        id = data["_id"],
        author = User.fromJson(data["postedBy"]),
        time = TimeOfDay.now();
}
