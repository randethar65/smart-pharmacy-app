class ForgetPasswordResponse {
  final String message;
  final bool success;

  ForgetPasswordResponse({
    required this.message,
    required this.success,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponse(
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
    );
  }
}
