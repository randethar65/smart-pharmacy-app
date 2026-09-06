class RegisterRequest {
  final String fullName;
  final String userName;
  final String email;
  final String password;
  final String phoneNumber;

  RegisterRequest({
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "userName": userName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
    };
  }
}