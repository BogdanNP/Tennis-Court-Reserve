import 'package:court_reserve_app/models/token.dart';
import 'package:court_reserve_app/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authentication_response.g.dart';

@JsonSerializable()
class AuthenticationResponse {
  final User userResponseDTO;
  final Token token;

  AuthenticationResponse({
    required this.userResponseDTO,
    required this.token,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);
}
