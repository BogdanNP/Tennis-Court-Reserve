import 'package:court_reserve_app/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  String toFormattedString() {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String hourLabel = addLeadingZeroIfNeeded(hour);
    final String minuteLabel = addLeadingZeroIfNeeded(minute);

    return '$hourLabel:$minuteLabel';
  }

  Map<String, dynamic> toJson() {
    return {
      "hour": hour,
      "minute": minute,
      "second": 0,
      "nano": 0,
    };
  }

  String toDateTimeAsString() {
    return "${DateTime.now().toApiFormat()}"
        "${toFormattedString()}";
  }

  static TimeOfDay fromDateTimeAsString(String formattedDate,
      {TimeOfDay? fallback}) {
    DateTime? dateTime = DateTime.tryParse(formattedDate);
    if (dateTime == null) {
      return fallback ?? TimeOfDay.now();
    }
    return TimeOfDay.fromDateTime(dateTime);
  }

  static TimeOfDay fromString(String formattedTimeOfDay,
      {TimeOfDay? fallback}) {
    try {
      List<int> time = formattedTimeOfDay.split(":").map((e) {
        return int.parse(e);
      }).toList();
      return TimeOfDay(hour: time[0], minute: time[1]);
    } catch (_) {
      return fallback ?? TimeOfDay.now();
    }
  }
}
