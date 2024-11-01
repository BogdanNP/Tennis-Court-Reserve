import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:court_reserve_app/models/tennis_court_list_filter.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/models/user.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:court_reserve_app/repositories/tennis_court_repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class CourtsViewModel {
  final Input input;
  final AuthenticationRepository _authenticationRepository;
  final TennisCourtRepository _tennisCourtRepository;
  late Output output;

  CourtsViewModel(
    this.input,
    this._tennisCourtRepository,
    this._authenticationRepository,
  ) {
    Stream<UIModel<List<TennisCourt>>> onCourts = input.courts.flatMap(
      (tennisCourtListFilter) => _tennisCourtRepository
          .getTennisCourtList(tennisCourtListFilter)
          .asStream()
          .map((tennisCourtList) => UIModel.success(tennisCourtList))
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          ),
    );

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

    output = Output(
      onCurrentUser,
      onCourts,
    );
  }
}

class Input {
  final Subject<bool> currentUser;
  final Subject<TennisCourtListFilter> courts;

  Input(
    this.currentUser,
    this.courts,
  );
}

class Output {
  final Stream<UIModel<User>> onCurrentUser;
  final Stream<UIModel<List<TennisCourt>>> onCourts;

  const Output(
    this.onCurrentUser,
    this.onCourts,
  );
}
