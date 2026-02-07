// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStationEntityCollection on Isar {
  IsarCollection<StationEntity> get stationEntitys => this.collection();
}

const StationEntitySchema = CollectionSchema(
  name: r'StationEntity',
  id: -8340744117668150026,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'ideess': PropertySchema(
      id: 1,
      name: r'ideess',
      type: IsarType.string,
    ),
    r'latitude': PropertySchema(
      id: 2,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'locality': PropertySchema(
      id: 3,
      name: r'locality',
      type: IsarType.string,
    ),
    r'longitude': PropertySchema(
      id: 4,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'municipality': PropertySchema(
      id: 5,
      name: r'municipality',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'postalCode': PropertySchema(
      id: 7,
      name: r'postalCode',
      type: IsarType.string,
    ),
    r'priceDieselA': PropertySchema(
      id: 8,
      name: r'priceDieselA',
      type: IsarType.double,
    ),
    r'priceDieselB': PropertySchema(
      id: 9,
      name: r'priceDieselB',
      type: IsarType.double,
    ),
    r'priceDieselPremium': PropertySchema(
      id: 10,
      name: r'priceDieselPremium',
      type: IsarType.double,
    ),
    r'priceGasolina95': PropertySchema(
      id: 11,
      name: r'priceGasolina95',
      type: IsarType.double,
    ),
    r'priceGasolina98': PropertySchema(
      id: 12,
      name: r'priceGasolina98',
      type: IsarType.double,
    ),
    r'priceGlp': PropertySchema(
      id: 13,
      name: r'priceGlp',
      type: IsarType.double,
    ),
    r'province': PropertySchema(
      id: 14,
      name: r'province',
      type: IsarType.string,
    ),
    r'schedule': PropertySchema(
      id: 15,
      name: r'schedule',
      type: IsarType.string,
    )
  },
  estimateSize: _stationEntityEstimateSize,
  serialize: _stationEntitySerialize,
  deserialize: _stationEntityDeserialize,
  deserializeProp: _stationEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'ideess': IndexSchema(
      id: -6781880700407169045,
      name: r'ideess',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'ideess',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'province': IndexSchema(
      id: -6035047385865569949,
      name: r'province',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'province',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'priceGasolina95': IndexSchema(
      id: -6036789868804191301,
      name: r'priceGasolina95',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'priceGasolina95',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'priceDieselA': IndexSchema(
      id: 2184473707305406409,
      name: r'priceDieselA',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'priceDieselA',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _stationEntityGetId,
  getLinks: _stationEntityGetLinks,
  attach: _stationEntityAttach,
  version: '3.1.0+1',
);

int _stationEntityEstimateSize(
  StationEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.address.length * 3;
  bytesCount += 3 + object.ideess.length * 3;
  bytesCount += 3 + object.locality.length * 3;
  bytesCount += 3 + object.municipality.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.postalCode.length * 3;
  bytesCount += 3 + object.province.length * 3;
  bytesCount += 3 + object.schedule.length * 3;
  return bytesCount;
}

void _stationEntitySerialize(
  StationEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeString(offsets[1], object.ideess);
  writer.writeDouble(offsets[2], object.latitude);
  writer.writeString(offsets[3], object.locality);
  writer.writeDouble(offsets[4], object.longitude);
  writer.writeString(offsets[5], object.municipality);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.postalCode);
  writer.writeDouble(offsets[8], object.priceDieselA);
  writer.writeDouble(offsets[9], object.priceDieselB);
  writer.writeDouble(offsets[10], object.priceDieselPremium);
  writer.writeDouble(offsets[11], object.priceGasolina95);
  writer.writeDouble(offsets[12], object.priceGasolina98);
  writer.writeDouble(offsets[13], object.priceGlp);
  writer.writeString(offsets[14], object.province);
  writer.writeString(offsets[15], object.schedule);
}

StationEntity _stationEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StationEntity();
  object.address = reader.readString(offsets[0]);
  object.id = id;
  object.ideess = reader.readString(offsets[1]);
  object.latitude = reader.readDouble(offsets[2]);
  object.locality = reader.readString(offsets[3]);
  object.longitude = reader.readDouble(offsets[4]);
  object.municipality = reader.readString(offsets[5]);
  object.name = reader.readString(offsets[6]);
  object.postalCode = reader.readString(offsets[7]);
  object.priceDieselA = reader.readDoubleOrNull(offsets[8]);
  object.priceDieselB = reader.readDoubleOrNull(offsets[9]);
  object.priceDieselPremium = reader.readDoubleOrNull(offsets[10]);
  object.priceGasolina95 = reader.readDoubleOrNull(offsets[11]);
  object.priceGasolina98 = reader.readDoubleOrNull(offsets[12]);
  object.priceGlp = reader.readDoubleOrNull(offsets[13]);
  object.province = reader.readString(offsets[14]);
  object.schedule = reader.readString(offsets[15]);
  return object;
}

P _stationEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    case 12:
      return (reader.readDoubleOrNull(offset)) as P;
    case 13:
      return (reader.readDoubleOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stationEntityGetId(StationEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _stationEntityGetLinks(StationEntity object) {
  return [];
}

void _stationEntityAttach(
    IsarCollection<dynamic> col, Id id, StationEntity object) {
  object.id = id;
}

extension StationEntityByIndex on IsarCollection<StationEntity> {
  Future<StationEntity?> getByIdeess(String ideess) {
    return getByIndex(r'ideess', [ideess]);
  }

  StationEntity? getByIdeessSync(String ideess) {
    return getByIndexSync(r'ideess', [ideess]);
  }

  Future<bool> deleteByIdeess(String ideess) {
    return deleteByIndex(r'ideess', [ideess]);
  }

  bool deleteByIdeessSync(String ideess) {
    return deleteByIndexSync(r'ideess', [ideess]);
  }

  Future<List<StationEntity?>> getAllByIdeess(List<String> ideessValues) {
    final values = ideessValues.map((e) => [e]).toList();
    return getAllByIndex(r'ideess', values);
  }

  List<StationEntity?> getAllByIdeessSync(List<String> ideessValues) {
    final values = ideessValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'ideess', values);
  }

  Future<int> deleteAllByIdeess(List<String> ideessValues) {
    final values = ideessValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'ideess', values);
  }

  int deleteAllByIdeessSync(List<String> ideessValues) {
    final values = ideessValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'ideess', values);
  }

  Future<Id> putByIdeess(StationEntity object) {
    return putByIndex(r'ideess', object);
  }

  Id putByIdeessSync(StationEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'ideess', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdeess(List<StationEntity> objects) {
    return putAllByIndex(r'ideess', objects);
  }

  List<Id> putAllByIdeessSync(List<StationEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'ideess', objects, saveLinks: saveLinks);
  }
}

extension StationEntityQueryWhereSort
    on QueryBuilder<StationEntity, StationEntity, QWhere> {
  QueryBuilder<StationEntity, StationEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhere> anyPriceGasolina95() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'priceGasolina95'),
      );
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhere> anyPriceDieselA() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'priceDieselA'),
      );
    });
  }
}

extension StationEntityQueryWhere
    on QueryBuilder<StationEntity, StationEntity, QWhereClause> {
  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> ideessEqualTo(
      String ideess) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ideess',
        value: [ideess],
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      ideessNotEqualTo(String ideess) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ideess',
              lower: [],
              upper: [ideess],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ideess',
              lower: [ideess],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ideess',
              lower: [ideess],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ideess',
              lower: [],
              upper: [ideess],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> provinceEqualTo(
      String province) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'province',
        value: [province],
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      provinceNotEqualTo(String province) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'province',
              lower: [],
              upper: [province],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'province',
              lower: [province],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'province',
              lower: [province],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'province',
              lower: [],
              upper: [province],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceGasolina95IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'priceGasolina95',
        value: [null],
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceGasolina95IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'priceGasolina95',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceGasolina95EqualTo(double? priceGasolina95) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'priceGasolina95',
        value: [priceGasolina95],
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceGasolina95NotEqualTo(double? priceGasolina95) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priceGasolina95',
              lower: [],
              upper: [priceGasolina95],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priceGasolina95',
              lower: [priceGasolina95],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priceGasolina95',
              lower: [priceGasolina95],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priceGasolina95',
              lower: [],
              upper: [priceGasolina95],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceGasolina95GreaterThan(
    double? priceGasolina95, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'priceGasolina95',
        lower: [priceGasolina95],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceGasolina95LessThan(
    double? priceGasolina95, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'priceGasolina95',
        lower: [],
        upper: [priceGasolina95],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceGasolina95Between(
    double? lowerPriceGasolina95,
    double? upperPriceGasolina95, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'priceGasolina95',
        lower: [lowerPriceGasolina95],
        includeLower: includeLower,
        upper: [upperPriceGasolina95],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceDieselAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'priceDieselA',
        value: [null],
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceDieselAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'priceDieselA',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceDieselAEqualTo(double? priceDieselA) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'priceDieselA',
        value: [priceDieselA],
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceDieselANotEqualTo(double? priceDieselA) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priceDieselA',
              lower: [],
              upper: [priceDieselA],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priceDieselA',
              lower: [priceDieselA],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priceDieselA',
              lower: [priceDieselA],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'priceDieselA',
              lower: [],
              upper: [priceDieselA],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceDieselAGreaterThan(
    double? priceDieselA, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'priceDieselA',
        lower: [priceDieselA],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceDieselALessThan(
    double? priceDieselA, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'priceDieselA',
        lower: [],
        upper: [priceDieselA],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause>
      priceDieselABetween(
    double? lowerPriceDieselA,
    double? upperPriceDieselA, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'priceDieselA',
        lower: [lowerPriceDieselA],
        includeLower: includeLower,
        upper: [upperPriceDieselA],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StationEntityQueryFilter
    on QueryBuilder<StationEntity, StationEntity, QFilterCondition> {
  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      addressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      addressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      addressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      addressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      addressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      addressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      ideessEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ideess',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      ideessGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ideess',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      ideessLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ideess',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      ideessBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ideess',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      ideessStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ideess',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      ideessEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ideess',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      ideessContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ideess',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      ideessMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ideess',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      ideessIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ideess',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      ideessIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ideess',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      localityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      localityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      localityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      localityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      localityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      localityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      localityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      localityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'locality',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      localityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locality',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      localityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'locality',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      municipalityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      municipalityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      municipalityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      municipalityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'municipality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      municipalityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      municipalityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      municipalityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      municipalityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'municipality',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      municipalityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'municipality',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      municipalityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'municipality',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      postalCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      postalCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      postalCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      postalCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'postalCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      postalCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      postalCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      postalCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'postalCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      postalCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'postalCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      postalCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'postalCode',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      postalCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'postalCode',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priceDieselA',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priceDieselA',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselAEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceDieselA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselAGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceDieselA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselALessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceDieselA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselABetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceDieselA',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priceDieselB',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priceDieselB',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselBEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceDieselB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselBGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceDieselB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselBLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceDieselB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselBBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceDieselB',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselPremiumIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priceDieselPremium',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselPremiumIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priceDieselPremium',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselPremiumEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceDieselPremium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselPremiumGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceDieselPremium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselPremiumLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceDieselPremium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceDieselPremiumBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceDieselPremium',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina95IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priceGasolina95',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina95IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priceGasolina95',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina95EqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceGasolina95',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina95GreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceGasolina95',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina95LessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceGasolina95',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina95Between(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceGasolina95',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina98IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priceGasolina98',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina98IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priceGasolina98',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina98EqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceGasolina98',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina98GreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceGasolina98',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina98LessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceGasolina98',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGasolina98Between(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceGasolina98',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGlpIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priceGlp',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGlpIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priceGlp',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGlpEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceGlp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGlpGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceGlp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGlpLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceGlp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      priceGlpBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceGlp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      provinceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      provinceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      provinceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      provinceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'province',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      provinceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      provinceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      provinceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      provinceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'province',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      provinceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'province',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      provinceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'province',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      scheduleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schedule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      scheduleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schedule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      scheduleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schedule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      scheduleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schedule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      scheduleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'schedule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      scheduleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'schedule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      scheduleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'schedule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      scheduleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'schedule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      scheduleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schedule',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      scheduleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'schedule',
        value: '',
      ));
    });
  }
}

extension StationEntityQueryObject
    on QueryBuilder<StationEntity, StationEntity, QFilterCondition> {}

extension StationEntityQueryLinks
    on QueryBuilder<StationEntity, StationEntity, QFilterCondition> {}

extension StationEntityQuerySortBy
    on QueryBuilder<StationEntity, StationEntity, QSortBy> {
  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByIdeess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ideess', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByIdeessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ideess', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByLocality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByLocalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByMunicipality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipality', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByMunicipalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipality', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByPostalCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postalCode', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPostalCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postalCode', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPriceDieselA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselA', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPriceDieselADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselA', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPriceDieselB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselB', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPriceDieselBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselB', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPriceDieselPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselPremium', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPriceDieselPremiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselPremium', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPriceGasolina95() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGasolina95', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPriceGasolina95Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGasolina95', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPriceGasolina98() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGasolina98', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPriceGasolina98Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGasolina98', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByPriceGlp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGlp', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByPriceGlpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGlp', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByProvince() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'province', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByProvinceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'province', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortBySchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schedule', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schedule', Sort.desc);
    });
  }
}

extension StationEntityQuerySortThenBy
    on QueryBuilder<StationEntity, StationEntity, QSortThenBy> {
  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByIdeess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ideess', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByIdeessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ideess', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByLocality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByLocalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByMunicipality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipality', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByMunicipalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipality', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByPostalCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postalCode', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPostalCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postalCode', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPriceDieselA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselA', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPriceDieselADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselA', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPriceDieselB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselB', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPriceDieselBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselB', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPriceDieselPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselPremium', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPriceDieselPremiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceDieselPremium', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPriceGasolina95() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGasolina95', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPriceGasolina95Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGasolina95', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPriceGasolina98() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGasolina98', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPriceGasolina98Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGasolina98', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByPriceGlp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGlp', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByPriceGlpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceGlp', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByProvince() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'province', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByProvinceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'province', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenBySchedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schedule', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByScheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schedule', Sort.desc);
    });
  }
}

extension StationEntityQueryWhereDistinct
    on QueryBuilder<StationEntity, StationEntity, QDistinct> {
  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByIdeess(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ideess', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByLocality(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locality', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByMunicipality(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'municipality', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByPostalCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'postalCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct>
      distinctByPriceDieselA() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priceDieselA');
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct>
      distinctByPriceDieselB() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priceDieselB');
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct>
      distinctByPriceDieselPremium() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priceDieselPremium');
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct>
      distinctByPriceGasolina95() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priceGasolina95');
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct>
      distinctByPriceGasolina98() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priceGasolina98');
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByPriceGlp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priceGlp');
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByProvince(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'province', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctBySchedule(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schedule', caseSensitive: caseSensitive);
    });
  }
}

extension StationEntityQueryProperty
    on QueryBuilder<StationEntity, StationEntity, QQueryProperty> {
  QueryBuilder<StationEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StationEntity, String, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<StationEntity, String, QQueryOperations> ideessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ideess');
    });
  }

  QueryBuilder<StationEntity, double, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<StationEntity, String, QQueryOperations> localityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locality');
    });
  }

  QueryBuilder<StationEntity, double, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<StationEntity, String, QQueryOperations> municipalityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'municipality');
    });
  }

  QueryBuilder<StationEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<StationEntity, String, QQueryOperations> postalCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'postalCode');
    });
  }

  QueryBuilder<StationEntity, double?, QQueryOperations>
      priceDieselAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priceDieselA');
    });
  }

  QueryBuilder<StationEntity, double?, QQueryOperations>
      priceDieselBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priceDieselB');
    });
  }

  QueryBuilder<StationEntity, double?, QQueryOperations>
      priceDieselPremiumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priceDieselPremium');
    });
  }

  QueryBuilder<StationEntity, double?, QQueryOperations>
      priceGasolina95Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priceGasolina95');
    });
  }

  QueryBuilder<StationEntity, double?, QQueryOperations>
      priceGasolina98Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priceGasolina98');
    });
  }

  QueryBuilder<StationEntity, double?, QQueryOperations> priceGlpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priceGlp');
    });
  }

  QueryBuilder<StationEntity, String, QQueryOperations> provinceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'province');
    });
  }

  QueryBuilder<StationEntity, String, QQueryOperations> scheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schedule');
    });
  }
}
