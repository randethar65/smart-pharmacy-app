class CheckoutResponse {
  final bool success;
  final int? orderId;
  final bool requiresPrescription;

  /// Set only by `POST /api/Checkout/{orderId}/pay` for a Visa order — the
  /// hosted Stripe page to open. Null for Cash.
  final String? checkoutUrl;
  final String? errorMessage;

  CheckoutResponse({
    required this.success,
    this.orderId,
    this.requiresPrescription = false,
    this.checkoutUrl,
    this.errorMessage,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      success: json['success'] as bool? ?? false,
      orderId: json['orderId'] as int?,
      requiresPrescription: json['requiresPrescription'] as bool? ?? false,
      checkoutUrl: json['checkoutUrl'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}
