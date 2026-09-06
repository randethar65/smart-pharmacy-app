class CheckoutRequest {
  /// 'Cash' or 'Visa' — the backend enum is serialized as a string.
  final String paymentMethod;
  final String? phoneNumber;
  final String? city;
  final String? street;

  /// Unique per checkout attempt so a retry can't create a second order.
  final String idempotencyKey;

  CheckoutRequest({
    required this.paymentMethod,
    required this.idempotencyKey,
    this.phoneNumber,
    this.city,
    this.street,
  });

  Map<String, dynamic> toJson() => {
        'paymentMethod': paymentMethod,
        'idempotencyKey': idempotencyKey,
        // Omit blanks so the backend falls back to the profile address.
        if (city != null && city!.isNotEmpty) 'city': city,
        if (street != null && street!.isNotEmpty) 'street': street,
        if (phoneNumber != null && phoneNumber!.isNotEmpty)
          'phoneNumber': phoneNumber,
      };
}
