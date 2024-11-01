import 'package:court_reserve_app/extensions/time_extension.dart';
import 'package:court_reserve_app/models/court_rate.dart';
import 'package:court_reserve_app/models/tennis_court_type.dart';
import 'package:flutter/material.dart';

class TennisCourt {
  final int? courtId;
  final int? userId;
  final String title;
  final String city;
  final String address;
  final TennisCourtType surfaceType;
  final double pricePerHour;
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;
  final int numberOfPlayers;
  final List<dynamic> imagesData;
  final CourtRate? courtRate;

  TennisCourt({
    this.courtId,
    this.userId,
    required this.title,
    required this.city,
    required this.address,
    required this.surfaceType,
    required this.pricePerHour,
    required this.openingTime,
    required this.closingTime,
    this.numberOfPlayers = 4,
    this.imagesData = const [],
    this.courtRate,
  });

  factory TennisCourt.fromJson(Map<String, dynamic> json) {
    return TennisCourt(
      courtId: json["courtId"],
      title: json["title"],
      city: json["city"],
      address: json["address"],
      surfaceType: (json["type"] as String).toTennisCourtType(),
      pricePerHour: double.tryParse("${json["pricePerHour"]}") ?? 20.0,
      openingTime: TimeOfDayExtension.fromString(json["openingTime"],
          fallback: const TimeOfDay(hour: 7, minute: 0)),
      closingTime: TimeOfDayExtension.fromString(json["closingTime"],
          fallback: const TimeOfDay(hour: 22, minute: 0)),
      imagesData: json["imagesData"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "city": city,
      "address": address,
      "type": surfaceType.name.toUpperCase(),
      "openingTime": openingTime.toFormattedString(),
      "closingTime": closingTime.toFormattedString(),
      "numberOfPlayers": numberOfPlayers,
    };
  }

  void validate() {
    if (title.isEmpty) {
      throw Exception("Name should not be empty");
    } else if (city.isEmpty) {
      throw Exception("City should not be empty");
    } else if (address.isEmpty) {
      throw Exception("Address should not be empty");
    }
  }

  String imageBase46() {
    return imagesData.map((e) => e["imageData"]).lastWhere(
          (e) => e != "",
          orElse: () => "",
        );
  }
}
