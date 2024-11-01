class ResetPasswordData {
  final String confirmPassword;
  final String password;
  final int userId;

  const ResetPasswordData({
    required this.confirmPassword,
    required this.password,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        "id": userId,
        "password": password,
        "confirmPassword": confirmPassword,
      };
}
