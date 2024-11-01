import 'dart:convert';

import 'package:court_reserve_app/extensions/time_extension.dart';
import 'package:court_reserve_app/models/tennis_court.dart';
import 'package:flutter/material.dart';

class TennisCourtCard extends StatelessWidget {
  final TennisCourt tennisCourt;
  final Function(TennisCourt) onTennisCourt;
  final Function(TennisCourt)? onEdit;

  const TennisCourtCard({
    required this.tennisCourt,
    required this.onTennisCourt,
    this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTennisCourt(tennisCourt),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Image.memory(
                base64Decode(tennisCourt.imageBase46()),
                fit: BoxFit.fill,
                width: 120,
                height: 120,
                errorBuilder: (context, error, _) {
                  return Container(
                    color: Colors.blueGrey.shade300,
                    child: const Icon(
                      Icons.image_sharp,
                      size: 120,
                    ),
                  );
                },
              ),
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
                    maxLines: 2,
                  ),
                  Text("Surface type: ${tennisCourt.surfaceType.name}"),
                  // Text(
                  //     "Price per hour: ${tennisCourt.pricePerHour.toStringAsFixed(2)} RON"),
                  Text(
                    "Available: ${tennisCourt.openingTime.toFormattedString()} - ${tennisCourt.closingTime.toFormattedString()}",
                  ),
                ],
              ),
            ),
            if (onEdit != null)
              TextButton(
                onPressed: () => onEdit?.call(tennisCourt),
                child: const Text("Edit"),
              ),
          ],
        ),
      ),
    );
  }
}
