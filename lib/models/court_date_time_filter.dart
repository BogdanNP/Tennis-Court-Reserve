import 'package:flutter/material.dart';

class CourtDateTimeFilter {
  final DateTime dateTime;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  CourtDateTimeFilter({
    required this.dateTime,
    required this.endTime,
    required this.startTime,
  });

  CourtDateTimeFilter copyWith({
    DateTime? dateTime,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) =>
      CourtDateTimeFilter(
        dateTime: dateTime ?? this.dateTime,
        endTime: endTime ?? this.endTime,
        startTime: startTime ?? this.startTime,
      );
}
