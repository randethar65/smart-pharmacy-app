class RegisterResponse {
  final String message;
  final bool success;
  final List<String>? errors;

  RegisterResponse({
    required this.message,
    required this.success,
    this.errors,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
      errors: (json['errors'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
