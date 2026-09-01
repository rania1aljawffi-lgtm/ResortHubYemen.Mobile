/// Utility for formatting and parsing dates consistently with ISO-8601 strings from backend.
class DateFormatter {
  DateFormatter._();

  /// Formats a DateTime into standard YYYY-MM-DD format
  static String toDateString(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Parses an ISO 8601 date string safely, fallback to now if invalid
  static DateTime parseDateTimeSafe(dynamic value, [DateTime? fallback]) {
    if (value is DateTime) return value;
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    return fallback ?? DateTime.now();
  }
}
