import 'package:court_reserve_app/models/court_rate.dart';
import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/court_rates_repository.dart';
import 'package:court_reserve_app/repositories/tennis_court_repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class AddTennisCourtViewModel {
  final Input input;
  final TennisCourtRepository _tennisCourtRepo;
  final CourtRatesRepository _courtRatesRepository;
  late Output output;
  AddTennisCourtViewModel(
    this.input,
    this._tennisCourtRepo,
    this._courtRatesRepository,
  ) {
    Stream<UIModel<TennisCourt>> onSave = input.save.flatMap((tennisCourt) {
      tennisCourt.validate();
      if (tennisCourt.courtId != null) {
        return _tennisCourtRepo
            .updateTennisCourt(tennisCourt)
            .asStream()
            .flatMap((event) {
          return _courtRatesRepository
              .updateCourtRate(
                tennisCourt.courtRate?.copyWith(courtId: event.courtId!) ??
                    CourtRate(20, 20, 0, courtId: event.courtId!),
              )
              .asStream()
              .map(
                (_) => UIModel.success(event),
              );
        });
      }
      return _tennisCourtRepo
          .createTennisCourt(tennisCourt)
          .asStream()
          .flatMap((event) {
        return _courtRatesRepository
            .registerCourtRate(
              tennisCourt.courtRate?.copyWith(courtId: event.courtId!) ??
                  CourtRate(20, 20, 0, courtId: event.courtId!),
            )
            .asStream()
            .map(
              (_) => UIModel.success(event),
            );
      });
    }).onErrorReturnWith(
      (error, _) => UIModel.error(
        (error as DioException?)?.response ?? "Something went wrong!",
      ),
    );
    ;

    Stream<UIModel<bool>> onDelete = input.delete.flatMap((courtId) {
      return _tennisCourtRepo
          .deleteTennisCourt(courtId: courtId)
          .asStream()
          .map((_) {
        return UIModel.success(true);
      });
    }).onErrorReturnWith(
      (error, _) => UIModel.error(
        (error as DioException?)?.response ?? "Something went wrong!",
      ),
    );
    Stream<UIModel<CourtRate>> onInit = input.init.flatMap((courtId) {
      return _courtRatesRepository
          .getCourtRateByCourtId(courtId)
          .asStream()
          .map((courtRate) {
        return UIModel.success(courtRate);
      });
    }).onErrorReturnWith(
      (error, _) => UIModel.error(
        (error as DioException?)?.response ?? "Something went wrong!",
      ),
    );

    output = Output(
      onSave: onSave,
      onDelete: onDelete,
      onInit: onInit,
    );
  }
}

class Input {
  Subject<TennisCourt> save;
  Subject<int> delete;
  Subject<int> init;
  Input(
    this.save,
    this.delete,
    this.init,
  );
}

class Output {
  Stream<UIModel<TennisCourt>> onSave;
  Stream<UIModel<bool>> onDelete;
  Stream<UIModel<CourtRate>> onInit;
  Output({
    required this.onSave,
    required this.onDelete,
    required this.onInit,
  });
}
