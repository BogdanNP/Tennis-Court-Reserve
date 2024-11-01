import 'package:app_links/app_links.dart';
import 'package:court_reserve_app/screens/courts_screen/courts_screen.dart';
import 'package:court_reserve_app/screens/profile_screen/profile_screen.dart';
import 'package:court_reserve_app/screens/reservations_screen/reservations_screen.dart';
import 'package:court_reserve_app/screens/reset_password/reset_password.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentPageIndex = 0;
  late AppLinks _appLinks;

  @override
  void initState() {
    _appLinks = AppLinks();

    _appLinks.allUriLinkStream.listen((uri) {
      if (uri.path == "/changePassword") {
        int? userId = int.tryParse(uri.queryParameters["userId"] ?? "");
        if (userId != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                    userId: userId,
                  )));
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Tennis Court Reserve"),
      ),
      bottomNavigationBar: _navigationBar(),
      body: _body(),
    );
  }

  Widget _navigationBar() {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.sports_tennis),
          label: 'Courts',
        ),
        NavigationDestination(
          icon: Icon(Icons.bookmark),
          // icon: Icon(Icons.bookmark_border),
          label: 'Reservations',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.directions_walk),
          icon: Icon(Icons.directions_walk_outlined),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _body() {
    if (currentPageIndex == 0) {
      return CourtsScreen(navigateToReservations: () => navigateTo(1));
    }
    if (currentPageIndex == 1) {
      return ReservationsScreen(
        navigateToProfile: () => navigateTo(2),
      );
    }
    return ProfileScreen(navigateToCourts: () => navigateTo(0));

    // return IndexedStack(
    //   index: currentPageIndex,
    //   children: [
    //     ProfileScreen(
    //       checkCurrentUser: _viewModel.input.currentUser,
    //     ),
    //     CourtsScreen(navigateToProfile: navigateToProfile),
    //   ],
    // );
  }

  void navigateTo(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }
}
