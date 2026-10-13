class Validators {
  static const int titleMaxLength = 50;
  static const int emailMaxLength = 254;
  static const int passwordMinLength = 6;
  static const int passwordMaxLength = 72;
  static const double maxAmount = 1000000;

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _amountRegex = RegExp(r'^(\d+(\.\d{0,2})?|\.\d{1,2})$');
  static final RegExp _tooManyDecimals = RegExp(r'^\d*\.\d{3,}$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    if (v.length > emailMaxLength) return 'Email is too long';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < passwordMinLength) {
      return 'Password must be at least $passwordMinLength characters';
    }
    if (v.length > passwordMaxLength) {
      return 'Password must be at most $passwordMaxLength characters';
    }
    if (v.trim() != v) return 'Password cannot start or end with a space';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? title(String? value) {
    final error = required(value, 'Title');
    if (error != null) return error;
    if (value!.trim().length > titleMaxLength) {
      return 'Title must be at most $titleMaxLength characters';
    }
    return null;
  }

  static String? amount(String? value) {
    final cleaned = _normalizeAmount(value);
    if (cleaned.isEmpty) return 'Amount is required';
    if (cleaned.startsWith('-')) return 'Amount must be greater than 0';
    if (_tooManyDecimals.hasMatch(cleaned)) return 'Use at most 2 decimal places';

    final number = parseAmount(value);
    if (number == null) return 'Enter a valid number';
    if (number <= 0) return 'Amount must be greater than 0';
    if (number > maxAmount) return 'Amount must be 1,000,000 or less';
    return null;
  }

  /// Parses user input such as `12`, `12.5`, `12,50`, `1,250.00` or `.5`.
  ///
  /// Returns null for anything that is not a plain positive number, including
  /// values `double.tryParse` would accept such as `NaN`, `Infinity`,
  /// `1e5` and `-3`.
  static double? parseAmount(String? value) {
    var v = _normalizeAmount(value);
    if (!_amountRegex.hasMatch(v)) return null;
    if (v.startsWith('.')) v = '0$v';
    if (v.endsWith('.')) v = '${v}0';
    return double.tryParse(v);
  }

  /// A single comma followed by 1–2 digits is a decimal comma (`12,50`).
  /// Any other comma is a thousands separator (`1,250.00`).
  static String _normalizeAmount(String? value) {
    final v = (value ?? '').trim().replaceAll(' ', '');
    final commaParts = v.split(',');
    final isDecimalComma = !v.contains('.') &&
        commaParts.length == 2 &&
        commaParts[1].isNotEmpty &&
        commaParts[1].length <= 2;
    return isDecimalComma ? v.replaceAll(',', '.') : v.replaceAll(',', '');
  }
}
