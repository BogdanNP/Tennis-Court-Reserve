import 'package:court_reserve_app/models/register_host_user_data.dart';
import 'package:court_reserve_app/models/register_user_data.dart';
import 'package:court_reserve_app/models/token.dart';
import 'package:court_reserve_app/models/reset_password_data.dart';
import 'package:court_reserve_app/models/user.dart';
import 'package:court_reserve_app/networking/retrofit/clients/authentication_client.dart';
import 'package:court_reserve_app/networking/retrofit/retrofit_controller.dart';
import 'package:court_reserve_app/repositories/shared_preferences_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthenticationRepository {
  final SharedPreferencesRepository sharedPreferencesRepository;
  final AuthenticationClient authenticationClient;

  AuthenticationRepository()
      : authenticationClient = RetrofitController.authenticationClient(),
        sharedPreferencesRepository = SharedPreferencesRepository();

  Future<bool> resetPassword(ResetPasswordData resetPasswordData) async {
    var result = await authenticationClient.changePassword(
      resetPasswordData: resetPasswordData,
    );
    print("result: $result");
    return true;
  }

  Future<User> loginUser({
    required String username,
    required String password,
  }) async {
    return authenticationClient
        .login(username: username, password: password)
        .then((response) async {
      await sharedPreferencesRepository.setUser(response.userResponseDTO);
      await sharedPreferencesRepository.setToken(response.token);
      await _saveUserId(response.token.accessToken);
      return response.userResponseDTO;
    });
  }

  Future<User> registerGuestUser({
    required RegisterUserData registerGuestUserData,
  }) async {
    return authenticationClient
        .registerGuest(registerGuestUserData: registerGuestUserData)
        .then((response) async {
      await sharedPreferencesRepository.setUser(response.userResponseDTO);
      await sharedPreferencesRepository.setToken(response.token);
      await _saveUserId(response.token.accessToken);
      return response.userResponseDTO;
    });
  }

  Future<User> registerHostUser({
    required RegisterHostUserData registerHostUserData,
  }) async {
    return authenticationClient
        .registerHost(registerHostUserData: registerHostUserData)
        .then((response) async {
      await sharedPreferencesRepository.setUser(response.userResponseDTO);
      await sharedPreferencesRepository.setToken(response.token);
      await _saveUserId(response.token.accessToken);
      return response.userResponseDTO;
    });
  }

  Future<void> logout() async {
    await sharedPreferencesRepository.clear();
  }

  Future<User> getUser() {
    return sharedPreferencesRepository.getUser();
  }

  Future<void> _saveUserId(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    await sharedPreferencesRepository.setUserId(decodedToken["userId"]);
  }

  Future<int> getUserId() async {
    await _checkToken();
    return sharedPreferencesRepository.getUserId();
  }

  Future<void> _checkToken() async {
    Token token = await sharedPreferencesRepository.getToken();
    Map<String, dynamic> decodedAccessToken =
        JwtDecoder.decode(token.accessToken);
    DateTime expAccessToken = DateTime.fromMicrosecondsSinceEpoch(
      decodedAccessToken["exp"] * 1000000,
    );
    if (expAccessToken.isBefore(DateTime.now())) {
      Map<String, dynamic> decodedRefreshToken =
          JwtDecoder.decode(token.accessToken);
      DateTime expRefreshToken = DateTime.fromMicrosecondsSinceEpoch(
        decodedRefreshToken["exp"] * 1000000,
      );
      if (expRefreshToken.isBefore(DateTime.now())) {
        await logout();
      } else {
        await logout();
        // TODO: implement refresh logic
        // int userId = await sharedPreferencesRepository.getUserId();
        // Token newToken = await authenticationClient.refresh(userId);
      }
    }
  }

  Future<bool> requestChangePassword({required String email}) async {
    await authenticationClient.requestChangePassword(email: email);
    return true;
  }
}
