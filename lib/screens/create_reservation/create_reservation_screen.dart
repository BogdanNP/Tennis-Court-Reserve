import 'dart:convert';

import 'package:court_reserve_app/extensions/date_time_extension.dart';
import 'package:court_reserve_app/extensions/time_extension.dart';
import 'package:court_reserve_app/models/court_rate.dart';
import 'package:court_reserve_app/models/court_reserve.dart';
import 'package:court_reserve_app/models/reservation.dart';
import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/court_rates_repository.dart';
import 'package:court_reserve_app/repositories/reservation_repository.dart';
import 'package:court_reserve_app/screens/create_reservation/create_reservation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CreateReservationScreen extends StatefulWidget {
  final Reservation? reservation;
  final TennisCourt tennisCourt;
  final DateTime reservationDate;

  const CreateReservationScreen({
    this.reservation,
    required this.tennisCourt,
    required this.reservationDate,
    Key? key,
  }) : super(key: key);

  @override
  State<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  late CreateReservationViewModel _viewModel;
  TimeOfDay _startTime = TimeOfDay.now()
      .replacing(minute: 0, hour: (TimeOfDay.now().hour + 1) % 24);
  TimeOfDay _endTime = TimeOfDay.now()
      .replacing(minute: 0, hour: (TimeOfDay.now().hour + 2) % 24);
  int _players = 1;
  CourtRate? _courtRate;

  double _totalPrice() {
    if (_courtRate != null) {
      return _courtRate!
          .getPrice(
            (_endTime.hour - _startTime.hour),
            widget.reservationDate.copyWithTimeOfDay(_startTime),
          )
          .toDouble();
    }
    return widget.tennisCourt.pricePerHour * (_endTime.hour - _startTime.hour);
  }

  bool isLoading = false;

  @override
  void initState() {
    _viewModel = CreateReservationViewModel(
      Input(
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
      ),
      ReservationRepository(),
      CourtRatesRepository(),
    );
    _viewModel.output.onRate.listen((event) {
      switch (event.state) {
        case OperationState.success:
          setState(() {
            isLoading = false;
            _courtRate = event.data;
          });
        case OperationState.loading:
          setState(() {
            isLoading = true;
          });
        case OperationState.error:
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${event.error}",
              ),
            ),
          );
      }
    });
    _viewModel.input.init.add(widget.tennisCourt.courtId!);

    _viewModel.output.onSave.listen((event) {
      switch (event.state) {
        case OperationState.success:
          Navigator.of(context).pop(true);
        case OperationState.loading:
          setState(() {
            isLoading = true;
          });
        case OperationState.error:
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${event.error}",
              ),
            ),
          );
      }
    });
    _viewModel.output.onUpdate.listen((event) {
      switch (event.state) {
        case OperationState.success:
          Navigator.of(context).pop(true);
        case OperationState.loading:
          setState(() {
            isLoading = true;
          });
        case OperationState.error:
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${event.error}",
              ),
            ),
          );
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
        title: Text(widget.tennisCourt.title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Image.memory(
                  base64Decode(widget.tennisCourt.imageBase46()),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, _) {
                    return Container();
                  },
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Date: ${widget.reservationDate.toDayMonthYearFormat()}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Location: ${widget.tennisCourt.city}, ${widget.tennisCourt.address}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Open: ${widget.tennisCourt.openingTime.toFormattedString()} - ${widget.tennisCourt.closingTime.toFormattedString()}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Surface type: ${widget.tennisCourt.surfaceType.name.replaceFirst("g", "G").replaceFirst("c", "C").replaceFirst("h", "H")}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (_courtRate != null) ...[
                        Text(
                          "Monday-Friday price per hour: ${_courtRate!.workdayHourlyPrice.toDouble().toStringAsFixed(2)} RON",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Weekend price per hour: ${_courtRate!.weekendHourlyPrice.toDouble().toStringAsFixed(2)} RON",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Night time additional price/game: ${_courtRate!.nightTariff.toDouble().toStringAsFixed(2)} RON",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showTimePicker(
                                      context: context, initialTime: _startTime)
                                  .then((selectedTime) {
                                if (selectedTime != null) {
                                  setState(() {
                                    _startTime = selectedTime;
                                    if (_startTime.hour >= _endTime.hour) {
                                      _endTime = TimeOfDay(
                                          hour: _startTime.hour + 1, minute: 0);
                                    }
                                  });
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                                "Start time: ${_startTime.toFormattedString()}"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showTimePicker(
                                      context: context, initialTime: _endTime)
                                  .then((selectedTime) {
                                if (selectedTime != null) {
                                  setState(() {
                                    _endTime = selectedTime;
                                    if (_endTime.hour <= _startTime.hour) {
                                      _startTime = TimeOfDay(
                                          hour: _endTime.hour - 1, minute: 0);
                                    }
                                  });
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                                "End time: ${_endTime.toFormattedString()}"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (players) => setState(() {
                          _players = int.tryParse(players) ?? 0;
                        }),
                        decoration: const InputDecoration(
                          hintText: "Number of players",
                        ),
                      ),
                      if (widget.reservation != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          "Old Total Price: ${widget.reservation!.totalPrice!.toStringAsFixed(2)} RON",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                        "${widget.reservation != null ? "New " : ""}"
                        "Total Price: ${_totalPrice().toStringAsFixed(2)} RON",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _createReservation,
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              widget.reservation != null ? "Update" : "Reserve",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
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

  void _createReservation() {
    CourtReserve courtReserve = CourtReserve(
      courtId: widget.tennisCourt.courtId!,
      reserveStartTime: widget.reservationDate.copyWithTimeOfDay(_startTime),
      reserveEndTime: widget.reservationDate.copyWithTimeOfDay(_endTime),
      numberOfPlayers: _players,
      courtReserveId: widget.reservation?.courtReserveId,
    );
    if (widget.reservation != null) {
      _viewModel.input.update.add(courtReserve);
    } else {
      _viewModel.input.save.add(courtReserve);
    }
  }
}
