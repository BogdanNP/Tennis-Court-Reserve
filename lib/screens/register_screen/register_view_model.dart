import 'package:court_reserve_app/extensions/validator_extension.dart';
import 'package:court_reserve_app/models/register_host_user_data.dart';
import 'package:court_reserve_app/models/register_user_data.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/models/user.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class RegisterViewModel {
  final Input input;
  final AuthenticationRepository authenticationRepository;
  late Output output;

  RegisterViewModel({
    required this.input,
    required this.authenticationRepository,
  }) {
    Stream<UIModel<User>> registerHostUser =
        input.registerHost.flatMap((registerData) {
      validateRegisterData(registerData);
      return authenticationRepository
          .registerHostUser(registerHostUserData: registerData)
          .asStream()
          .map((user) => UIModel.success(user))
          .startWith(UIModel.loading());
    });

    Stream<UIModel<User>> registerGuestUser =
        input.registerGuest.flatMap((registerData) {
      validateRegisterData(registerData);
      return authenticationRepository
          .registerGuestUser(registerGuestUserData: registerData)
          .asStream()
          .map((user) => UIModel.success(user))
          .startWith(UIModel.loading());
    });

    Stream<UIModel<User>> onRegister =
        Rx.merge([registerHostUser, registerGuestUser]).onErrorReturnWith(
      (error, _) => UIModel.error(
        (error as DioException?)?.response ?? "Something went wrong!",
      ),
    );

    output = Output(
      onRegister: onRegister,
    );
  }

  void validateRegisterData(RegisterUserData registerData) {
    if (registerData.username.isEmpty) {
      throw Exception("Username is empty");
    }
    if (!registerData.email.isValidEmail()) {
      throw Exception("Email is invalid");
    }
    if (registerData.firstName.isEmpty) {
      throw Exception("Firstname is empty");
    }
    if (registerData.lastName.isEmpty) {
      throw Exception("Lastname is empty");
    }
    if (registerData.phoneNumber.length < 10) {
      throw Exception("Phone number length must be 10 digits");
    }
    if (registerData.password.length < 6) {
      throw Exception("Password must be at least 6 characters long");
    }
    if (registerData.password != registerData.confirmPassword) {
      throw Exception("Passwords do not match");
    }
  }
}

class Input {
  final Subject<RegisterUserData> registerGuest;
  final Subject<RegisterHostUserData> registerHost;
  const Input(
    this.registerGuest,
    this.registerHost,
  );
}

class Output {
  final Stream<UIModel<User>> onRegister;
  const Output({
    required this.onRegister,
  });
}
