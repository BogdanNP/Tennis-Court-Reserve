import 'package:court_reserve_app/extensions/date_time_extension.dart';
import 'package:court_reserve_app/models/membership.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/models/user.dart';
import 'package:court_reserve_app/networking/api_environment.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:court_reserve_app/repositories/membership_repository.dart';
import 'package:court_reserve_app/screens/login_screen/login_screen.dart';
import 'package:court_reserve_app/screens/profile_screen/profile_view_model.dart';
import 'package:court_reserve_app/screens/register_screen/register_screen.dart';
import 'package:court_reserve_app/widgets/app_popup.dart';
import 'package:court_reserve_app/widgets/user_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback navigateToCourts;

  const ProfileScreen({
    required this.navigateToCourts,
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  Membership? membership;
  String _ipAddress = ApiEnvironment.ipAddress;

  late ProfileViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ProfileViewModel(
      Input(
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
      ),
      AuthenticationRepository(),
      MembershipRepository(),
    );
    _viewModel.output.onCurrentUser.listen((event) {
      setState(() {
        if (event.state == OperationState.success) {
          user = event.data;
        }
        if (event.state == OperationState.error) {
          user = null;
        }
      });
    });

    _viewModel.output.onMembership.listen((event) {
      setState(() {
        if (event.state == OperationState.success) {
          membership = event.data;
        }
        if (event.state == OperationState.error) {
          membership = null;
        }
      });
    });

    _viewModel.output.onLogout.listen((event) {
      setState(() {
        if (event.state == OperationState.success) {
          user = null;
        }
      });
    });

    _viewModel.input.currentUser.add(true);

    super.initState();
  }

  void _showLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    ).then((_) {
      _viewModel.input.currentUser.add(true);
    });
  }

  void _showRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const RegisterScreen();
        },
      ),
    ).then((user) {
      if (user != null && user is User) {
        _viewModel.input.currentUser.add(true);
        showModalBottomSheet(
          context: context,
          builder: (context) => AppPopup(
            title: "Email confirmation",
            content: "An email has been sent to your address ${user.email}",
          ),
        );
      }
    });
  }

  void _logout() {
    _viewModel.input.logout.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: user == null ? _loggedOutScreen() : _loggedInScreen(),
      ),
    );
  }

  Widget _loggedOutScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 30),
        const Text(
          "Welcome to Tennis Court Reserve App!",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
              color: Colors.lightGreen.shade900,
              borderRadius: BorderRadius.circular(10)),
          child: const Text(
            "Experience the ultimate in tennis convenience! Login or register"
            " now to reserve top-notch tennis courts "
            "and start playing. Your next match is just a tap away! "
            "Join today and elevate your game.",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 25),
        _authenticationCard(),
        Text(
          "Start Spring App on local host, open terminal and write ipconfig, "
          "take IPv4 Address from Wireless LAN adapter Wi-Fi section.\n"
          "Current ip set: ${ApiEnvironment.ipAddress}",
        ),
        TextField(
          onSubmitted: (ipAddress) {
            setState(() {
              _ipAddress = ipAddress;
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              ApiEnvironment.ipAddress = _ipAddress;
            });
          },
          child: const Text("Set ip address"),
        )
      ],
    );
  }

  Widget _loggedInScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 20),
        UserDetailsWidget(user: user!),
        if (user!.isGuest) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  color: Colors.black.withOpacity(0.5),
                  width: 1,
                ),
              ),
              onPressed: widget.navigateToCourts,
              child: const Text("Search for a court"),
            ),
          ),
        ],
        if (user!.isGuest) ...[
          const SizedBox(height: 10),
          _membershipCard(),
        ],
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                color: Colors.black.withOpacity(0.5),
                width: 1,
              ),
            ),
            onPressed: _logout,
            child: const Text("Logout"),
          ),
        ),
      ],
    );
  }

  Widget _membershipCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (membership == null) ...[
          const Text(
            "Become a member today! Choose what fits you best.",
            style: TextStyle(fontSize: 18),
          ),
          ...Membership.subscriptions().map((sub) {
            return _subscriptionCard(sub);
          })
        ],
        if (membership != null) ...[
          const Text(
            "My membership:",
            style: TextStyle(fontSize: 18),
          ),
          _subscriptionCard(
            Membership.subscriptions()
                .firstWhere((sub) => sub.type == membership!.type),
            currentMembership: membership,
          ),
        ],
      ],
    );
  }

  Widget _subscriptionCard(
    Membership sub, {
    Membership? currentMembership,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: sub.type == MembershipType.silver
            ? const Color(0xFFC0C0C0)
            : sub.type == MembershipType.gold
                ? const Color(0xFFFFD700)
                : Colors.greenAccent,
      ),
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.type.name
                      .replaceFirst("s", "S")
                      .replaceFirst("g", "G")
                      .replaceFirst("p", "P"),
                  style: const TextStyle(fontSize: 18),
                ),
                Text("Available ${sub.availability()}"),
                Text("${sub.numberOfEntries} Entries"),
                if (currentMembership != null) ...[
                  Text(
                    "Valid: "
                    "${currentMembership.validFrom?.toDayMonthYearFormat()} - "
                    "${currentMembership.validTo?.toDayMonthYearFormat()}",
                  ),
                  Text("Entries left: ${currentMembership.numberOfEntries}"),
                ],
                if (currentMembership == null) Text("Price: ${sub.price} RON"),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              if (currentMembership == null) {
                _viewModel.input.saveMembership.add(sub);
              } else {
                _viewModel.input.deleteMembership.add(true);
              }
            },
            child: Text(
              currentMembership == null ? "Apply" : "Resign",
              style: const TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget _authenticationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.lightGreen.shade900,
          width: 3,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "What are you waiting for?",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: _showLogin,
                  child: const Text("Login"),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Join and let's play!",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: _showRegister,
                  child: const Text("Register"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
