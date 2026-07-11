/// Date helpers for the Russian UI locale.
abstract class DateFormatting {
  static const List<String> _monthsGenitive = <String>[
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  /// Russian month name in genitive case (for "11 июня").
  static String monthGenitive(int month) => _monthsGenitive[month - 1];

  /// Human-readable hike date range.
  ///
  /// - single day: «11 июня»
  /// - same month: «3–5 апреля»
  /// - across months: «30 апреля – 2 мая»
  static String formatHikeDate(DateTime start, DateTime? end) {
    if (end == null || _isSameDay(start, end)) {
      return '${start.day} ${monthGenitive(start.month)}';
    }

    if (start.year == end.year && start.month == end.month) {
      return '${start.day}–${end.day} ${monthGenitive(end.month)}';
    }

    return '${start.day} ${monthGenitive(start.month)} – '
        '${end.day} ${monthGenitive(end.month)}';
  }

  /// Formats a date as `YYYY-MM-DD` for API query parameters.
  static String toApiDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
