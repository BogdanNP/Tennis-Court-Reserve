// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_host_user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterHostUserData _$RegisterHostUserDataFromJson(
        Map<String, dynamic> json) =>
    RegisterHostUserData(
      aboutMe: json['aboutMe'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$RegisterHostUserDataToJson(
        RegisterHostUserData instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'phoneNumber': instance.phoneNumber,
      'aboutMe': instance.aboutMe,
    };
