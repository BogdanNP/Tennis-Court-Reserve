import 'package:flutter/material.dart';

class CourtRate {
  final int workdayHourlyPrice;
  final int weekendHourlyPrice;
  final int nightTariff;
  final int courtId;
  final int id;

  CourtRate(
    this.workdayHourlyPrice,
    this.weekendHourlyPrice,
    this.nightTariff, {
    this.courtId = 0,
    this.id = 0,
  });

  CourtRate copyWith({int? courtId}) {
    return CourtRate(
      workdayHourlyPrice,
      weekendHourlyPrice,
      nightTariff,
      courtId: courtId ?? this.courtId,
      id: id,
    );
  }

  int getPrice(int hours, DateTime dateTime) {
    int price = workdayHourlyPrice;
    if (dateTime.weekday == DateTime.saturday ||
        dateTime.weekday == DateTime.sunday) {
      price = weekendHourlyPrice;
    }

    price *= hours;

    if (TimeOfDay.fromDateTime(dateTime).hour >= 20) {
      price += nightTariff;
    }

    return price;
  }

  factory CourtRate.fromJson(Map<String, dynamic> map) {
    return CourtRate(
      map["workdayHourlyPrice"],
      map["weekendHourlyPrice"],
      map["nightTariff"],
      courtId: map["courtId"],
      id: map["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "courtId": courtId,
        "workdayHourlyPrice": workdayHourlyPrice,
        "weekendHourlyPrice": weekendHourlyPrice,
        "nightTariff": nightTariff,
      };
}
