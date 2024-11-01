class Reservation {
  final int? courtReserveId;
  final int? userId;
  final int? courtId;
  final DateTime reserveStartTime;
  final DateTime reserveEndTime;
  final int numberOfPlayers;
  final double? totalPrice;
  final String? status;

  Reservation({
    this.courtReserveId,
    this.userId,
    this.courtId,
    required this.reserveStartTime,
    required this.reserveEndTime,
    required this.numberOfPlayers,
    this.totalPrice,
    this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      courtReserveId: json["courtReserveId"],
      userId: json["userId"],
      courtId: json["courtId"],
      reserveStartTime: DateTime.parse(json["reserveStartTime"]),
      reserveEndTime: DateTime.parse(json["reserveEndTime"]),
      numberOfPlayers: json["numberOfPlayers"],
      totalPrice: (json["totalPrice"] as int).toDouble(),
      status: json["courtReserveStatus"],
    );
  }

  Map<String, dynamic> toSearchBuddyRequestJson(
      {bool switchReservation = false}) {
    return {
      "cortReserveId": courtReserveId,
      "numberOfPlayers": numberOfPlayers,
      "switchReservation": switchReservation,
    };
  }
}
