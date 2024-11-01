import 'package:court_reserve_app/models/reservation.dart';
import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/models/user.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:court_reserve_app/repositories/reservation_repository.dart';
import 'package:court_reserve_app/repositories/search_buddy_repository.dart';
import 'package:court_reserve_app/repositories/tennis_court_repository.dart';
import 'package:court_reserve_app/screens/add_tennis_court/add_tennis_court_screen.dart';
import 'package:court_reserve_app/screens/buddy_search_list/buddy_search_list_screen.dart';
import 'package:court_reserve_app/screens/court_reservations_screen/court_reservations.dart';
import 'package:court_reserve_app/screens/create_reservation/create_reservation_screen.dart';
import 'package:court_reserve_app/screens/reservations_screen/reservations_view_model.dart';
import 'package:court_reserve_app/widgets/app_popup.dart';
import 'package:court_reserve_app/widgets/reservation_card.dart';
import 'package:court_reserve_app/widgets/tennis_court_card_list.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ReservationsScreen extends StatefulWidget {
  final VoidCallback navigateToProfile;

  const ReservationsScreen({
    required this.navigateToProfile,
    Key? key,
  }) : super(key: key);

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  User? user;
  List<TennisCourt> tennisCourtForHost = [];
  List<TennisCourt> tennisCourtList = [];
  List<Reservation> userReservationList = [];

  List<Reservation> futureAndCurrentUserReservationList() => userReservationList
      .where((element) =>
          element.reserveEndTime.isAfter(DateTime.now()) &&
          element.status != "CANCELED")
      .toList();

  List<Reservation> pastAndCancelledUserReservationList() => userReservationList
      .where((element) =>
          element.reserveEndTime.isBefore(DateTime.now()) ||
          element.status == "CANCELLED")
      .toList();
  late ReservationsViewModel _viewModel;

  TennisCourt reservationTennisCourt(Reservation reservation) => tennisCourtList
      .firstWhere((element) => element.courtId == reservation.courtId);

  @override
  void initState() {
    _viewModel = ReservationsViewModel(
      Input(
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
      ),
      AuthenticationRepository(),
      TennisCourtRepository(),
      ReservationRepository(),
      SearchBuddyRepository(),
    );
    _viewModel.output.onCurrentUser.listen((event) {
      setState(() {
        if (event.state == OperationState.success) {
          user = event.data;
          if (user!.isHost) {
            _viewModel.input.getTennisCourtListForHost.add(true);
          } else {
            _viewModel.input.userReservationList.add(true);
          }
        }
        if (event.state == OperationState.error) {
          user = null;
        }
        if (user == null) {
          widget.navigateToProfile();
        }
      });
    });

    _viewModel.output.onGetTennisCourtListForHost.listen((event) {
      setState(() {
        if (event.state == OperationState.success) {
          tennisCourtForHost = event.data ?? [];
        }
      });
    });

    _viewModel.output.onTennisCourtList.listen((event) {
      setState(() {
        if (event.state == OperationState.success) {
          tennisCourtList = event.data ?? [];
        }
      });
    });

    _viewModel.output.onCancelReservation.listen((event) {
      setState(() {
        if (event.state == OperationState.success) {
          _viewModel.input.userReservationList.add(true);
        }
        if (event.state == OperationState.error) {
          _handleError(event.error);
        }
      });
    });

    _viewModel.output.onSearchBuddy.listen((event) {
      setState(() {
        if (event.state == OperationState.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(event.data == true
                  ? "Partner request was processed successfully!"
                  : "Transfer request was processed successfully!"),
            ),
          );
        }
        if (event.state == OperationState.error) {
          _handleError(event.error);
        }
      });
    });

    _viewModel.output.onUserReservationList.listen((event) {
      setState(() {
        if (event.state == OperationState.success) {
          userReservationList = event.data ?? [];
          userReservationList.sort((a, b) {
            int compareStartTime =
                a.reserveStartTime.compareTo(b.reserveStartTime);
            if (compareStartTime != 0) {
              return compareStartTime;
            }
            return a.reserveEndTime.compareTo(b.reserveEndTime);
          });
        }
      });
    });

    _viewModel.input.currentUser.add(true);
    super.initState();
  }

  void _handleError(Object? error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$error")),
    );
  }

  void _addOrEditTennisCourt({TennisCourt? tennisCourt}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddTennisCourtScreen(
        tennisCourt: tennisCourt,
      );
    })).then((success) {
      if (success == true) {
        _viewModel.input.getTennisCourtListForHost.add(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (user?.isHost ?? false) {
          _viewModel.input.getTennisCourtListForHost.add(true);
        }
        if (user?.isGuest ?? false) {
          _viewModel.input.userReservationList.add(true);
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: user == null ? Container() : _content(),
        ),
      ),
    );
  }

  Widget _content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        if (user?.isHost ?? false)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  color: Colors.black.withOpacity(0.5),
                  width: 1,
                ),
              ),
              onPressed: _addOrEditTennisCourt,
              child: const Text("Add Tennis Court"),
            ),
          ),
        const SizedBox(height: 10),
        if (user!.isGuest) _reservationsWidget(),
        if (user!.isHost) _tennisCourtsWidget(),
      ],
    );
  }

  Widget _reservationsWidget() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  color: Colors.black.withOpacity(0.5),
                  width: 1,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return BuddySearchScreen(
                    tennisCourtList: tennisCourtList,
                  );
                })).then((_) => _viewModel.input.userReservationList.add(true));
              },
              child: const Text("Join other players"),
            ),
          ),
          const Text(
            "My Reservations:",
            style: TextStyle(fontSize: 18),
          ),
          if (userReservationList.isEmpty)
            const Text("Your reservations will be displayed here"),
          if (futureAndCurrentUserReservationList().isNotEmpty) ...[
            const SizedBox(height: 5),
            const Text(
              "Current & Future:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
          ],
          ...futureAndCurrentUserReservationList().map((e) {
            return ReservationCard(
              reservation: e,
              onTap: showReservationOptions,
            );
          }),
          if (pastAndCancelledUserReservationList().isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              "Past & Canceled:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
          ],
          ...pastAndCancelledUserReservationList().map((e) {
            return ReservationCard(reservation: e);
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void showReservationOptions(Reservation reservation) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AppPopup(
            title: "Reservation Details",
            content: ""
                "Tennis Court: ${reservationTennisCourt(reservation).title}"
                "\nSurface type: ${reservationTennisCourt(reservation).surfaceType.name}"
                "\nLocation: ${reservationTennisCourt(reservation).city}"
                ", ${reservationTennisCourt(reservation).address}"
                "\n\nWould you like to update your reservation?",
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _viewModel.input.searchBuddy.add(reservation);
                    },
                    child: const Text("Search for partner"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _viewModel.input.giveUpReservation.add(reservation);
                    },
                    child: const Text("Switch reservation"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _viewModel.input.cancelReservation.add(reservation);
                    },
                    child: const Text("Cancel reservation"),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _tennisCourtsWidget() {
    if (tennisCourtForHost.isEmpty) {
      return Container();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Courts:",
          style: TextStyle(fontSize: 18),
        ),
        TennisCourtCardList(
          tennisCourtList: tennisCourtForHost,
          onEdit: (tennisCourt) {
            _addOrEditTennisCourt(tennisCourt: tennisCourt);
          },
          onTennisCourt: (tennisCourt) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    CourtReservationsScreen(tennisCourt: tennisCourt)));
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
