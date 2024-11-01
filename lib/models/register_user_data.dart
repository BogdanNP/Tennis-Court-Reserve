import 'package:json_annotation/json_annotation.dart';
part 'register_user_data.g.dart';

@JsonSerializable()
class RegisterUserData {
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String password;
  final String confirmPassword;
  final String phoneNumber;

  RegisterUserData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => _$RegisterUserDataToJson(this);
}
