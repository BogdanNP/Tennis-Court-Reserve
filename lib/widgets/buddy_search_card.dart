import 'dart:convert';

import 'package:court_reserve_app/extensions/date_time_extension.dart';
import 'package:court_reserve_app/models/search_buddy_request.dart';
import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:flutter/material.dart';

class BuddySearchCard extends StatelessWidget {
  final TennisCourt tennisCourt;
  final SearchBuddyRequest searchBuddyRequest;
  final Function(SearchBuddyRequest) onAccept;

  const BuddySearchCard({
    required this.searchBuddyRequest,
    required this.tennisCourt,
    required this.onAccept,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade200,
          borderRadius:
              const BorderRadius.horizontal(right: Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Image.memory(
                    base64Decode(tennisCourt.imageBase46()),
                    fit: BoxFit.fill,
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, _) {
                      return const Icon(
                        Icons.people_alt_rounded,
                        size: 120,
                      );
                    },
                  ),
                ),
                Text(
                  "Status: ${searchBuddyRequest.status}",
                ),
                Text(
                  (searchBuddyRequest.switchReservation)
                      ? "Switch Reservation"
                      : "Looking for players",
                )
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    tennisCourt.title,
                    style: const TextStyle(fontSize: 18),
                    maxLines: 1,
                  ),
                  Text(
                    "${tennisCourt.city}: ${tennisCourt.address}",
                    maxLines: 1,
                  ),
                  Text("Surface: ${tennisCourt.surfaceType.name}"),
                  Text(
                    "Total price: ${searchBuddyRequest.totalPrice.toStringAsFixed(2)} RON",
                  ),
                  Text(
                    "Date: "
                    "${searchBuddyRequest.reserveStartTime.toDayMonthFormat()}",
                  ),
                  Text(
                    "Play time: "
                    "${searchBuddyRequest.reserveStartTime.toHourMinuteFormat()}"
                    " - ${searchBuddyRequest.reserveEndTime.toHourMinuteFormat()}",
                  ),
                  Text(
                    "Players: "
                    "${searchBuddyRequest.numberOfPlayers}",
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            if (searchBuddyRequest.status != "ACCEPTED")
              TextButton(
                onPressed: () => onAccept.call(searchBuddyRequest),
                child: const Text("Accept"),
              ),
          ],
        ),
      ),
    );
  }
}
