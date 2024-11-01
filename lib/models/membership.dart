import 'package:court_reserve_app/extensions/date_time_extension.dart';

class Membership {
  final MembershipType type;
  final int numberOfEntries;
  final int price;
  final DateTime? validFrom;
  final DateTime? validTo;

  Membership(
    this.type,
    this.numberOfEntries,
    this.price, {
    this.validFrom,
    this.validTo,
  });

  factory Membership.fromJson(Map<String, dynamic> map) {
    return Membership(
      MembershipType.values.firstWhere(
          (element) => element.name.toUpperCase() == map["membershipTypeDTO"]),
      map["numberOfEntries"],
      map["price"],
      validFrom: DateTime.tryParse(map["validFrom"] ?? ""),
      validTo: DateTime.tryParse(map["validTo"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "membershipTypeDTO": type.name.toUpperCase(),
        "numberOfEntries": numberOfEntries,
        "price": price.truncate(),
      }
        ..addAll(validFrom != null
            ? {"validFrom": validFrom?.toApiFormat() ?? ""}
            : {})
        ..addAll(
            validTo != null ? {"validTo": validTo?.toApiFormat() ?? ""} : {});

  static List<Membership> subscriptions() {
    return [
      Membership(MembershipType.silver, 10, 100),
      Membership(MembershipType.gold, 65, 550),
      Membership(MembershipType.platinum, 130, 950),
    ];
  }

  String availability() {
    return type == MembershipType.silver
        ? "1 Month"
        : type == MembershipType.gold
            ? "6 Months"
            : "12 Months";
  }
}

enum MembershipType {
  silver,
  gold,
  platinum,
}
