// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'court_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourtFilter _$CourtFilterFromJson(Map<String, dynamic> json) => CourtFilter(
      field: json['field'] as String,
      values:
          (json['values'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CourtFilterToJson(CourtFilter instance) =>
    <String, dynamic>{
      'field': instance.field,
      'values': instance.values,
    };
