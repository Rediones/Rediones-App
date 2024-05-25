import 'package:equatable/equatable.dart';
import 'package:rediones/components/user_data.dart';

abstract class PostObject extends Equatable {
  final String id;
  final String text;

  final User poster;

  final List<String> likes;
  final int shares;
  final DateTime timestamp;

  const PostObject({
    this.id = "",
    this.text = "",
    required this.poster,
    this.likes = const [],
    this.shares = 0,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id];
}
