import 'base_repository.dart';

class ObjectPair<F, S> {
  final F f;
  final S s;
  final String reference;

  const ObjectPair({
    required this.f,
    required this.s,
    required this.reference,
  });

  static const String firstColumn = "first";
  static const String secondColumn = "second";
  static const String referenceColumn = "reference";

  factory ObjectPair.fromJson(Map<String, dynamic> map) => ObjectPair(
        reference: map[referenceColumn],
        f: map[firstColumn],
        s: map[secondColumn],
      );

  Map<String, dynamic> toJson() => {
        referenceColumn: reference,
        firstColumn: f,
        secondColumn: s,
      };
}

class ObjectPairRepository<F, S> extends BaseRepository<ObjectPair<F, S>> {
  final String tableName;

  ObjectPairRepository({required this.tableName});

  @override
  Future<ObjectPair<F, S>> fromJson(Map<String, dynamic> map) async =>
      ObjectPair.fromJson(map);

  @override
  String get table => tableName;

  @override
  Future<Map<String, dynamic>> toJson(ObjectPair<F, S> value) async =>
      value.toJson();
}