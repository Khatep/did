class SignUpRequestDto {
  final String username;
  final String password;

  SignUpRequestDto({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
    };
  }
}
