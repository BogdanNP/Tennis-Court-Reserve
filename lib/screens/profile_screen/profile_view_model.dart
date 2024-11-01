import 'package:court_reserve_app/models/membership.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/models/user.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:court_reserve_app/repositories/membership_repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class ProfileViewModel {
  final Input input;
  final AuthenticationRepository _authenticationRepository;
  final MembershipRepository _membershipRepository;
  late Output output;
  int index = 0;

  ProfileViewModel(
    this.input,
    this._authenticationRepository,
    this._membershipRepository,
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

    Stream<UIModel<bool>> onLogout = input.logout
        .flatMap(
          (_) => _authenticationRepository
              .logout()
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

    Stream<UIModel<Membership?>> onGetMembership =
        input.currentUser.flatMap((_) {
      return _membershipRepository
          .getMembership()
          .asStream()
          .map((membership) => UIModel.success(membership))
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          );
    });

    Stream<UIModel<Membership?>> onSaveMembership =
        input.saveMembership.flatMap((membership) {
      return _membershipRepository
          .createMembership(membership)
          .asStream()
          .map((membershipResponse) => UIModel.success(membershipResponse))
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          );
    });

    Stream<UIModel<Membership?>> onDeleteMembership =
        input.deleteMembership.flatMap((_) {
      return _membershipRepository
          .deleteMembership()
          .asStream()
          .map((_) => UIModel.success(null))
          .startWith(UIModel.loading())
          .onErrorReturnWith(
            (error, _) => UIModel.error(
              (error as DioException?)?.response ?? "Something went wrong!",
            ),
          );
    });

    output = Output(
      onCurrentUser: onCurrentUser,
      onLogout: onLogout,
      onMembership: MergeStream([
        onGetMembership,
        onSaveMembership,
        onDeleteMembership,
      ]),
    );
  }
}

class Input {
  final Subject<bool> currentUser;
  final Subject<bool> logout;
  final Subject<Membership> saveMembership;
  final Subject<bool> deleteMembership;

  const Input(
    this.currentUser,
    this.logout,
    this.saveMembership,
    this.deleteMembership,
  );
}

class Output {
  final Stream<UIModel<User>> onCurrentUser;
  final Stream<UIModel<bool>> onLogout;
  final Stream<UIModel<Membership?>> onMembership;

  const Output({
    required this.onCurrentUser,
    required this.onLogout,
    required this.onMembership,
  });
}
