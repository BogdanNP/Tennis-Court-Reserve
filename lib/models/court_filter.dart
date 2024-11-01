import 'package:court_reserve_app/extensions/date_time_extension.dart';
import 'package:court_reserve_app/models/court_date_time_filter.dart';
import 'package:court_reserve_app/models/tennis_court_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'court_filter.g.dart';

@JsonSerializable()
class CourtFilter {
  final String field;
  final List<String> values;

  CourtFilter({required this.field, required this.values});

  factory CourtFilter.title({String title = ""}) =>
      CourtFilter(field: "TITLE", values: [title]);

  factory CourtFilter.numberOfPlayers({int? numberOfPlayers}) => CourtFilter(
      field: "NUMBER_OF_PLAYERS",
      values: numberOfPlayers == null
          ? ["1", "2", "3", "4"]
          : ["$numberOfPlayers"]);

  factory CourtFilter.userId({String userId = ""}) =>
      CourtFilter(field: "USER_ID", values: [userId]);

  factory CourtFilter.fromCourtDateTimeFilter(
      CourtDateTimeFilter courtDateTimeFilter) {
    DateTime startDate = courtDateTimeFilter.dateTime
        .copyWithTimeOfDay(courtDateTimeFilter.startTime);
    DateTime endDate = courtDateTimeFilter.dateTime
        .copyWithTimeOfDay(courtDateTimeFilter.endTime);
    return CourtFilter.reserveTimeInterval(
      startDate.toApiFormat(),
      endDate.toApiFormat(),
    );
  }

  factory CourtFilter.reserveTimeInterval(
    String reservationStart,
    String reservationEnd,
  ) =>
      CourtFilter(field: "RESERVE_START_END_TIME", values: [
        reservationStart,
        reservationEnd,
      ]);

  factory CourtFilter.priceRange(
    int priceStart,
    int priceEnd,
  ) =>
      CourtFilter(field: "PRICE_BETWEEN", values: [
        "$priceStart",
        "$priceEnd",
      ]);

  factory CourtFilter.type(List<TennisCourtType> types) => CourtFilter(
        field: "TYPE",
        values: types
            .map(
              (e) => e.name.toUpperCase(),
            )
            .toList(),
      );

  factory CourtFilter.fromJson(Map<String, dynamic> json) =>
      _$CourtFilterFromJson(json);

  Map<String, dynamic> toJson() => _$CourtFilterToJson(this);
}
