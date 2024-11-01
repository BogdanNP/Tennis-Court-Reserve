import 'package:court_reserve_app/models/reservation.dart';
import 'package:court_reserve_app/models/search_buddy_request.dart';
import 'package:court_reserve_app/models/tennis_court_list_filter.dart';
import 'package:court_reserve_app/networking/retrofit/clients/search_buddy_client.dart';
import 'package:court_reserve_app/networking/retrofit/retrofit_controller.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';

class SearchBuddyRepository {
  final SearchBuddyClient _searchBuddyClient;
  final AuthenticationRepository _authenticationRepository;

  SearchBuddyRepository()
      : _searchBuddyClient = RetrofitController.searchBuddyClient(),
        _authenticationRepository = AuthenticationRepository();

  Future<bool> createSearchBuddyRequest(
      {required Reservation reservation,
      bool giveUpReservation = false}) async {
    int userId = await _authenticationRepository.getUserId();
    Map<String, dynamic> searchBuddyRequest = reservation
        .toSearchBuddyRequestJson(switchReservation: giveUpReservation);
    searchBuddyRequest["userId"] = userId;
    return _searchBuddyClient
        .createSearchBuddyRequest(searchBuddyRequest: searchBuddyRequest)
        .then((value) {
      return true;
    });
  }

  Future<bool> acceptSearchBuddyRequest({
    required int reservationId,
    required int searchBuddyId,
  }) async {
    int userId = await _authenticationRepository.getUserId();
    await _searchBuddyClient.acceptBuddyRequest(
      userId: userId,
      reservationId: reservationId,
      searchBuddyId: searchBuddyId,
    );
    return true;
  }

  Future<List<SearchBuddyRequest>> getSearchBuddyRequestList() async {
    int userId = await _authenticationRepository.getUserId();
    return _searchBuddyClient
        .getSearchBuddyRequests(
      filter: TennisCourtListFilter.numberOfPlayers().toJson()
        ..addAll({"userId": userId}),
    )
        .then((result) {
      return (result["content"] as List)
          .map((e) => SearchBuddyRequest.fromJson(e))
          .toList();
    });
  }
}
