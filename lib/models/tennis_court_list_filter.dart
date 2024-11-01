import 'package:court_reserve_app/models/court_date_time_filter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'court_filter.dart';

@JsonSerializable()
class TennisCourtListFilter {
  final List<CourtFilter> filterCriteria;
  final Map<String, dynamic> pageable;

  TennisCourtListFilter(this.filterCriteria)
      : pageable = {
          "size": 10000,
          "page": 0,
          "orderBy": "DESC",
          "sortBy": "CREATED_DATE",
        };

  Map<String, dynamic> toJson() => {
        "filterCriteria":
            filterCriteria.map((filter) => filter.toJson()).toList(),
        "pageable": pageable,
      };

  factory TennisCourtListFilter.all() =>
      TennisCourtListFilter([CourtFilter.title()]);

  factory TennisCourtListFilter.numberOfPlayers({int? numberOfPlayers}) =>
      TennisCourtListFilter(
          [CourtFilter.numberOfPlayers(numberOfPlayers: numberOfPlayers)]);

  factory TennisCourtListFilter.title(String title) =>
      TennisCourtListFilter([CourtFilter.title(title: title)]);

  factory TennisCourtListFilter.courtDateTime(
      CourtDateTimeFilter courtDateTimeFilter) {
    return TennisCourtListFilter(
      [CourtFilter.fromCourtDateTimeFilter(courtDateTimeFilter)],
    );
  }

  factory TennisCourtListFilter.userId(int userId) =>
      TennisCourtListFilter([CourtFilter.userId(userId: "$userId")]);
}
