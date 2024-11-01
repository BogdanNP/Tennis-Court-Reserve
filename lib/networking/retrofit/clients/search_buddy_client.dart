import 'package:court_reserve_app/networking/api_environment.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'search_buddy_client.g.dart';

@RestApi(baseUrl: ApiEnvironment.searchBuddyManagementUrl)
abstract class SearchBuddyClient {
  factory SearchBuddyClient(Dio dio, {String? baseUrl}) =>
      _SearchBuddyClient(dio, baseUrl: baseUrl);

  @POST("/search-buddy/filters-and-sorting")
  Future<dynamic> getSearchBuddyRequests({
    @Body() required Map<String, dynamic> filter,
  });

  @POST("/search-buddy/accept")
  Future<dynamic> acceptBuddyRequest({
    @Query("userId") required int userId,
    @Query("courtReserveId") required int reservationId,
    @Query("searchBuddyId") required int searchBuddyId,
  });

  @POST("/search-buddy-registration")
  Future<dynamic> createSearchBuddyRequest({
    @Body() required Map<String, dynamic> searchBuddyRequest,
  });
}
