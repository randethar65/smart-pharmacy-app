class LoginResponse {
  final String? message;
  final bool? success;
  final String? accessToken;
  final String? refreshToken;

  const LoginResponse({
    this.message,
    this.success,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] as String?,
      success: json['success'] as bool?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}
