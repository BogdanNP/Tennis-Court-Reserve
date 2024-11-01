import 'package:court_reserve_app/networking/api_environment.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'tennis_court_client.g.dart';

@RestApi(baseUrl: ApiEnvironment.tennisCourtManagementUrl)
abstract class TennisCourtClient {
  factory TennisCourtClient(Dio dio, {String? baseUrl}) =>
      _TennisCourtClient(dio, baseUrl: baseUrl);

  @PUT("/court")
  Future<dynamic> updateTennisCourt({
    @Body() required Map<String, dynamic> tennisCourt,
  });

  @DELETE("/court")
  Future<dynamic> deleteTennisCourt({
    @Query("userId") required int userId,
    @Query("courtId") required int courtId,
  });

  @POST("/images/upload")
  @MultiPart()
  Future<dynamic> uploadImages({
    @Query("userId") required int userId,
    @Query("courtId") required int courtId,
    @Part(name: "images") required List<MultipartFile> images,
  });

  // TODO: handle more filters and update courts screen
  @POST("/courts/filters-and-sorting")
  Future<dynamic> getTennisCourtList({
    @Body() required Map<String, dynamic> tennisCourtListFilter,
  });

  @POST("/court-registration")
  Future<dynamic> createTennisCourt({
    @Body() required Map<String, dynamic> courtRegistration,
  });

  @GET("/images/court")
  Future<dynamic> getImages({
    @Query("courtId") required int courtId,
  });

  @GET("/courts/user")
  Future<HttpResponse<dynamic>> getCourtsByUserId({
    @Query("userId") required int userId,
  });

  @GET("/court/types")
  Future<dynamic> getCourtTypes();
}
