import 'package:shoplite/core/constants/app_constants.dart';
import 'package:shoplite/core/constants/app_strings.dart';

/// Input validation and sanitising. Pure Dart, so it is unit-tested
/// (see `test/validators_test.dart`).
abstract final class Validators {
  static final RegExp _usernamePattern = RegExp(r'^[a-zA-Z0-9._-]+$');
  static final RegExp _controlChars = RegExp(r'[\u0000-\u001F\u007F]');
  static final RegExp _whitespaceRuns = RegExp(r'\s+');

  /// Form validator: returns an error message, or null when valid.
  static String? username(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.usernameRequired;
    if (text.length < AppConstants.minUsernameLength ||
        text.length > AppConstants.maxUsernameLength ||
        !_usernamePattern.hasMatch(text)) {
      return AppStrings.usernameInvalid;
    }
    return null;
  }

  /// Form validator: returns an error message, or null when valid.
  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return AppStrings.passwordRequired;
    if (text.length < AppConstants.minPasswordLength) {
      return AppStrings.passwordTooShort;
    }
    if (text.length > AppConstants.maxPasswordLength) {
      return AppStrings.passwordTooLong;
    }
    return null;
  }

  /// Cleans free text before it is sent to the API: strips control
  /// characters, collapses whitespace and caps the length.
  static String sanitizeSearch(String input) {
    final cleaned = input
        .replaceAll(_controlChars, ' ')
        .replaceAll(_whitespaceRuns, ' ')
        .trim();
    if (cleaned.length <= AppConstants.maxSearchLength) return cleaned;
    return cleaned.substring(0, AppConstants.maxSearchLength).trim();
  }

  /// True only for absolute `https://` URLs. Used to refuse insecure
  /// image and API URLs.
  static bool isHttpsUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
  }
}
