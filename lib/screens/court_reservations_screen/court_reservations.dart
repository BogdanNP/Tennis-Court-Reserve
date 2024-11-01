import 'package:court_reserve_app/models/reservation.dart';
import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:court_reserve_app/models/ui_model.dart';
import 'package:court_reserve_app/repositories/reservation_repository.dart';
import 'package:court_reserve_app/screens/court_reservations_screen/court_reservations_view_model.dart';
import 'package:court_reserve_app/widgets/reservation_card_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CourtReservationsScreen extends StatefulWidget {
  final TennisCourt tennisCourt;

  const CourtReservationsScreen({required this.tennisCourt, Key? key})
      : super(key: key);

  @override
  State<CourtReservationsScreen> createState() =>
      _CourtReservationsScreenState();
}

class _CourtReservationsScreenState extends State<CourtReservationsScreen> {
  late CourtReservationsViewModel _viewModel;
  List<Reservation> _reservationList = [];
  bool isLoading = false;

  List<Reservation> futureAndCurrentReservationList() => _reservationList
      .where((element) =>
          element.reserveEndTime.isAfter(DateTime.now()) &&
          element.status != "CANCELED")
      .toList();

  List<Reservation> pastAndCancelledReservationList() => _reservationList
      .where((element) =>
          element.reserveEndTime.isBefore(DateTime.now()) ||
          element.status == "CANCELLED")
      .toList();

  @override
  void initState() {
    _viewModel = CourtReservationsViewModel(
      Input(
        PublishSubject(),
        PublishSubject(),
        PublishSubject(),
      ),
      ReservationRepository(),
    );
    _viewModel.output.onCourtId.listen((event) {
      debugPrint(event.toString());
      setState(() {
        if (event.state == OperationState.success) {
          _reservationList = event.data!;
        }
      });
    });
    _viewModel.output.onReservationAcceptOrDecline.listen((event) {
      setState(() {
        switch (event.state) {
          case OperationState.success:
            isLoading = false;
            _viewModel.input.courtId.add(widget.tennisCourt.courtId!);
            break;
          case OperationState.loading:
            isLoading = true;
            break;
          case OperationState.error:
            isLoading = false;
            String errorMessage = "Something went wrong";
            if (event.error is DioException) {
              errorMessage =
                  (event.error as DioException).response?.data?.toString() ??
                      errorMessage;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  errorMessage,
                ),
              ),
            );
            break;
        }
      });
    });
    _viewModel.input.courtId.add(widget.tennisCourt.courtId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tennisCourt.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _viewModel.input.courtId.add(widget.tennisCourt.courtId!);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: _reservationList.isEmpty
                    ? const Text(
                        "There are no reservations for this court.",
                        style: TextStyle(fontSize: 18),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (futureAndCurrentReservationList().isNotEmpty) ...[
                            const SizedBox(height: 5),
                            const Text(
                              "Current & Future:",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            ReservationCardList(
                              onAccept: (reservation) {
                                _viewModel.input.acceptReservation
                                    .add(reservation);
                              },
                              onDecline: (reservation) {
                                _viewModel.input.declineReservation
                                    .add(reservation);
                              },
                              reservationList:
                                  futureAndCurrentReservationList(),
                            ),
                          ],
                          if (pastAndCancelledReservationList().isNotEmpty) ...[
                            const SizedBox(height: 5),
                            const Text(
                              "Past:",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            ReservationCardList(
                              reservationList:
                                  pastAndCancelledReservationList(),
                            ),
                          ],
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
        ),
      ),
    );
  }
}
