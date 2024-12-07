class SignUpResponseDto {
  final int id;
  final String username;
  final String role;
  final String? firstname;
  final String? lastname;
  final String? address;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  SignUpResponseDto({
    required this.id,
    required this.username,
    required this.role,
    this.firstname,
    this.lastname,
    this.address,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SignUpResponseDto.fromJson(Map<String, dynamic> json) {
    return SignUpResponseDto(
      id: json["id"],
      username: json["username"],
      role: json["role"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      address: json["address"],
      enabled: json["enabled"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}