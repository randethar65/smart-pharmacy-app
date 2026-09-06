class SharedPrefKeys {
  SharedPrefKeys._();

  // Secure (encrypted) — tokens only
  static const String userToken = 'userToken'; // access token
  static const String refreshToken = 'refreshToken';

  // Plain — non-sensitive flags
  static const String isLoggedIn = 'isLoggedIn';
}
