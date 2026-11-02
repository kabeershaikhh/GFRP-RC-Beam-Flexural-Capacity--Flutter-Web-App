/// Centralized API configuration for the GFRP-RC Flexural Capacity Analyzer.
/// Edit `_devBaseUrl` or `_prodBaseUrl` in this file when switching to a remote server or IP.
class ApiConfig {
  // Toggle this or change baseUrl when deploying to cloud or remote server
  static const bool isProduction = false;

  static const String _devBaseUrl = "http://127.0.0.1:8000";
  static const String _prodBaseUrl = "https://your-deployed-api.com"; // Replace with your cloud URL / IP

  static String get baseUrl => isProduction ? _prodBaseUrl : _devBaseUrl;
  static String get predictEndpoint => "$baseUrl/predict";
  static String get healthEndpoint => "$baseUrl/";

  static const Duration timeoutDuration = Duration(seconds: 10);
}
