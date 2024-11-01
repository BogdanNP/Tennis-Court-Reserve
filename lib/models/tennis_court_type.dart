enum TennisCourtType {
  grass,
  clay,
  hard,
}

extension TennisCourtTypeStringExtension on String {
  TennisCourtType toTennisCourtType() {
    if (this == "GRASS") {
      return TennisCourtType.grass;
    } else if (this == "CLAY") {
      return TennisCourtType.clay;
    }
    return TennisCourtType.hard;
  }
}
