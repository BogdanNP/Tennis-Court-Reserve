// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'court_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourtRegistration _$CourtRegistrationFromJson(Map<String, dynamic> json) =>
    CourtRegistration(
      json['userId'] as int,
      TennisCourt.fromJson(json['courtRequestDTO'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CourtRegistrationToJson(CourtRegistration instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'courtRequestDTO': instance.courtRequestDTO,
    };
