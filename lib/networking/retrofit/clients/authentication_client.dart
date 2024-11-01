import 'package:court_reserve_app/models/authentication_response.dart';
import 'package:court_reserve_app/models/register_host_user_data.dart';
import 'package:court_reserve_app/models/register_user_data.dart';
import 'package:court_reserve_app/networking/api_environment.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/reset_password_data.dart';

part 'authentication_client.g.dart';

@RestApi(baseUrl: ApiEnvironment.userManagementUrl)
abstract class AuthenticationClient {
  factory AuthenticationClient(Dio dio, {String? baseUrl}) =>
      _AuthenticationClient(dio, baseUrl: baseUrl);

  @POST("/login")
  Future<AuthenticationResponse> login({
    @Query("username") required String username,
    @Query("password") required String password,
  });

  @POST("/register/guest")
  Future<AuthenticationResponse> registerGuest({
    @Body() required RegisterUserData registerGuestUserData,
  });

  @POST("/register/host")
  Future<AuthenticationResponse> registerHost({
    @Body() required RegisterHostUserData registerHostUserData,
  });

  @GET("/requestChangePassword/{email}")
  Future<dynamic> requestChangePassword({
    @Path() required String email,
  });

  @PATCH("/changePassword")
  Future<dynamic> changePassword({
    @Body() required ResetPasswordData resetPasswordData,
  });
}
