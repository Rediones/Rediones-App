// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPollCollection on Isar {
  IsarCollection<Poll> get polls => this.collection();
}

const PollSchema = CollectionSchema(
  name: r'Poll',
  id: 2721311222307943076,
  properties: {
    r'comments': PropertySchema(
      id: 0,
      name: r'comments',
      type: IsarType.long,
    ),
    r'durationInHours': PropertySchema(
      id: 1,
      name: r'durationInHours',
      type: IsarType.long,
    ),
    r'likes': PropertySchema(
      id: 2,
      name: r'likes',
      type: IsarType.stringList,
    ),
    r'pollID': PropertySchema(
      id: 3,
      name: r'pollID',
      type: IsarType.string,
    ),
    r'polls': PropertySchema(
      id: 4,
      name: r'polls',
      type: IsarType.objectList,
      target: r'PollChoice',
    ),
    r'posterID': PropertySchema(
      id: 5,
      name: r'posterID',
      type: IsarType.string,
    ),
    r'posterName': PropertySchema(
      id: 6,
      name: r'posterName',
      type: IsarType.string,
    ),
    r'posterPicture': PropertySchema(
      id: 7,
      name: r'posterPicture',
      type: IsarType.string,
    ),
    r'posterUsername': PropertySchema(
      id: 8,
      name: r'posterUsername',
      type: IsarType.string,
    ),
    r'saved': PropertySchema(
      id: 9,
      name: r'saved',
      type: IsarType.stringList,
    ),
    r'shares': PropertySchema(
      id: 10,
      name: r'shares',
      type: IsarType.long,
    ),
    r'text': PropertySchema(
      id: 11,
      name: r'text',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 12,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'totalVotes': PropertySchema(
      id: 13,
      name: r'totalVotes',
      type: IsarType.long,
    ),
    r'uuid': PropertySchema(
      id: 14,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _pollEstimateSize,
  serialize: _pollSerialize,
  deserialize: _pollDeserialize,
  deserializeProp: _pollDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'posterID': IndexSchema(
      id: -165509240594948126,
      name: r'posterID',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'posterID',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'PollChoice': PollChoiceSchema},
  getId: _pollGetId,
  getLinks: _pollGetLinks,
  attach: _pollAttach,
  version: '3.1.0+1',
);

int _pollEstimateSize(
  Poll object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.likes.length * 3;
  {
    for (var i = 0; i < object.likes.length; i++) {
      final value = object.likes[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.pollID.length * 3;
  bytesCount += 3 + object.polls.length * 3;
  {
    final offsets = allOffsets[PollChoice]!;
    for (var i = 0; i < object.polls.length; i++) {
      final value = object.polls[i];
      bytesCount += PollChoiceSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.posterID.length * 3;
  bytesCount += 3 + object.posterName.length * 3;
  bytesCount += 3 + object.posterPicture.length * 3;
  bytesCount += 3 + object.posterUsername.length * 3;
  bytesCount += 3 + object.saved.length * 3;
  {
    for (var i = 0; i < object.saved.length; i++) {
      final value = object.saved[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.text.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _pollSerialize(
  Poll object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.comments);
  writer.writeLong(offsets[1], object.durationInHours);
  writer.writeStringList(offsets[2], object.likes);
  writer.writeString(offsets[3], object.pollID);
  writer.writeObjectList<PollChoice>(
    offsets[4],
    allOffsets,
    PollChoiceSchema.serialize,
    object.polls,
  );
  writer.writeString(offsets[5], object.posterID);
  writer.writeString(offsets[6], object.posterName);
  writer.writeString(offsets[7], object.posterPicture);
  writer.writeString(offsets[8], object.posterUsername);
  writer.writeStringList(offsets[9], object.saved);
  writer.writeLong(offsets[10], object.shares);
  writer.writeString(offsets[11], object.text);
  writer.writeDateTime(offsets[12], object.timestamp);
  writer.writeLong(offsets[13], object.totalVotes);
  writer.writeString(offsets[14], object.uuid);
}

Poll _pollDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Poll(
    durationInHours: reader.readLongOrNull(offsets[1]) ?? 0,
    likes: reader.readStringList(offsets[2]) ?? const [],
    pollID: reader.readStringOrNull(offsets[3]) ?? "",
    polls: reader.readObjectList<PollChoice>(
          offsets[4],
          PollChoiceSchema.deserialize,
          allOffsets,
          PollChoice(),
        ) ??
        const [],
    posterID: reader.readStringOrNull(offsets[5]) ?? "",
    posterName: reader.readStringOrNull(offsets[6]) ?? "",
    posterPicture: reader.readStringOrNull(offsets[7]) ?? "",
    posterUsername: reader.readStringOrNull(offsets[8]) ?? "",
    shares: reader.readLongOrNull(offsets[10]) ?? 0,
    text: reader.readStringOrNull(offsets[11]) ?? "",
    timestamp: reader.readDateTime(offsets[12]),
    totalVotes: reader.readLongOrNull(offsets[13]) ?? 0,
    uuid: reader.readStringOrNull(offsets[14]) ?? "",
  );
  return object;
}

P _pollDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readStringList(offset) ?? const []) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 4:
      return (reader.readObjectList<PollChoice>(
            offset,
            PollChoiceSchema.deserialize,
            allOffsets,
            PollChoice(),
          ) ??
          const []) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 9:
      return (reader.readStringList(offset) ?? []) as P;
    case 10:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 11:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 14:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pollGetId(Poll object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _pollGetLinks(Poll object) {
  return [];
}

void _pollAttach(IsarCollection<dynamic> col, Id id, Poll object) {}

extension PollQueryWhereSort on QueryBuilder<Poll, Poll, QWhere> {
  QueryBuilder<Poll, Poll, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension PollQueryWhere on QueryBuilder<Poll, Poll, QWhereClause> {
  QueryBuilder<Poll, Poll, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhereClause> posterIDEqualTo(String posterID) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'posterID',
        value: [posterID],
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhereClause> posterIDNotEqualTo(
      String posterID) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'posterID',
              lower: [],
              upper: [posterID],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'posterID',
              lower: [posterID],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'posterID',
              lower: [posterID],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'posterID',
              lower: [],
              upper: [posterID],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhereClause> timestampEqualTo(
      DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhereClause> timestampNotEqualTo(
      DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhereClause> timestampGreaterThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [timestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhereClause> timestampLessThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [],
        upper: [timestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterWhereClause> timestampBetween(
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [lowerTimestamp],
        includeLower: includeLower,
        upper: [upperTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PollQueryFilter on QueryBuilder<Poll, Poll, QFilterCondition> {
  QueryBuilder<Poll, Poll, QAfterFilterCondition> commentsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comments',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> commentsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'comments',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> commentsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'comments',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> commentsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'comments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> durationInHoursEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationInHours',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> durationInHoursGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationInHours',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> durationInHoursLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationInHours',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> durationInHoursBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationInHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'likes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'likes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'likes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'likes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'likes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'likes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'likes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'likes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'likes',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'likes',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'likes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'likes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'likes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'likes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'likes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> likesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'likes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollIDEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pollID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollIDGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pollID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollIDLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pollID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollIDBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pollID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollIDStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pollID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollIDEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pollID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollIDContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pollID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollIDMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pollID',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollIDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pollID',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollIDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pollID',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'polls',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'polls',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'polls',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'polls',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'polls',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'polls',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterIDEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterIDGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posterID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterIDLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posterID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterIDBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posterID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterIDStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'posterID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterIDEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'posterID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterIDContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posterID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterIDMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'posterID',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterIDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterID',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterIDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterID',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posterName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'posterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'posterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posterName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'posterName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterName',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterName',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterPictureEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterPictureGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posterPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterPictureLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posterPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterPictureBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posterPicture',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterPictureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'posterPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterPictureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'posterPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterPictureContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posterPicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterPictureMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'posterPicture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterPictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterPicture',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterPictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterPicture',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterUsernameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterUsernameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posterUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterUsernameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posterUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterUsernameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posterUsername',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterUsernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'posterUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterUsernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'posterUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterUsernameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posterUsername',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterUsernameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'posterUsername',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterUsernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterUsername',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> posterUsernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterUsername',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saved',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saved',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saved',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saved',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'saved',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'saved',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'saved',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'saved',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saved',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'saved',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saved',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saved',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saved',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saved',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saved',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> savedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'saved',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> sharesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shares',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> sharesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shares',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> sharesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shares',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> sharesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shares',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> textContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> textMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> timestampEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> totalVotesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalVotes',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> totalVotesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalVotes',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> totalVotesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalVotes',
        value: value,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> totalVotesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalVotes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> uuidContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> uuidMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<Poll, Poll, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension PollQueryObject on QueryBuilder<Poll, Poll, QFilterCondition> {
  QueryBuilder<Poll, Poll, QAfterFilterCondition> pollsElement(
      FilterQuery<PollChoice> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'polls');
    });
  }
}

extension PollQueryLinks on QueryBuilder<Poll, Poll, QFilterCondition> {}

extension PollQuerySortBy on QueryBuilder<Poll, Poll, QSortBy> {
  QueryBuilder<Poll, Poll, QAfterSortBy> sortByComments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByCommentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByDurationInHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInHours', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByDurationInHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInHours', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByPollID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pollID', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByPollIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pollID', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByPosterID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterID', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByPosterIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterID', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByPosterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterName', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByPosterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterName', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByPosterPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPicture', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByPosterPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPicture', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByPosterUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterUsername', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByPosterUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterUsername', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByShares() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shares', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortBySharesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shares', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByTotalVotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVotes', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByTotalVotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVotes', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PollQuerySortThenBy on QueryBuilder<Poll, Poll, QSortThenBy> {
  QueryBuilder<Poll, Poll, QAfterSortBy> thenByComments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByCommentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByDurationInHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInHours', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByDurationInHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInHours', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByPollID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pollID', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByPollIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pollID', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByPosterID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterID', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByPosterIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterID', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByPosterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterName', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByPosterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterName', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByPosterPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPicture', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByPosterPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPicture', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByPosterUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterUsername', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByPosterUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterUsername', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByShares() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shares', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenBySharesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shares', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByTotalVotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVotes', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByTotalVotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVotes', Sort.desc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Poll, Poll, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PollQueryWhereDistinct on QueryBuilder<Poll, Poll, QDistinct> {
  QueryBuilder<Poll, Poll, QDistinct> distinctByComments() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'comments');
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByDurationInHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInHours');
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByLikes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'likes');
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByPollID(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pollID', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByPosterID(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterID', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByPosterName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByPosterPicture(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterPicture',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByPosterUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterUsername',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctBySaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saved');
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByShares() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shares');
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByTotalVotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalVotes');
    });
  }

  QueryBuilder<Poll, Poll, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension PollQueryProperty on QueryBuilder<Poll, Poll, QQueryProperty> {
  QueryBuilder<Poll, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Poll, int, QQueryOperations> commentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'comments');
    });
  }

  QueryBuilder<Poll, int, QQueryOperations> durationInHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInHours');
    });
  }

  QueryBuilder<Poll, List<String>, QQueryOperations> likesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'likes');
    });
  }

  QueryBuilder<Poll, String, QQueryOperations> pollIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pollID');
    });
  }

  QueryBuilder<Poll, List<PollChoice>, QQueryOperations> pollsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'polls');
    });
  }

  QueryBuilder<Poll, String, QQueryOperations> posterIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterID');
    });
  }

  QueryBuilder<Poll, String, QQueryOperations> posterNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterName');
    });
  }

  QueryBuilder<Poll, String, QQueryOperations> posterPictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterPicture');
    });
  }

  QueryBuilder<Poll, String, QQueryOperations> posterUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterUsername');
    });
  }

  QueryBuilder<Poll, List<String>, QQueryOperations> savedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saved');
    });
  }

  QueryBuilder<Poll, int, QQueryOperations> sharesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shares');
    });
  }

  QueryBuilder<Poll, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<Poll, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<Poll, int, QQueryOperations> totalVotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalVotes');
    });
  }

  QueryBuilder<Poll, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PollChoiceSchema = Schema(
  name: r'PollChoice',
  id: -9079078986644833225,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 1,
      name: r'uuid',
      type: IsarType.string,
    ),
    r'voters': PropertySchema(
      id: 2,
      name: r'voters',
      type: IsarType.stringList,
    )
  },
  estimateSize: _pollChoiceEstimateSize,
  serialize: _pollChoiceSerialize,
  deserialize: _pollChoiceDeserialize,
  deserializeProp: _pollChoiceDeserializeProp,
);

int _pollChoiceEstimateSize(
  PollChoice object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  bytesCount += 3 + object.voters.length * 3;
  {
    for (var i = 0; i < object.voters.length; i++) {
      final value = object.voters[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _pollChoiceSerialize(
  PollChoice object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
  writer.writeString(offsets[1], object.uuid);
  writer.writeStringList(offsets[2], object.voters);
}

PollChoice _pollChoiceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PollChoice(
    name: reader.readStringOrNull(offsets[0]) ?? "",
    uuid: reader.readStringOrNull(offsets[1]) ?? "",
    voters: reader.readStringList(offsets[2]) ?? const [],
  );
  return object;
}

P _pollChoiceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 2:
      return (reader.readStringList(offset) ?? const []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PollChoiceQueryFilter
    on QueryBuilder<PollChoice, PollChoice, QFilterCondition> {
  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> uuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'voters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'voters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'voters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'voters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'voters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'voters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'voters',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voters',
        value: '',
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'voters',
        value: '',
      ));
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voters',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition> votersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voters',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voters',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voters',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voters',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PollChoice, PollChoice, QAfterFilterCondition>
      votersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'voters',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PollChoiceQueryObject
    on QueryBuilder<PollChoice, PollChoice, QFilterCondition> {}
