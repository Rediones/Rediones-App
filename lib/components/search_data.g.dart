// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSearchDataCollection on Isar {
  IsarCollection<SearchData> get searchDatas => this.collection();
}

const SearchDataSchema = CollectionSchema(
  name: r'SearchData',
  id: -4992707760093786274,
  properties: {
    r'search': PropertySchema(
      id: 0,
      name: r'search',
      type: IsarType.string,
    )
  },
  estimateSize: _searchDataEstimateSize,
  serialize: _searchDataSerialize,
  deserialize: _searchDataDeserialize,
  deserializeProp: _searchDataDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _searchDataGetId,
  getLinks: _searchDataGetLinks,
  attach: _searchDataAttach,
  version: '3.1.0+1',
);

int _searchDataEstimateSize(
  SearchData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.search.length * 3;
  return bytesCount;
}

void _searchDataSerialize(
  SearchData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.search);
}

SearchData _searchDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SearchData(
    search: reader.readStringOrNull(offsets[0]) ?? "",
  );
  return object;
}

P _searchDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _searchDataGetId(SearchData object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _searchDataGetLinks(SearchData object) {
  return [];
}

void _searchDataAttach(IsarCollection<dynamic> col, Id id, SearchData object) {}

extension SearchDataQueryWhereSort
    on QueryBuilder<SearchData, SearchData, QWhere> {
  QueryBuilder<SearchData, SearchData, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SearchDataQueryWhere
    on QueryBuilder<SearchData, SearchData, QWhereClause> {
  QueryBuilder<SearchData, SearchData, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
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

  QueryBuilder<SearchData, SearchData, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterWhereClause> isarIdBetween(
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
}

extension SearchDataQueryFilter
    on QueryBuilder<SearchData, SearchData, QFilterCondition> {
  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> searchEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> searchGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> searchLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> searchBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> searchStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> searchEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> searchContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> searchMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition> searchIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterFilterCondition>
      searchIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search',
        value: '',
      ));
    });
  }
}

extension SearchDataQueryObject
    on QueryBuilder<SearchData, SearchData, QFilterCondition> {}

extension SearchDataQueryLinks
    on QueryBuilder<SearchData, SearchData, QFilterCondition> {}

extension SearchDataQuerySortBy
    on QueryBuilder<SearchData, SearchData, QSortBy> {
  QueryBuilder<SearchData, SearchData, QAfterSortBy> sortBySearch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search', Sort.asc);
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterSortBy> sortBySearchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search', Sort.desc);
    });
  }
}

extension SearchDataQuerySortThenBy
    on QueryBuilder<SearchData, SearchData, QSortThenBy> {
  QueryBuilder<SearchData, SearchData, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterSortBy> thenBySearch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search', Sort.asc);
    });
  }

  QueryBuilder<SearchData, SearchData, QAfterSortBy> thenBySearchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search', Sort.desc);
    });
  }
}

extension SearchDataQueryWhereDistinct
    on QueryBuilder<SearchData, SearchData, QDistinct> {
  QueryBuilder<SearchData, SearchData, QDistinct> distinctBySearch(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search', caseSensitive: caseSensitive);
    });
  }
}

extension SearchDataQueryProperty
    on QueryBuilder<SearchData, SearchData, QQueryProperty> {
  QueryBuilder<SearchData, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SearchData, String, QQueryOperations> searchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search');
    });
  }
}
