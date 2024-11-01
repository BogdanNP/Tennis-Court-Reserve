import 'package:court_reserve_app/models/court_registration.dart';
import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:court_reserve_app/models/tennis_court_list_filter.dart';
import 'package:court_reserve_app/networking/retrofit/clients/tennis_court_client.dart';
import 'package:court_reserve_app/networking/retrofit/retrofit_controller.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:dio/dio.dart';

class TennisCourtRepository {
  final TennisCourtClient _tennisCourtClient;
  final AuthenticationRepository _authenticationRepository;
  TennisCourtRepository()
      : _tennisCourtClient = RetrofitController.tennisCourtClient(),
        _authenticationRepository = AuthenticationRepository();

  Future<TennisCourt> updateTennisCourt(TennisCourt tennisCourt) async {
    int userId = await _authenticationRepository.getUserId();
    Map<String, dynamic> court = tennisCourt.toJson();
    court["userId"] = userId;
    court["courtId"] = tennisCourt.courtId;
    await uploadImages(
      courtId: tennisCourt.courtId!,
      imagesAsBytes: tennisCourt.imagesData,
    );
    return _tennisCourtClient
        .updateTennisCourt(tennisCourt: court)
        .then((value) => TennisCourt.fromJson(value));
  }

  Future<void> deleteTennisCourt({required int courtId}) async {
    int userId = await _authenticationRepository.getUserId();
    await _tennisCourtClient.deleteTennisCourt(
        userId: userId, courtId: courtId);
  }

  Future<void> uploadImages({
    required int courtId,
    required List<dynamic> imagesAsBytes,
  }) async {
    int userId = await _authenticationRepository.getUserId();
    await _tennisCourtClient.uploadImages(
      userId: userId,
      courtId: courtId,
      images: imagesAsBytes.map((e) {
        return MultipartFile.fromBytes(e, filename: "image");
      }).toList(),
    );
  }

  Future<TennisCourt> createTennisCourt(TennisCourt tennisCourt) async {
    int userId = await _authenticationRepository.getUserId();
    var response = await _tennisCourtClient.createTennisCourt(
      courtRegistration: CourtRegistration(userId, tennisCourt).toJson(),
    );
    TennisCourt result = TennisCourt.fromJson(response);
    if (result.courtId != null) {
      await uploadImages(
          courtId: result.courtId!, imagesAsBytes: tennisCourt.imagesData);
    }
    return result;
  }

  Future<List<TennisCourt>> getTennisCourtList(
    TennisCourtListFilter tennisCourtListFilter,
  ) {
    return _tennisCourtClient
        .getTennisCourtList(
            tennisCourtListFilter: tennisCourtListFilter.toJson())
        .then((result) {
      return (result["content"] as List)
          .map((e) => TennisCourt.fromJson(e))
          .toList();
    });
  }

  Future<List<TennisCourt>> getTennisCourtListForUser() async {
    int userId = await _authenticationRepository.getUserId();
    var filter = TennisCourtListFilter.userId(userId);
    return getTennisCourtList(filter);
  }
}
