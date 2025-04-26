import 'dart:ui';

abstract class AppConstants {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const int minPasswordLength = 8;
  static const double defaultPadding = 16.0;
  static const Color primaryColor = Color(0xFF7B61FF);
}
