import 'package:court_reserve_app/models/court_rate.dart';
import 'package:court_reserve_app/networking/retrofit/clients/court_rates_client.dart';
import 'package:court_reserve_app/networking/retrofit/retrofit_controller.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';

class CourtRatesRepository {
  final CourtRatesClient _courtRatesClient;
  final AuthenticationRepository _authenticationRepository;

  CourtRatesRepository()
      : _courtRatesClient = RetrofitController.courtRatesClient(),
        _authenticationRepository = AuthenticationRepository();

  Future<bool> updateCourtRate(CourtRate courtRate) async {
    int userId = await _authenticationRepository.getUserId();
    var response = await _courtRatesClient.updateCourtRate(
        courtRate: courtRate.toJson()
          ..addAll({
            "userId": userId,
            "id": courtRate!.id,
          })
          ..remove("courtId"));
    print(response);
    return true;
  }

  Future<bool> registerCourtRate(CourtRate courtRate) async {
    int userId = await _authenticationRepository.getUserId();
    var response = await _courtRatesClient.registerCourtRate(
        courtRate: courtRate.toJson()..addAll({"userId": userId}));
    print(response);
    return true;
  }

  Future<CourtRate> getCourtRate(int id) async {
    var response = await _courtRatesClient.getCourtRate(courtRateId: id);
    return CourtRate.fromJson(response);
  }

  Future<CourtRate> getCourtRateByCourtId(int id) async {
    var response = await _courtRatesClient.getCourtRateByCourtId(courtId: id);
    return CourtRate.fromJson(response);
  }
}
