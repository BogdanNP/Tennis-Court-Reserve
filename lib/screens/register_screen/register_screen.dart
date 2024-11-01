import 'package:court_reserve_app/models/register_host_user_data.dart';
import 'package:court_reserve_app/models/register_user_data.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:court_reserve_app/screens/register_screen/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterViewModel _viewModel;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  bool _showLoading = false;
  bool _registerAsHostSelected = false;

  @override
  void initState() {
    _viewModel = RegisterViewModel(
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
    _viewModel.output.onRegister.listen((event) {
      setState(() {
        switch (event.state) {
          case OperationState.success:
            _showLoading = false;
            Navigator.of(context).pop(event.data);
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
  }

  void register() {
    FocusScope.of(context).unfocus();
    if (_registerAsHostSelected) {
      _viewModel.input.registerHost.add(
        RegisterHostUserData(
          username: _usernameController.text,
          email: _emailController.text,
          phoneNumber: _phoneNumberController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          aboutMe: _aboutMeController.text,
        ),
      );
    } else {
      _viewModel.input.registerGuest.add(
        RegisterUserData(
          username: _usernameController.text,
          email: _emailController.text,
          phoneNumber: _phoneNumberController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        // title: Text("Create account"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
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
                      "Create account",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(hintText: "Username"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(hintText: "First name"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(hintText: "Last name"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(hintText: "Phone number"),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: "Password"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration:
                        const InputDecoration(hintText: "Confirm Password"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Checkbox(
                          value: _registerAsHostSelected,
                          onChanged: (value) {
                            setState(() {
                              _registerAsHostSelected = value ?? false;
                            });
                          }),
                      Text("Register as Host"),
                    ],
                  ),
                  if (_registerAsHostSelected)
                    TextFormField(
                      controller: _aboutMeController,
                      decoration: const InputDecoration(hintText: "About Me"),
                    ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: register,
                        child: const Text("Register"),
                      ),
                    ],
                  )
                ],
              ),
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
