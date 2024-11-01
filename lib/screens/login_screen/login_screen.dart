import 'package:court_reserve_app/models/login_data.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:court_reserve_app/screens/login_screen/login_view_model.dart';
import 'package:court_reserve_app/widgets/app_popup.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginViewModel _viewModel;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _email = "";
  bool _showLoading = false;

  @override
  void initState() {
    _viewModel = LoginViewModel(
      input: Input(
        PublishSubject(),
        PublishSubject(),
      ),
      authenticationRepository: AuthenticationRepository(),
    );
    bindViewModel();
    super.initState();
  }

  void bindViewModel() {
    _viewModel.output.onLogin.listen((event) {
      debugPrint("$event");
      setState(() {
        switch (event.state) {
          case OperationState.success:
            _showLoading = false;
            Navigator.of(context).pop();
            break;
          case OperationState.loading:
            _showLoading = true;
            break;
          case OperationState.error:
            _showLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  event.error.toString(),
                ),
              ),
            );
            break;
        }
      });
    });

    _viewModel.output.onRequestChangePassword.listen((event) {
      setState(() {
        switch (event.state) {
          case OperationState.success:
            _showLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("An email was send to: $_email")),
            );
            break;
          case OperationState.loading:
            _showLoading = true;
            break;
          case OperationState.error:
            _showLoading = false;
            String message = "Something went wrong. Try again.";
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            break;
        }
      });
    });
  }

  void login() {
    FocusScope.of(context).unfocus();
    _viewModel.input.login.add(
      LoginData(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  void forgotPassword() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) => AppPopup(
        title: "Forgot password",
        content:
            "Write your email and we will send you an email to change your password.",
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onChanged: (email) => _email = email,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: requestChangePassword,
                child: const Text("Change password"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void requestChangePassword() {
    Navigator.of(context).pop();
    _viewModel.input.requestChangePassword.add(_email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.sports_tennis,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    "Login to account",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(hintText: "Username"),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(hintText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: login,
                      child: const Text("Login"),
                    ),
                    TextButton(
                      onPressed: forgotPassword,
                      child: const Text("Forgot password?"),
                    ),
                  ],
                )
              ],
            ),
          ),
          if (_showLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
