const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String _two(int n) => n.toString().padLeft(2, '0');

/// ISO date used for storage, e.g. `2026-10-13`.
String formatDate(DateTime date) {
  return '${date.year}-${_two(date.month)}-${_two(date.day)}';
}

/// Human date for the UI: "Today", "Yesterday" or "Oct 13, 2026".
String formatFriendlyDate(DateTime date, {DateTime? now}) {
  final today = _dateOnly(now ?? DateTime.now());
  final day = _dateOnly(date);
  final difference = today.difference(day).inDays;
  if (difference == 0) return 'Today';
  if (difference == 1) return 'Yesterday';
  final month = _monthNames[date.month - 1].substring(0, 3);
  return '$month ${date.day}, ${date.year}';
}

/// "October 2026"
String formatMonth(DateTime date) {
  return '${_monthNames[date.month - 1]} ${date.year}';
}

/// Money with thousand separators, e.g. `$1,234,567.80`.
String formatAmount(double amount) {
  final fixed = amount.abs().toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0];

  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }

  final isNegative = amount < 0 && fixed != '0.00';
  return '${isNegative ? '-' : ''}\$$buffer.${parts[1]}';
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
