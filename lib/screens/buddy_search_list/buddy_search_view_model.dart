import 'package:court_reserve_app/models/search_buddy_request.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/search_buddy_repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class BuddySearchViewModel {
  final Input input;
  final SearchBuddyRepository _searchBuddyRepository;
  late Output output;

  BuddySearchViewModel(
    this.input,
    this._searchBuddyRepository,
  ) {
    Stream<UIModel<List<SearchBuddyRequest>>> onBuddySearchList =
        input.buddySearchList.flatMap(
      (_) => _searchBuddyRepository
          .getSearchBuddyRequestList()
          .asStream()
          .map((event) {
            return UIModel.success(event);
          })
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          ),
    );
    Stream<UIModel<bool>> onAcceptBuddySearchRequest =
        input.acceptSearchBuddyRequest.flatMap(
      (searchBuddyRequest) => _searchBuddyRepository
          .acceptSearchBuddyRequest(
              reservationId: searchBuddyRequest.courtReserveId,
              searchBuddyId: searchBuddyRequest.searchBuddyId)
          .asStream()
          .map((event) {
            return UIModel.success(event);
          })
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          ),
    );

    output = Output(onBuddySearchList, onAcceptBuddySearchRequest);
  }
}

class Input {
  final Subject<bool> buddySearchList;
  final Subject<SearchBuddyRequest> acceptSearchBuddyRequest;
  Input(
    this.buddySearchList,
    this.acceptSearchBuddyRequest,
  );
}

class Output {
  final Stream<UIModel<List<SearchBuddyRequest>>> onBuddySearchList;
  final Stream<UIModel<bool>> onAcceptBuddySearchRequest;
  Output(this.onBuddySearchList, this.onAcceptBuddySearchRequest);
}
