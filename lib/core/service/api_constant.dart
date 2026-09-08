class ApiConstants {
  static const String apiBaseUrl = "https://smartpharmacy-rand.runasp.net";

  static const String login = "/api/Authentications/login";
  static const String register = "/api/Authentications/register";
  static const String requestResetPassword =
      "/api/Authentications/request-reset-password";
  static const String resetPassword = "/api/Authentications/reset-password";
  static const String refreshToken = "/api/Authentications/refresh-token";
  static const String logout = "/api/Authentications/logout";
  static const String getAllCategories = "/api/Categories";
  static const String getAllProducts = "/api/Products";
  static const String getProduct =
      "/api/Products"; // Add product ID after this endpoint
  static const String addToCart = "/api/Cart";
  static const String getCart = "/api/Cart";
  static const String removeFromCart = "/api/Cart";
  static const String updateQuantityCart = "/api/Cart";
  static const String checkout = "/api/Checkout";
  static const String uploadPrescription = "/api/Prescriptions";
  static const String userOrders = "/api/Orders";
  static const String userOrderDetails = "/api/Orders";
}
