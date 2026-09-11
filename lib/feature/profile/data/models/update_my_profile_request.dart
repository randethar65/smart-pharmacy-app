/// PATCH /api/Profile — partial update: only non-empty fields are sent.
class UpdateMyProfileRequest {
  final String? fullName;
  final String? phoneNumber;
  final String? city;
  final String? street;

  UpdateMyProfileRequest({
    this.fullName,
    this.phoneNumber,
    this.city,
    this.street,
  });

  Map<String, dynamic> toJson() => {
        if (fullName != null && fullName!.trim().isNotEmpty)
          'fullName': fullName!.trim(),
        if (phoneNumber != null && phoneNumber!.trim().isNotEmpty)
          'phoneNumber': phoneNumber!.trim(),
        if (city != null && city!.trim().isNotEmpty) 'city': city!.trim(),
        if (street != null && street!.trim().isNotEmpty) 'street': street!.trim(),
      };
}
