abstract class ApiEnvironment {
  // dart run build_runner build
  // static const String baseUrl = "http://192.168.0.183:8081";
  static const String baseUrl = "http://10.0.2.2:8081";
  static const String userManagementUrl = "$baseUrl/user-management";
  static const String tennisCourtManagementUrl = "$baseUrl/court-management";
  static const String courtReserveManagementUrl =
      "$baseUrl/court-reserve-management";
  static const String searchBuddyManagementUrl =
      "$baseUrl/search-buddy-management";
  static const String membershipManagementUrl =
      "$baseUrl/membership-management";
  static const String courtRatesManagementUrl =
      "$baseUrl/court-rates-management";

  static String ipAddress = "10.0.2.2";
  static String getBaseUrl() => "http://$ipAddress:8081";
  static String getUserManagementUrl() => "${getBaseUrl()}/user-management";
  static String getTennisCourtManagementUrl() =>
      "${getBaseUrl()}/court-management";
  static String getCourtReserveManagementUrl() =>
      "${getBaseUrl()}/court-reserve-management";
  static String getSearchBuddyManagementUrl() =>
      "${getBaseUrl()}/search-buddy-management";
  static String getMembershipManagementUrl() =>
      "${getBaseUrl()}/membership-management";
  static String getCourtRatesManagementUrl() =>
      "${getBaseUrl()}/court-rates-management";
}
