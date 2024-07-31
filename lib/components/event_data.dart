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
  final int rated;
  final int totalRatings;
  final int count;
  final double averageRating;
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
    this.count = 0,
    this.rated = 0,
    this.totalRatings = 0,
    this.averageRating = 0.0,
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
        averageRating = (data["averageRating"] as num).toDouble(),
        id = data["_id"],
        count = (data["count"] as num).toInt(),
        totalRatings = (data["totalRatings"] as num).toInt(),
        rated = (data["rated"] as num).toInt(),
        author = User.fromJson(data["postedBy"]),
        time = TimeOfDay.now();
}
