import 'package:court_reserve_app/models/register_user_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'register_host_user_data.g.dart';

@JsonSerializable()
class RegisterHostUserData extends RegisterUserData {
  final String aboutMe;
  RegisterHostUserData({
    required this.aboutMe,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.username,
    required super.password,
    required super.confirmPassword,
    required super.phoneNumber,
  });

  @override
  Map<String, dynamic> toJson() => _$RegisterHostUserDataToJson(this);
}
