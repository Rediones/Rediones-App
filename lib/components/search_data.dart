

import 'package:isar/isar.dart';
import 'package:rediones/tools/functions.dart';

part 'search_data.g.dart';

@collection
class SearchData {
  final String search;

  const SearchData({this.search = ""});

  Id get isarId => fastHash(search);
}