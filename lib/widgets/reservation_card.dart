import 'package:court_reserve_app/extensions/date_time_extension.dart';
import 'package:court_reserve_app/models/reservation.dart';
import 'package:flutter/material.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final Function(Reservation)? onTap;
  final Function(Reservation)? onAccept;
  final Function(Reservation)? onDecline;

  const ReservationCard({
    required this.reservation,
    this.onTap,
    this.onAccept,
    this.onDecline,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!.call(reservation) : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              color: Colors.blueGrey.shade300,
              child: Icon(
                Icons.sports_tennis_outlined,
                color: reservation.status == "PENDING"
                    ? Colors.orangeAccent
                    : reservation.status == "ACCEPTED"
                        ? Colors.lightGreen
                        : reservation.status == "CANCELED"
                            ? Colors.redAccent
                            : Colors.grey.shade200,
                size: 120,
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Players: ${reservation.numberOfPlayers}"),
                Text(
                    "Date: ${reservation.reserveStartTime.toDayMonthYearFormat()} "),
                Text(
                  "Interval: ${reservation.reserveStartTime.toHourMinuteFormat()} - "
                  "${reservation.reserveEndTime.toHourMinuteFormat()}",
                ),
                Text("Status: ${reservation.status}"),
                Text(
                  "Total price: ${reservation.totalPrice?.toStringAsFixed(2)} RON",
                ),
              ],
            )),
            if (reservation.status == "PENDING")
              Column(
                children: [
                  if (onAccept != null)
                    IconButton(
                      color: Colors.grey,
                      onPressed: () => onAccept!.call(reservation),
                      icon: const Icon(
                        Icons.check_outlined,
                        color: Colors.green,
                      ),
                    ),
                  if (onDecline != null)
                    IconButton(
                      onPressed: () => onDecline!.call(reservation),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
