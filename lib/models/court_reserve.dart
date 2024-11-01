import 'package:court_reserve_app/extensions/date_time_extension.dart';

class CourtReserve {
  final int? courtReserveId;
  final int? userId;
  final int courtId;
  final DateTime reserveStartTime;
  final DateTime reserveEndTime;
  final int numberOfPlayers;

  CourtReserve({
    this.courtReserveId,
    this.userId,
    required this.courtId,
    required this.reserveStartTime,
    required this.reserveEndTime,
    required this.numberOfPlayers,
  });

  Map<String, dynamic> toJson() {
    return {
      "courtReserveId": courtReserveId,
      "userId": userId,
      "courtId": courtId,
      "reserveStartTime": reserveStartTime.toApiFormat(),
      "reserveEndTime": reserveEndTime.toApiFormat(),
      "numberOfPlayers": numberOfPlayers,
    };
  }
}
