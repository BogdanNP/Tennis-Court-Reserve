import 'package:court_reserve_app/networking/api_environment.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'reservation_client.g.dart';

@RestApi(baseUrl: ApiEnvironment.courtReserveManagementUrl)
abstract class ReservationClient {
  factory ReservationClient(Dio dio, {String? baseUrl}) =>
      _ReservationClient(dio, baseUrl: baseUrl);

  @PUT("/court-reserves")
  Future<dynamic> updateReservation({
    @Body() required Map<String, dynamic> reservation,
  });

  @POST("/decline/court-reserve")
  Future<dynamic> declineReservation({
    @Query("userId") required int userId,
    @Query("courtReserveId") required int reservationId,
  });

  @POST("/court-reserve/filters-and-sorting")
  Future<dynamic> getReservationList({
    @Body() required Map<String, dynamic> tennisCourtListFilter,
  });

  @POST("/court-reserve/court")
  Future<dynamic> createReservation({
    @Body() required Map<String, dynamic> reservation,
  });

  @POST("/cancel/court-reserve")
  Future<dynamic> cancelReservation({
    @Query("userId") required int userId,
    @Query("courtReserveId") required int reservationId,
  });

  @POST("/accept/court-reserve")
  Future<dynamic> acceptReservation({
    @Query("userId") required int userId,
    @Query("courtReserveId") required int reservationId,
    @Query("courtId") required int courtId,
  });

  @GET("/court-reserves/user")
  Future<dynamic> getUserReservationList({
    @Query("userId") required int userId,
  });

  @GET("/court-reserves/user-court")
  Future<dynamic> getUserCourtReservationList({
    @Query("userId") required int userId,
    @Query("courtId") required int courtId,
  });

  @GET("/court-reserves/court")
  Future<dynamic> getCourtReservationList({
    @Query("courtId") required int courtId,
  });

  @DELETE("/court-reserve")
  Future<dynamic> deleteCourtReserve({
    @Query("userId") required int userId,
    @Query("courtReserveId") required int reservationId,
  });
}
