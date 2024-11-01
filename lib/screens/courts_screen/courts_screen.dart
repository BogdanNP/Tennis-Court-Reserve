import 'package:court_reserve_app/extensions/date_time_extension.dart';
import 'package:court_reserve_app/extensions/time_extension.dart';
import 'package:court_reserve_app/models/court_date_time_filter.dart';
import 'package:court_reserve_app/models/court_filter.dart';
import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:court_reserve_app/models/tennis_court_list_filter.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/models/user.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';
import 'package:court_reserve_app/repositories/tennis_court_repository.dart';
import 'package:court_reserve_app/screens/courts_screen/courts_view_model.dart';
import 'package:court_reserve_app/screens/create_reservation/create_reservation_screen.dart';
import 'package:court_reserve_app/widgets/app_popup.dart';
import 'package:court_reserve_app/widgets/tennis_court_card_list.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CourtsScreen extends StatefulWidget {
  final VoidCallback navigateToReservations;

  const CourtsScreen({Key? key, required this.navigateToReservations})
      : super(key: key);

  @override
  State<CourtsScreen> createState() => _CourtsScreenState();
}

class _CourtsScreenState extends State<CourtsScreen> {
  late CourtsViewModel _viewModel;
  List<TennisCourt> tennisCourtList = [];
  bool isLoading = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now().replacing(
    hour: (TimeOfDay.now().hour + 1) % 24,
    minute: 0,
  );
  TimeOfDay _endTime = TimeOfDay.now().replacing(
    hour: (TimeOfDay.now().hour + 2) % 24,
    minute: 0,
  );
  String _searchTitle = "";
  RangeValues _priceRangeValues = const RangeValues(0, 100);

  CourtDateTimeFilter _courtDateTimeFilter() => CourtDateTimeFilter(
        dateTime: _selectedDate,
        endTime: _endTime,
        startTime: _startTime,
      );

  TennisCourtListFilter _tennisCourtListFilter() => TennisCourtListFilter([
        CourtFilter.fromCourtDateTimeFilter(_courtDateTimeFilter()),
        CourtFilter.title(title: _searchTitle),
        // CourtFilter.priceRange(
        //   _priceRangeValues.start.truncate(),
        //   _priceRangeValues.end.truncate(),
        // ),
      ]);
  User? user;

  @override
  void initState() {
    _viewModel = CourtsViewModel(
      Input(
        PublishSubject(),
        PublishSubject(),
      ),
      TennisCourtRepository(),
      AuthenticationRepository(),
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

    _viewModel.output.onCourts.listen((event) {
      setState(() {
        switch (event.state) {
          case OperationState.success:
            isLoading = false;
            tennisCourtList = event.data!;
          case OperationState.loading:
            isLoading = true;
          case OperationState.error:
            isLoading = false;
        }
      });
    });
    _viewModel.input.currentUser.add(true);
    _viewModel.input.courts.add(_tennisCourtListFilter());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _viewModel.input.courts.add(_tennisCourtListFilter());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text("Reservation Date Time Interval:"),
              Wrap(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365),
                        ),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          setState(() {
                            _selectedDate = selectedDate;
                          });
                        }
                      });
                    },
                    child: Text("Date: ${_selectedDate.toDayMonthFormat()}"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showTimePicker(context: context, initialTime: _startTime)
                          .then((selectedTime) {
                        if (selectedTime != null) {
                          setState(() {
                            _startTime = selectedTime;
                            _viewModel.input.courts
                                .add(_tennisCourtListFilter());
                          });
                        }
                      });
                    },
                    child: Text("Start: ${_startTime.toFormattedString()}"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showTimePicker(context: context, initialTime: _endTime)
                          .then((selectedTime) {
                        if (selectedTime != null) {
                          setState(() {
                            _endTime = selectedTime;
                            _viewModel.input.courts
                                .add(_tennisCourtListFilter());
                          });
                        }
                      });
                    },
                    child: Text("End: ${_endTime.toFormattedString()}"),
                  ),
                ],
              ),
              // Text(
              //   "Price range: "
              //   "${_priceRangeValues.start.truncate()} - "
              //   "${_priceRangeValues.end.truncate()}",
              // ),
              // RangeSlider(
              //   min: 0,
              //   max: 100,
              //   divisions: 10,
              //   values: _priceRangeValues,
              //   onChanged: (newRangeValues) {
              //     setState(() {
              //       _priceRangeValues = newRangeValues;
              //       _viewModel.input.courts.add(_tennisCourtListFilter());
              //     });
              //   },
              // ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Tennis Court Name",
                ),
                onChanged: (e) {
                  _searchTitle = e;
                },
                onSubmitted: (_) {
                  _viewModel.input.courts.add(_tennisCourtListFilter());
                },
              ),
              const SizedBox(height: 5),
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
                    _viewModel.input.courts.add(_tennisCourtListFilter());
                  },
                  child: const Text("Search"),
                ),
              ),
              const SizedBox(height: 10),
              TennisCourtCardList(
                tennisCourtList: tennisCourtList,
                onTennisCourt: (tennisCourt) {
                  if (user == null) {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return AppPopup(
                            title: "Create Reservation",
                            content:
                                "In order to create a reservation you need to "
                                "login or register. Go to profile page for that.",
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      widget.navigateToReservations();
                                    },
                                    child: const Text("Login or Register"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                    return;
                  }
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CreateReservationScreen(
                      reservationDate: _selectedDate,
                      tennisCourt: tennisCourt,
                    );
                  })).then((reservationWasCreated) {
                    if (reservationWasCreated == true) {
                      widget.navigateToReservations();
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
