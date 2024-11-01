import 'package:court_reserve_app/models/login_data.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/models/user.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class LoginViewModel {
  final Input input;
  final AuthenticationRepository authenticationRepository;
  late Output output;

  LoginViewModel({
    required this.input,
    required this.authenticationRepository,
  }) {
    Stream<UIModel<User>> onLogin = input.login
        .flatMap((loginData) => authenticationRepository
            .loginUser(
              username: loginData.username,
              password: loginData.password,
            )
            .asStream()
            .map((user) => UIModel.success(user))
            .startWith(UIModel.loading()))
        .onErrorReturnWith(
          (error, _) => UIModel.error(
            (error as DioException?)?.response ?? "Something went wrong!",
          ),
        );

    Stream<UIModel<bool>> onRequestChangePassword = input.requestChangePassword
        .flatMap((email) => authenticationRepository
            .requestChangePassword(
              email: email,
            )
            .asStream()
            .map((_) => UIModel.success(true))
            .startWith(UIModel.loading()))
        .onErrorReturnWith(
          (error, _) => UIModel.error(
            (error as DioException?)?.response ?? "Something went wrong!",
          ),
        );

    output = Output(
      onLogin: onLogin,
      onRequestChangePassword: onRequestChangePassword,
    );
  }
}

class Input {
  final Subject<LoginData> login;
  final Subject<String> requestChangePassword;

  const Input(
    this.login,
    this.requestChangePassword,
  );
}

class Output {
  final Stream<UIModel<User>> onLogin;
  final Stream<UIModel<bool>> onRequestChangePassword;

  const Output({
    required this.onLogin,
    required this.onRequestChangePassword,
  });
}
