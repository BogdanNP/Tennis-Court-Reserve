import 'package:court_reserve_app/networking/api_environment.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'court_rates_client.g.dart';

@RestApi(baseUrl: ApiEnvironment.courtRatesManagementUrl)
abstract class CourtRatesClient {
  factory CourtRatesClient(Dio dio, {String? baseUrl}) =>
      _CourtRatesClient(dio, baseUrl: baseUrl);

  @PUT("/update")
  Future<dynamic> updateCourtRate({
    @Body() required Map<String, dynamic> courtRate,
  });

  @POST("/registration")
  Future<dynamic> registerCourtRate({
    @Body() required Map<String, dynamic> courtRate,
  });

  @GET("/{courtRateId}")
  Future<dynamic> getCourtRate({
    @Path() required int courtRateId,
  });

  @GET("/court/{courtId}")
  Future<dynamic> getCourtRateByCourtId({
    @Path() required int courtId,
  });

  @DELETE("")
  Future<dynamic> deleteCourtRateByCourt({
    @Query("courtRatesId") required int courtRateId,
    @Query("userId") required int userId,
  });
}
