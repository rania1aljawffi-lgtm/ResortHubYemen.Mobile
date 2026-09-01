/// Centralized API configuration and endpoints.
/// Supports switching between local environments (Android Emulator, localhost, physical device, production).
class ApiConstants {
  ApiConstants._();

  /// Default base URL for Android Emulator pointing to ASP.NET Core API
  static const String defaultAndroidEmulatorBaseUrl = 'http://10.0.2.2:5021';

  /// Base URL for localhost / Flutter Web
  static const String defaultLocalhostBaseUrl = 'http://localhost:5021';

  /// Base URL for real Android phone on the same Wi-Fi network.
  /// Change this if the computer LAN IP changes.
  static const String physicalDeviceBaseUrl = 'http://192.168.8.192:5021';

  // ── Active base URL ──────────────────────────────────────────────────────
  // Switch to [defaultAndroidEmulatorBaseUrl] when using an Android emulator,
  // or to [defaultLocalhostBaseUrl] when running Flutter Web.
  static String _baseUrl = physicalDeviceBaseUrl;

  /// Gets the active base URL
  static String get baseUrl => _baseUrl;

  /// Sets a custom base URL dynamically (e.g. for testing on physical device with LAN IP)
  static void setCustomBaseUrl(String url) {
    if (url.endsWith('/')) {
      _baseUrl = url.substring(0, url.length - 1);
    } else {
      _baseUrl = url;
    }
  }

  // API Timeout
  static const Duration timeoutDuration = Duration(seconds: 15);

  // Endpoints exactly matching ASP.NET Core controllers
  static const String chaletsEndpoint = '/api/Chalets';
  static const String bookingsEndpoint = '/api/Bookings';
  static const String usersEndpoint = '/api/Users';
  static const String reviewsEndpoint = '/api/Reviews';
  static const String imagesEndpoint = '/api/Images';

  /// Helper to construct full URL
  static Uri buildUri(String endpoint, [Map<String, dynamic>? queryParameters]) {
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final fullUrl = '$_baseUrl$cleanEndpoint';
    return Uri.parse(fullUrl).replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }
}
