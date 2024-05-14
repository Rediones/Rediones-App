import 'package:rediones/repositories/base_repository.dart';

class StringListModel {
  final String value;
  final String referenceID;

  const StringListModel({
    required this.referenceID,
    required this.value,
  });

  static const String referenceColumn = "referenceID";
  static const String valueColumn = "value";

  factory StringListModel.fromJson(Map<String, dynamic> map) =>
      StringListModel(
        referenceID: map[referenceColumn],
        value: map[valueColumn],
      );

  Map<String, dynamic> toJson() => {
        referenceColumn: referenceID,
        valueColumn: value,
      };
}

class StringListModelRepository extends BaseRepository<StringListModel> {
  final String tableName;

  StringListModelRepository({required this.tableName});

  @override
  Future<StringListModel> fromJson(Map<String, dynamic> map) async =>
      StringListModel.fromJson(map);

  @override
  String get table => tableName;

  @override
  Future<Map<String, dynamic>> toJson(StringListModel value) async =>
      value.toJson();
}
