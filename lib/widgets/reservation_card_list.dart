import 'package:court_reserve_app/models/reservation.dart';
import 'package:court_reserve_app/widgets/reservation_card.dart';
import 'package:flutter/material.dart';

class ReservationCardList extends StatelessWidget {
  final List<Reservation> reservationList;
  final Function(Reservation)? onAccept;
  final Function(Reservation)? onDecline;
  const ReservationCardList({
    required this.reservationList,
    this.onAccept,
    this.onDecline,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: reservationList
          .map((reservation) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: ReservationCard(
                  reservation: reservation,
                  onAccept: onAccept,
                  onDecline: onDecline,
                ),
              ))
          .toList(),
    );
  }
}
