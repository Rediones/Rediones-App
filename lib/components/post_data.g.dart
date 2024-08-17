// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPostCollection on Isar {
  IsarCollection<Post> get posts => this.collection();
}

const PostSchema = CollectionSchema(
  name: r'Post',
  id: -1683556178151468304,
  properties: {
    r'comments': PropertySchema(
      id: 0,
      name: r'comments',
      type: IsarType.long,
    ),
    r'likes': PropertySchema(
      id: 1,
      name: r'likes',
      type: IsarType.stringList,
    ),
    r'media': PropertySchema(
      id: 2,
      name: r'media',
      type: IsarType.stringList,
    ),
    r'posterID': PropertySchema(
      id: 3,
      name: r'posterID',
      type: IsarType.string,
    ),
    r'posterName': PropertySchema(
      id: 4,
      name: r'posterName',
      type: IsarType.string,
    ),
    r'posterPicture': PropertySchema(
      id: 5,
      name: r'posterPicture',
      type: IsarType.string,
    ),
    r'posterUsername': PropertySchema(
      id: 6,
      name: r'posterUsername',
      type: IsarType.string,
    ),
    r'saved': PropertySchema(
      id: 7,
      name: r'saved',
      type: IsarType.stringList,
    ),
    r'shares': PropertySchema(
      id: 8,
      name: r'shares',
      type: IsarType.long,
    ),
    r'text': PropertySchema(
      id: 9,
      name: r'text',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 10,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(
      id: 11,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _postEstimateSize,
  serialize: _postSerialize,
  deserialize: _postDeserialize,
  deserializeProp: _postDeserializeProp,
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
  embeddedSchemas: {},
  getId: _postGetId,
  getLinks: _postGetLinks,
  attach: _postAttach,
  version: '3.1.0+1',
);

int _postEstimateSize(
  Post object,
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
  bytesCount += 3 + object.media.length * 3;
  {
    for (var i = 0; i < object.media.length; i++) {
      final value = object.media[i];
      bytesCount += value.length * 3;
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

void _postSerialize(
  Post object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.comments);
  writer.writeStringList(offsets[1], object.likes);
  writer.writeStringList(offsets[2], object.media);
  writer.writeString(offsets[3], object.posterID);
  writer.writeString(offsets[4], object.posterName);
  writer.writeString(offsets[5], object.posterPicture);
  writer.writeString(offsets[6], object.posterUsername);
  writer.writeStringList(offsets[7], object.saved);
  writer.writeLong(offsets[8], object.shares);
  writer.writeString(offsets[9], object.text);
  writer.writeDateTime(offsets[10], object.timestamp);
  writer.writeString(offsets[11], object.uuid);
}

Post _postDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Post(
    likes: reader.readStringList(offsets[1]) ?? const [],
    media: reader.readStringList(offsets[2]) ?? const [],
    posterID: reader.readStringOrNull(offsets[3]) ?? "",
    posterName: reader.readStringOrNull(offsets[4]) ?? "",
    posterPicture: reader.readStringOrNull(offsets[5]) ?? "",
    posterUsername: reader.readStringOrNull(offsets[6]) ?? "",
    shares: reader.readLongOrNull(offsets[8]) ?? 0,
    text: reader.readStringOrNull(offsets[9]) ?? "",
    timestamp: reader.readDateTime(offsets[10]),
    uuid: reader.readStringOrNull(offsets[11]) ?? "",
  );
  return object;
}

P _postDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? const []) as P;
    case 2:
      return (reader.readStringList(offset) ?? const []) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    case 8:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 9:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _postGetId(Post object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _postGetLinks(Post object) {
  return [];
}

void _postAttach(IsarCollection<dynamic> col, Id id, Post object) {}

extension PostQueryWhereSort on QueryBuilder<Post, Post, QWhere> {
  QueryBuilder<Post, Post, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Post, Post, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension PostQueryWhere on QueryBuilder<Post, Post, QWhereClause> {
  QueryBuilder<Post, Post, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<Post, Post, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Post, Post, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Post, Post, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Post, Post, QAfterWhereClause> posterIDEqualTo(String posterID) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'posterID',
        value: [posterID],
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterWhereClause> posterIDNotEqualTo(
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

  QueryBuilder<Post, Post, QAfterWhereClause> timestampEqualTo(
      DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterWhereClause> timestampNotEqualTo(
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

  QueryBuilder<Post, Post, QAfterWhereClause> timestampGreaterThan(
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

  QueryBuilder<Post, Post, QAfterWhereClause> timestampLessThan(
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

  QueryBuilder<Post, Post, QAfterWhereClause> timestampBetween(
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

extension PostQueryFilter on QueryBuilder<Post, Post, QFilterCondition> {
  QueryBuilder<Post, Post, QAfterFilterCondition> commentsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comments',
        value: value,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> commentsGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> commentsLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> commentsBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesElementEqualTo(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesElementGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesElementLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesElementBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesElementStartsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesElementEndsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesElementContains(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesElementMatches(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'likes',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> likesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'likes',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> likesLengthEqualTo(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesIsEmpty() {
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesIsNotEmpty() {
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesLengthLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesLengthGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> likesLengthBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'media',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'media',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'media',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'media',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'media',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'media',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'media',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'media',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'media',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'media',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'media',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'media',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'media',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'media',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'media',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> mediaLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'media',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> posterIDEqualTo(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterIDGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterIDLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterIDBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterIDStartsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterIDEndsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterIDContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posterID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> posterIDMatches(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterIDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterID',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> posterIDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterID',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> posterNameEqualTo(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterNameGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterNameLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterNameBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterNameStartsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterNameEndsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterNameContains(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterNameMatches(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterName',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> posterNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterName',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> posterPictureEqualTo(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterPictureGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterPictureLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterPictureBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterPictureStartsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterPictureEndsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterPictureContains(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterPictureMatches(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterPictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterPicture',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> posterPictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterPicture',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> posterUsernameEqualTo(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterUsernameGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterUsernameLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterUsernameBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterUsernameStartsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterUsernameEndsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterUsernameContains(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterUsernameMatches(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> posterUsernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posterUsername',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> posterUsernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posterUsername',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> savedElementEqualTo(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedElementGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedElementLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedElementBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedElementStartsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedElementEndsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedElementContains(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedElementMatches(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saved',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> savedElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'saved',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> savedLengthEqualTo(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedIsEmpty() {
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedIsNotEmpty() {
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedLengthLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedLengthGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> savedLengthBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> sharesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shares',
        value: value,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> sharesGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> sharesLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> sharesBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> textEqualTo(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> textGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> textLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> textBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> textStartsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> textEndsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> textContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> textMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> timestampEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> timestampGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> timestampLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> timestampBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> uuidStartsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> uuidEndsWith(
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

  QueryBuilder<Post, Post, QAfterFilterCondition> uuidContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> uuidMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<Post, Post, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension PostQueryObject on QueryBuilder<Post, Post, QFilterCondition> {}

extension PostQueryLinks on QueryBuilder<Post, Post, QFilterCondition> {}

extension PostQuerySortBy on QueryBuilder<Post, Post, QSortBy> {
  QueryBuilder<Post, Post, QAfterSortBy> sortByComments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByCommentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByPosterID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterID', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByPosterIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterID', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByPosterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterName', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByPosterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterName', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByPosterPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPicture', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByPosterPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPicture', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByPosterUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterUsername', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByPosterUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterUsername', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByShares() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shares', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortBySharesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shares', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PostQuerySortThenBy on QueryBuilder<Post, Post, QSortThenBy> {
  QueryBuilder<Post, Post, QAfterSortBy> thenByComments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByCommentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByPosterID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterID', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByPosterIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterID', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByPosterName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterName', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByPosterNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterName', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByPosterPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPicture', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByPosterPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPicture', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByPosterUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterUsername', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByPosterUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterUsername', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByShares() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shares', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenBySharesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shares', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<Post, Post, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PostQueryWhereDistinct on QueryBuilder<Post, Post, QDistinct> {
  QueryBuilder<Post, Post, QDistinct> distinctByComments() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'comments');
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByLikes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'likes');
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByMedia() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'media');
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByPosterID(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterID', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByPosterName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByPosterPicture(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterPicture',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByPosterUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterUsername',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctBySaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saved');
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByShares() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shares');
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<Post, Post, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension PostQueryProperty on QueryBuilder<Post, Post, QQueryProperty> {
  QueryBuilder<Post, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Post, int, QQueryOperations> commentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'comments');
    });
  }

  QueryBuilder<Post, List<String>, QQueryOperations> likesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'likes');
    });
  }

  QueryBuilder<Post, List<String>, QQueryOperations> mediaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'media');
    });
  }

  QueryBuilder<Post, String, QQueryOperations> posterIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterID');
    });
  }

  QueryBuilder<Post, String, QQueryOperations> posterNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterName');
    });
  }

  QueryBuilder<Post, String, QQueryOperations> posterPictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterPicture');
    });
  }

  QueryBuilder<Post, String, QQueryOperations> posterUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterUsername');
    });
  }

  QueryBuilder<Post, List<String>, QQueryOperations> savedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saved');
    });
  }

  QueryBuilder<Post, int, QQueryOperations> sharesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shares');
    });
  }

  QueryBuilder<Post, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<Post, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<Post, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
