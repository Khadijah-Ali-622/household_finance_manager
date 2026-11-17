import '../enums/recurring_frequency.dart';

/// Pure schedule math for recurring rules.
///
/// Dates are calendar days. The anchor day is [start]'s day-of-month, so a
/// rule that begins on the 31st lands on the last day of a shorter month and
/// returns to the 31st when the month is long enough (Jan 31 → Feb 28/29 → Mar 31).
class RecurringGenerator {
  const RecurringGenerator._();

  static const int _maxSteps = 10000;

  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static int normalizeInterval(int intervalN) => intervalN < 1 ? 1 : intervalN;

  static bool isMonthUnit(String? customUnit) {
    final unit = customUnit?.trim().toLowerCase();
    return unit == 'month' || unit == 'months';
  }

  /// The next calendar day strictly after [from].
  static DateTime nextAfter(
    DateTime from, {
    required DateTime start,
    required RecurringFrequency frequency,
    int intervalN = 1,
    String? customUnit,
  }) {
    final origin = dateOnly(from);
    final anchorDay = dateOnly(start).day;
    final step = normalizeInterval(intervalN);

    return switch (frequency) {
      RecurringFrequency.daily => _addDays(origin, step),
      RecurringFrequency.weekly => _addDays(origin, 7 * step),
      RecurringFrequency.monthly => _addMonths(origin, step, anchorDay),
      RecurringFrequency.yearly => _addMonths(origin, 12 * step, anchorDay),
      RecurringFrequency.custom =>
        isMonthUnit(customUnit)
            ? _addMonths(origin, step, anchorDay)
            : _addDays(origin, step),
    };
  }

  /// First occurrence that has not been generated yet.
  ///
  /// When [lastGenerated] is null this is [start], including a start in the past.
  /// Otherwise it is the first date after [lastGenerated] that is also on or
  /// after [start].
  static DateTime nextDue({
    required DateTime start,
    required DateTime? lastGenerated,
    required RecurringFrequency frequency,
    int intervalN = 1,
    String? customUnit,
  }) {
    final startDay = dateOnly(start);
    if (lastGenerated == null) return startDay;

    var cursor = nextAfter(
      lastGenerated,
      start: startDay,
      frequency: frequency,
      intervalN: intervalN,
      customUnit: customUnit,
    );
    var guard = 0;
    while (cursor.isBefore(startDay) && guard < _maxSteps) {
      final upcoming = nextAfter(
        cursor,
        start: startDay,
        frequency: frequency,
        intervalN: intervalN,
        customUnit: customUnit,
      );
      if (!upcoming.isAfter(cursor)) break;
      cursor = upcoming;
      guard++;
    }
    return cursor;
  }

  /// Occurrences that should be generated now.
  ///
  /// Includes dates after [lastGenerated], or on/after [start] when
  /// [lastGenerated] is null. Nothing after [today] or [endDate] is included,
  /// and a date already recorded in [lastGenerated] is never returned again.
  static List<DateTime> missedOccurrences({
    required DateTime start,
    required DateTime? lastGenerated,
    required DateTime today,
    required RecurringFrequency frequency,
    int intervalN = 1,
    String? customUnit,
    DateTime? endDate,
  }) {
    final startDay = dateOnly(start);
    final todayDay = dateOnly(today);
    final endDay = endDate == null ? null : dateOnly(endDate);
    final lastDay = lastGenerated == null ? null : dateOnly(lastGenerated);

    if (endDay != null && endDay.isBefore(startDay)) return const [];

    var cursor = nextDue(
      start: startDay,
      lastGenerated: lastDay,
      frequency: frequency,
      intervalN: intervalN,
      customUnit: customUnit,
    );

    final dates = <DateTime>[];
    var guard = 0;
    while (!cursor.isAfter(todayDay) && guard < _maxSteps) {
      if (endDay != null && cursor.isAfter(endDay)) break;
      final afterLast = lastDay == null || cursor.isAfter(lastDay);
      final onOrAfterStart = !cursor.isBefore(startDay);
      if (afterLast && onOrAfterStart) {
        dates.add(cursor);
      }
      final upcoming = nextAfter(
        cursor,
        start: startDay,
        frequency: frequency,
        intervalN: intervalN,
        customUnit: customUnit,
      );
      if (!upcoming.isAfter(cursor)) break;
      cursor = upcoming;
      guard++;
    }
    return dates;
  }

  static DateTime _addDays(DateTime from, int days) =>
      DateTime(from.year, from.month, from.day + days);

  static DateTime _addMonths(DateTime from, int months, int anchorDay) {
    final monthIndex = (from.year * 12 + (from.month - 1)) + months;
    final year = monthIndex ~/ 12;
    final month = monthIndex % 12 + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = anchorDay > lastDay ? lastDay : anchorDay;
    return DateTime(year, month, day);
  }
}
