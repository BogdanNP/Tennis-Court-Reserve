import 'package:court_reserve_app/models/reservation.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/reservation_repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class CourtReservationsViewModel {
  final Input input;
  final ReservationRepository reservationRepository;
  late Output output;

  CourtReservationsViewModel(this.input, this.reservationRepository) {
    Stream<UIModel<List<Reservation>>> onCourtId =
        input.courtId.flatMap((value) {
      return reservationRepository
          .getCourtReservationList(courtId: value)
          .asStream()
          .map((event) => UIModel.success(event))
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          );
    });

    Stream<UIModel<bool>> onAcceptReservation =
        input.acceptReservation.flatMap((reservation) {
      return reservationRepository
          .acceptReservation(
            courtId: reservation.courtId!,
            reservationId: reservation.courtReserveId!,
          )
          .asStream()
          .map((event) => UIModel.success(event))
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          );
    });

    Stream<UIModel<bool>> onDeclineReservation =
        input.declineReservation.flatMap((reservation) {
      return reservationRepository
          .declineReservation(
            reservationId: reservation.courtReserveId!,
          )
          .asStream()
          .map((event) => UIModel.success(event))
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          );
    });
    output = Output(
      onCourtId,
      MergeStream([onAcceptReservation, onDeclineReservation]),
    );
  }
}

class Input {
  final Subject<int> courtId;
  final Subject<Reservation> acceptReservation;
  final Subject<Reservation> declineReservation;
  Input(
    this.courtId,
    this.acceptReservation,
    this.declineReservation,
  );
}

class Output {
  final Stream<UIModel<List<Reservation>>> onCourtId;
  final Stream<UIModel<bool>> onReservationAcceptOrDecline;
  // final Stream<UIModel<bool>> onDeclineReservation;
  Output(
    this.onCourtId,
    this.onReservationAcceptOrDecline,
    // this.onDeclineReservation,
  );
}
