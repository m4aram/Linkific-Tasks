/// App-wide configuration values. Nothing here is a secret.
abstract final class AppConstants {
  static const String appName = 'ShopLite';
  static const String appVersion = '1.0.0';

  /// Override at build time with `--dart-define=API_BASE_URL=https://...`.
  /// Only `https://` URLs are accepted (see `api_client.dart`).
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dummyjson.com',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Products fetched per request (lazy loading / pagination).
  static const int pageSize = 20;

  /// Start loading the next page this many pixels before the list end.
  static const double loadMoreThreshold = 400;

  static const Duration searchDebounce = Duration(milliseconds: 400);
  static const int maxSearchLength = 50;

  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 64;

  /// Lifetime requested for the access token, in minutes.
  static const int sessionMinutes = 60;

  static const String databaseName = 'shoplite.db';
  static const int databaseVersion = 1;
}

/// Keys used with the encrypted key-value storage.
abstract final class StorageKeys {
  static const String authToken = 'auth_token';
}

/// REST endpoints, relative to [AppConstants.apiBaseUrl].
abstract final class ApiEndpoints {
  static const String login = '/auth/login';
  static const String currentUser = '/auth/me';
  static const String products = '/products';
  static const String productSearch = '/products/search';
}
