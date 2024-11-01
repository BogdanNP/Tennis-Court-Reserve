import 'package:court_reserve_app/models/membership.dart';
import 'package:court_reserve_app/networking/api_environment.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'membership_client.g.dart';

@RestApi(baseUrl: ApiEnvironment.membershipManagementUrl)
abstract class MembershipClient {
  factory MembershipClient(Dio dio, {String? baseUrl}) =>
      _MembershipClient(dio, baseUrl: baseUrl);

  @POST("/membership")
  Future<dynamic> createMembership({
    @Body() required Map<String, dynamic> membership,
  });

  @DELETE("/membership")
  Future<dynamic> deleteMembership({
    @Query("userId") required int userId,
  });

  @PATCH("/membership")
  Future<dynamic> updateMembership({
    @Body() required Map<String, dynamic> membership,
  });

  @GET("/membership")
  Future<dynamic> getMembership({
    @Query("userId") required int userId,
  });
}
