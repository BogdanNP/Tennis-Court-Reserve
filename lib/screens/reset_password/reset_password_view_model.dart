import 'package:court_reserve_app/models/reset_password_data.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class ResetPasswordViewModel {
  final Input input;
  final AuthenticationRepository authenticationRepository;
  late Output output;

  ResetPasswordViewModel({
    required this.input,
    required this.authenticationRepository,
  }) {
    Stream<UIModel<bool>> onChangePassword =
        input.changePassword.flatMap((resetPasswordData) {
      validateResetPasswordData(resetPasswordData);
      return authenticationRepository
          .resetPassword(resetPasswordData)
          .asStream()
          .map((_) => UIModel.success(true))
          .startWith(UIModel.loading());
    }).onErrorReturnWith(
      (error, _) => UIModel.error(
        (error as DioException?)?.response ?? "Something went wrong!",
      ),
    );

    output = Output(
      onChangePassword: onChangePassword,
    );
  }

  void validateResetPasswordData(ResetPasswordData resetPasswordData) {
    if (resetPasswordData.password.length < 6) {
      throw Exception("Password must be at least 6 characters long");
    }
    if (resetPasswordData.password != resetPasswordData.confirmPassword) {
      throw Exception("Passwords do not match");
    }
  }
}

class Input {
  final Subject<ResetPasswordData> changePassword;

  const Input(
    this.changePassword,
  );
}

class Output {
  final Stream<UIModel<bool>> onChangePassword;

  const Output({
    required this.onChangePassword,
  });
}
