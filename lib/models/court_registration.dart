import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:json_annotation/json_annotation.dart';

part 'court_registration.g.dart';

@JsonSerializable()
class CourtRegistration {
  final int userId;
  final TennisCourt courtRequestDTO;

  CourtRegistration(this.userId, this.courtRequestDTO);

  Map<String, dynamic> toJson() => _$CourtRegistrationToJson(this);
}
