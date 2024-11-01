class SearchBuddyRequest {
  final int courtId;
  final int searchBuddyId;
  final int courtReserveId;
  final int numberOfPlayers;
  final DateTime reserveStartTime;
  final DateTime reserveEndTime;
  final double totalPrice;
  final String status;
  final bool switchReservation;

  SearchBuddyRequest(
    this.courtId,
    this.searchBuddyId,
    this.courtReserveId,
    this.numberOfPlayers,
    this.reserveStartTime,
    this.reserveEndTime,
    this.totalPrice,
    this.status,
    this.switchReservation,
  );

  factory SearchBuddyRequest.fromJson(Map<String, dynamic> map) {
    return SearchBuddyRequest(
      map["courtId"],
      map["searchBuddyId"],
      map["courtReserveId"],
      map["numberOfPlayers"],
      DateTime.parse(map["reserveStartTime"]),
      DateTime.parse(map["reserveEndTime"]),
      (map["totalPrice"] as int).toDouble(),
      map["status"],
      map["switchReservation"],
    );
  }
}
