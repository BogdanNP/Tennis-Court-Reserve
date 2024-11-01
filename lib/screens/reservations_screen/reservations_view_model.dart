import 'package:court_reserve_app/models/reservation.dart';
import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:court_reserve_app/models/tennis_court_list_filter.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/models/user.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:court_reserve_app/repositories/reservation_repository.dart';
import 'package:court_reserve_app/repositories/search_buddy_repository.dart';
import 'package:court_reserve_app/repositories/tennis_court_repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class ReservationsViewModel {
  final Input input;
  final AuthenticationRepository _authenticationRepository;
  final TennisCourtRepository _tennisCourtRepository;
  final ReservationRepository _reservationRepository;
  final SearchBuddyRepository _searchBuddyRepository;
  late Output output;
  int index = 0;

  ReservationsViewModel(
    this.input,
    this._authenticationRepository,
    this._tennisCourtRepository,
    this._reservationRepository,
    this._searchBuddyRepository,
  ) {
    Stream<UIModel<User>> onCurrentUser = input.currentUser
        .flatMap((_) => _authenticationRepository
            .getUser()
            .asStream()
            .map((user) => UIModel.success(user)))
        .onErrorReturnWith(
          (error, _) => UIModel.error(
            (error as DioException?)?.response ?? "Something went wrong!",
          ),
        );

    Stream<UIModel<bool>> onCancelReservation = input.cancelReservation
        .flatMap(
          (reservation) => _reservationRepository
              .cancelReservation(reservationId: reservation.courtReserveId!)
              .asStream()
              .map((_) => UIModel.success(true))
              .startWith(UIModel.loading()),
        )
        .onErrorReturnWith(
          (error, _) => UIModel.error(
            (error as DioException?)?.response ?? "Something went wrong!",
          ),
        );

    Stream<UIModel<bool>> onSearchBuddy = input.searchBuddy
        .flatMap(
          (reservation) => _searchBuddyRepository
              .createSearchBuddyRequest(reservation: reservation)
              .asStream()
              .map(
                (_) => UIModel.success(true),
              )
              .startWith(UIModel.loading()),
        )
        .onErrorReturnWith(
          (error, _) => UIModel.error(
            (error as DioException?)?.response ?? "Something went wrong!",
          ),
        );

    Stream<UIModel<bool>> onGiveUpReservation = input.giveUpReservation
        .flatMap(
          (reservation) => _searchBuddyRepository
              .createSearchBuddyRequest(
                  reservation: reservation, giveUpReservation: true)
              .asStream()
              .map(
                (_) => UIModel.success(false),
              )
              .startWith(UIModel.loading()),
        )
        .onErrorReturnWith(
          (error, _) => UIModel.error(
            (error as DioException?)?.response ?? "Something went wrong!",
          ),
        );

    Stream<UIModel<List<TennisCourt>>> onGetTennisCourtListForHost =
        input.getTennisCourtListForHost.flatMap((tennisCourtListFilter) {
      return _tennisCourtRepository
          .getTennisCourtListForUser()
          .asStream()
          .map((list) {
        return UIModel.success(list);
      }).onErrorReturnWith(
        (error, _) => UIModel.error(
          (error as DioException?)?.response ?? "Something went wrong!",
        ),
      );
    });

    Stream<UIModel<List<Reservation>>> onUserReservationList =
        input.userReservationList.flatMap((_) {
      return _reservationRepository
          .getUserReservationList()
          .asStream()
          .map((list) {
        return UIModel.success(list);
      }).onErrorReturnWith(
        (error, _) => UIModel.error(
          (error as DioException?)?.response ?? "Something went wrong!",
        ),
      );
    });

    Stream<UIModel<List<TennisCourt>>> onTennisCourtList =
        input.userReservationList.flatMap((_) {
      return _tennisCourtRepository
          .getTennisCourtList(TennisCourtListFilter.all())
          .asStream()
          .map((list) {
        return UIModel.success(list);
      }).onErrorReturnWith(
        (error, _) => UIModel.error(
          (error as DioException?)?.response ?? "Something went wrong!",
        ),
      );
    });

    output = Output(
      onCurrentUser: onCurrentUser,
      onCancelReservation: onCancelReservation,
      onGetTennisCourtListForHost: onGetTennisCourtListForHost,
      onTennisCourtList: onTennisCourtList,
      onUserReservationList: onUserReservationList,
      onSearchBuddy: MergeStream([onSearchBuddy, onGiveUpReservation]),
    );
  }
}

class Input {
  final Subject<bool> currentUser;
  final Subject<Reservation> cancelReservation;
  final Subject<Reservation> searchBuddy;
  final Subject<Reservation> giveUpReservation;
  final Subject<bool> getTennisCourtListForHost;
  final Subject<bool> userReservationList;

  const Input(
    this.currentUser,
    this.cancelReservation,
    this.searchBuddy,
    this.giveUpReservation,
    this.getTennisCourtListForHost,
    this.userReservationList,
  );
}

class Output {
  final Stream<UIModel<User>> onCurrentUser;
  final Stream<UIModel<bool>> onCancelReservation;
  final Stream<UIModel<List<TennisCourt>>> onGetTennisCourtListForHost;
  final Stream<UIModel<List<TennisCourt>>> onTennisCourtList;
  final Stream<UIModel<List<Reservation>>> onUserReservationList;
  final Stream<UIModel<bool>> onSearchBuddy;

  const Output({
    required this.onCurrentUser,
    required this.onCancelReservation,
    required this.onGetTennisCourtListForHost,
    required this.onTennisCourtList,
    required this.onUserReservationList,
    required this.onSearchBuddy,
  });
}
