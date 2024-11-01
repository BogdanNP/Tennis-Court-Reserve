import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  DateTime copyWithTimeOfDay(TimeOfDay timeOfDay) {
    return DateUtils.dateOnly(this).copyWith(
      hour: timeOfDay.hour,
      minute: timeOfDay.minute,
    );
  }

  String toDayMonthFormat() {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String dayLabel = addLeadingZeroIfNeeded(day);
    final String monthLabel = addLeadingZeroIfNeeded(month);
    return "$dayLabel/$monthLabel";
  }

  String toDayMonthYearFormat() {
    return "${toDayMonthFormat()}/$year";
  }

  String toHourMinuteFormat() {
    String addLeadingZeroIfNeeded(int value) {
      if (value < 10) {
        return '0$value';
      }
      return value.toString();
    }

    final String hourLabel = addLeadingZeroIfNeeded(hour);
    final String minuteLabel = addLeadingZeroIfNeeded(minute);
    return "$hourLabel:$minuteLabel";
  }

  String toApiFormat() {
    return toIso8601String().substring(0, 16).replaceAll("T", " ");
  }
}
