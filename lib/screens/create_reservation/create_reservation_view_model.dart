import 'package:court_reserve_app/models/court_rate.dart';
import 'package:court_reserve_app/models/court_reserve.dart';
import 'package:court_reserve_app/models/reservation.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/court_rates_repository.dart';
import 'package:court_reserve_app/repositories/reservation_repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class CreateReservationViewModel {
  final Input input;
  final ReservationRepository _reservationRepository;
  final CourtRatesRepository _courtRatesRepository;
  late Output output;

  CreateReservationViewModel(
    this.input,
    this._reservationRepository,
    this._courtRatesRepository,
  ) {
    Stream<UIModel<CourtRate>> onRate = input.init.flatMap((id) {
      return _courtRatesRepository
          .getCourtRateByCourtId(id)
          .asStream()
          .map((courtRate) {
            return UIModel.success(courtRate);
          })
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          );
    });

    Stream<UIModel<Reservation>> onSave = input.save.flatMap((courtReserve) {
      return _reservationRepository
          .createReservation(courtReserve: courtReserve)
          .asStream()
          .map((reservation) {
            return UIModel.success(reservation);
          })
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          );
    });
    Stream<UIModel<Reservation>> onUpdate =
        input.update.flatMap((courtReserve) {
      return _reservationRepository
          .updateReservation(courtReserve: courtReserve)
          .asStream()
          .map((reservation) {
            return UIModel.success(reservation);
          })
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          );
    });
    output = Output(onSave, onUpdate, onRate);
  }
}

class Input {
  final Subject<CourtReserve> save;
  final Subject<CourtReserve> update;
  final Subject<int> init;

  const Input(
    this.save,
    this.update,
    this.init,
  );
}

class Output {
  final Stream<UIModel<Reservation>> onSave;
  final Stream<UIModel<Reservation>> onUpdate;
  final Stream<UIModel<CourtRate>> onRate;

  Output(this.onSave, this.onUpdate, this.onRate);
}
