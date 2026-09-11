/// GET /api/Profile
class MyProfileResponse {
  final String? fullName;
  final String email;
  final String? phoneNumber;
  final String? city;
  final String? street;
  final String? avatarUrl;

  MyProfileResponse({
    this.fullName,
    required this.email,
    this.phoneNumber,
    this.city,
    this.street,
    this.avatarUrl,
  });

  factory MyProfileResponse.fromJson(Map<String, dynamic> json) =>
      MyProfileResponse(
        fullName: json['fullName'] as String?,
        email: json['email'] as String? ?? '',
        phoneNumber: json['phoneNumber'] as String?,
        city: json['city'] as String?,
        street: json['street'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
      );
}
