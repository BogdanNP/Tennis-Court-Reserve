import 'package:court_reserve_app/models/reset_password_data.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:court_reserve_app/screens/reset_password/reset_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ResetPasswordScreen extends StatefulWidget {
  final int userId;

  const ResetPasswordScreen({
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetPasswordViewModel _viewModel;
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showLoading = false;

  @override
  void initState() {
    _viewModel = ResetPasswordViewModel(
      input: Input(
        PublishSubject(),
      ),
      authenticationRepository: AuthenticationRepository(),
    );
    bindViewModel();
    super.initState();
  }

  void bindViewModel() {
    _viewModel.output.onChangePassword.listen((event) {
      setState(() {
        switch (event.state) {
          case OperationState.success:
            _showLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Your password was changed successfully!"),
              ),
            );
            break;
          case OperationState.loading:
            _showLoading = true;
            break;
          case OperationState.error:
            _showLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(event.error.toString()),
              ),
            );
            break;
        }
      });
    });
  }

  void changePassword() {
    FocusScope.of(context).unfocus();
    _viewModel.input.changePassword.add(
      ResetPasswordData(
        confirmPassword: _confirmPasswordController.text,
        password: _passwordController.text,
        userId: widget.userId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Stack(
          children: [
            Column(
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
                    "Change Password",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(hintText: "New Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(hintText: "Confirm Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: changePassword,
                      child: const Text("Change Password"),
                    ),
                  ],
                )
              ],
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
      ),
    );
  }
}
