import 'package:court_reserve_app/networking/api_environment.dart';
import 'package:court_reserve_app/networking/retrofit/clients/authentication_client.dart';
import 'package:court_reserve_app/networking/retrofit/clients/membership_client.dart';
import 'package:court_reserve_app/networking/retrofit/clients/court_rates_client.dart';
import 'package:court_reserve_app/networking/retrofit/clients/reservation_client.dart';
import 'package:court_reserve_app/networking/retrofit/clients/search_buddy_client.dart';
import 'package:court_reserve_app/networking/retrofit/clients/tennis_court_client.dart';
import 'package:court_reserve_app/repositories/shared_preferences_repository.dart';
import 'package:dio/dio.dart';
import 'package:court_reserve_app/models/token.dart';

class RetrofitController {
  static Dio _dioWithUserToken() => Dio()..interceptors.add(TokenInterceptor());
  static Dio _dioWithoutUserToken() => Dio();

  static AuthenticationClient authenticationClient() => AuthenticationClient(
        _dioWithoutUserToken(),
        baseUrl: ApiEnvironment.getUserManagementUrl(),
      );

  static TennisCourtClient tennisCourtClient() => TennisCourtClient(
        _dioWithUserToken(),
        baseUrl: ApiEnvironment.getTennisCourtManagementUrl(),
      );

  static ReservationClient reservationClient() => ReservationClient(
        _dioWithUserToken(),
        baseUrl: ApiEnvironment.getCourtReserveManagementUrl(),
      );

  static SearchBuddyClient searchBuddyClient() => SearchBuddyClient(
        _dioWithUserToken(),
        baseUrl: ApiEnvironment.getSearchBuddyManagementUrl(),
      );

  static MembershipClient membershipClient() => MembershipClient(
        _dioWithUserToken(),
        baseUrl: ApiEnvironment.getMembershipManagementUrl(),
      );

  static CourtRatesClient courtRatesClient() => CourtRatesClient(
        _dioWithUserToken(),
        baseUrl: ApiEnvironment.getCourtRatesManagementUrl(),
      );
}

class TokenInterceptor extends Interceptor {
  final SharedPreferencesRepository sharedPreferencesRepository;

  TokenInterceptor()
      : sharedPreferencesRepository = SharedPreferencesRepository();
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.path.contains("search-buddy") &&
            options.path.contains("filters-and-sorting") ||
        options.method == "GET") {
      super.onRequest(options, handler);
      return;
    }
    Token token = await sharedPreferencesRepository.getToken();
    options.headers["Authorization"] = "Bearer ${token.accessToken}";
    super.onRequest(options, handler);
  }
}
