import 'package:court_reserve_app/models/court_reserve.dart';
import 'package:court_reserve_app/models/reservation.dart';
import 'package:court_reserve_app/models/tennis_court_list_filter.dart';
import 'package:court_reserve_app/networking/retrofit/clients/reservation_client.dart';
import 'package:court_reserve_app/networking/retrofit/retrofit_controller.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';

class ReservationRepository {
  final ReservationClient _reservationClient;
  final AuthenticationRepository _authenticationRepository;

  ReservationRepository()
      : _reservationClient = RetrofitController.reservationClient(),
        _authenticationRepository = AuthenticationRepository();

  Future<Reservation> updateReservation(
      {required CourtReserve courtReserve}) async {
    int userId = await _authenticationRepository.getUserId();
    Map<String, dynamic> reservationMap = courtReserve.toJson();
    reservationMap["userId"] = userId;
    reservationMap.remove("courtId");
    return _reservationClient
        .updateReservation(reservation: reservationMap)
        .then((value) => Reservation.fromJson(value));
  }

  Future<bool> declineReservation({required int reservationId}) async {
    int userId = await _authenticationRepository.getUserId();
    await _reservationClient.declineReservation(
      userId: userId,
      reservationId: reservationId,
    );
    return true;
  }

  Future<List<Reservation>> getReservationList({
    required TennisCourtListFilter tennisCourtListFilter,
  }) {
    return _reservationClient
        .getReservationList(
            tennisCourtListFilter: tennisCourtListFilter.toJson())
        .then((result) {
      return (result["content"] as List)
          .map((e) => Reservation.fromJson(e))
          .toList();
    });
  }

  Future<Reservation> createReservation(
      {required CourtReserve courtReserve}) async {
    int userId = await _authenticationRepository.getUserId();
    Map<String, dynamic> reservationMap = {};
    reservationMap["userId"] = userId;
    reservationMap["courtId"] = courtReserve.courtId;
    reservationMap["courtReserveRequestDTO"] = courtReserve.toJson()
      ..remove("courtReserveId")
      ..remove("userId")
      ..remove("courtId");
    Map<String, dynamic> result =
        await _reservationClient.createReservation(reservation: reservationMap);
    return Reservation.fromJson(result);
  }

  Future<bool> cancelReservation({required int reservationId}) async {
    int userId = await _authenticationRepository.getUserId();
    await _reservationClient.cancelReservation(
      userId: userId,
      reservationId: reservationId,
    );
    return true;
  }

  Future<bool> acceptReservation({
    required int reservationId,
    required int courtId,
  }) async {
    int userId = await _authenticationRepository.getUserId();
    await _reservationClient.acceptReservation(
      userId: userId,
      reservationId: reservationId,
      courtId: courtId,
    );
    return true;
  }

  Future<List<Reservation>> getUserReservationList() async {
    int userId = await _authenticationRepository.getUserId();
    return _reservationClient
        .getUserReservationList(userId: userId)
        .then((result) {
      return (result as List).map((e) => Reservation.fromJson(e)).toList();
    });
  }

  Future<List<Reservation>> getUserCourtReservationList({
    required int courtId,
  }) async {
    int userId = await _authenticationRepository.getUserId();
    return _reservationClient
        .getUserCourtReservationList(userId: userId, courtId: courtId)
        .then((result) {
      return (result as List).map((e) => Reservation.fromJson(e)).toList();
    });
  }

  Future<List<Reservation>> getCourtReservationList({
    required int courtId,
  }) async {
    return _reservationClient
        .getCourtReservationList(courtId: courtId)
        .then((result) {
      return (result as List).map((e) => Reservation.fromJson(e)).toList();
    });
  }

  Future<bool> deleteReservation({
    required int reservationId,
  }) async {
    int userId = await _authenticationRepository.getUserId();
    await _reservationClient.deleteCourtReserve(
      userId: userId,
      reservationId: reservationId,
    );
    return true;
  }
}
