class CurrentUser {
  final String token;

  CurrentUser({
    required this.token,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      token: json["token"],
    );
  }
}
