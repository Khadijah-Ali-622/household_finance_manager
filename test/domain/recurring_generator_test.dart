import 'package:flutter_test/flutter_test.dart';
import 'package:household_finance_manager/domain/enums/recurring_frequency.dart';
import 'package:household_finance_manager/domain/services/recurring_generator.dart';

void main() {
  List<DateTime> missed({
    required DateTime start,
    DateTime? lastGenerated,
    required DateTime today,
    required RecurringFrequency frequency,
    int intervalN = 1,
    String? customUnit,
    DateTime? endDate,
  }) {
    return RecurringGenerator.missedOccurrences(
      start: start,
      lastGenerated: lastGenerated,
      today: today,
      frequency: frequency,
      intervalN: intervalN,
      customUnit: customUnit,
      endDate: endDate,
    );
  }

  DateTime next(
    DateTime from, {
    required DateTime start,
    required RecurringFrequency frequency,
    int intervalN = 1,
    String? customUnit,
  }) {
    return RecurringGenerator.nextAfter(
      from,
      start: start,
      frequency: frequency,
      intervalN: intervalN,
      customUnit: customUnit,
    );
  }

  group('no duplicates', () {
    test('daily range includes the start and stops at today', () {
      final dates = missed(
        start: DateTime(2025, 1, 1),
        today: DateTime(2025, 1, 5),
        frequency: RecurringFrequency.daily,
      );
      expect(dates, [
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 2),
        DateTime(2025, 1, 3),
        DateTime(2025, 1, 4),
        DateTime(2025, 1, 5),
      ]);
      expect(dates.toSet(), hasLength(dates.length));
    });

    test('a second pass after the last generated date adds nothing', () {
      final first = missed(
        start: DateTime(2025, 1, 1),
        today: DateTime(2025, 1, 5),
        frequency: RecurringFrequency.daily,
      );
      final second = missed(
        start: DateTime(2025, 1, 1),
        lastGenerated: first.last,
        today: DateTime(2025, 1, 5),
        frequency: RecurringFrequency.daily,
      );
      expect(second, isEmpty);
    });

    test('dates on or before lastGenerated are skipped', () {
      final dates = missed(
        start: DateTime(2025, 1, 1),
        lastGenerated: DateTime(2025, 1, 3, 18),
        today: DateTime(2025, 1, 5, 9),
        frequency: RecurringFrequency.daily,
      );
      expect(dates, [DateTime(2025, 1, 4), DateTime(2025, 1, 5)]);
    });

    test('future dates are excluded', () {
      final dates = missed(
        start: DateTime(2025, 1, 8),
        today: DateTime(2025, 1, 10),
        frequency: RecurringFrequency.daily,
      );
      expect(dates, [
        DateTime(2025, 1, 8),
        DateTime(2025, 1, 9),
        DateTime(2025, 1, 10),
      ]);
    });

    test('an end date is inclusive and later days are dropped', () {
      final dates = missed(
        start: DateTime(2025, 1, 1),
        today: DateTime(2025, 1, 10),
        endDate: DateTime(2025, 1, 3),
        frequency: RecurringFrequency.daily,
      );
      expect(dates, [
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 2),
        DateTime(2025, 1, 3),
      ]);
    });

    test('interval of 0 does not loop and behaves as every 1', () {
      final dates = missed(
        start: DateTime(2025, 1, 1),
        today: DateTime(2025, 1, 3),
        frequency: RecurringFrequency.daily,
        intervalN: 0,
      );
      expect(dates, [
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 2),
        DateTime(2025, 1, 3),
      ]);
    });
  });

  group('daily weekly and custom days', () {
    test('daily every 2 days', () {
      final dates = missed(
        start: DateTime(2025, 1, 1),
        today: DateTime(2025, 1, 10),
        frequency: RecurringFrequency.daily,
        intervalN: 2,
      );
      expect(dates, [
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 3),
        DateTime(2025, 1, 5),
        DateTime(2025, 1, 7),
        DateTime(2025, 1, 9),
      ]);
    });

    test('weekly', () {
      final dates = missed(
        start: DateTime(2026, 1, 5),
        today: DateTime(2026, 1, 26),
        frequency: RecurringFrequency.weekly,
      );
      expect(dates, [
        DateTime(2026, 1, 5),
        DateTime(2026, 1, 12),
        DateTime(2026, 1, 19),
        DateTime(2026, 1, 26),
      ]);
    });

    test('custom every 10 days', () {
      final dates = missed(
        start: DateTime(2025, 1, 1),
        today: DateTime(2025, 1, 31),
        frequency: RecurringFrequency.custom,
        intervalN: 10,
        customUnit: 'days',
      );
      expect(dates, [
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 11),
        DateTime(2025, 1, 21),
        DateTime(2025, 1, 31),
      ]);
    });

    test('custom every 3 days does not repeat the last generated day', () {
      final dates = missed(
        start: DateTime(2025, 1, 1),
        lastGenerated: DateTime(2025, 1, 7),
        today: DateTime(2025, 1, 16),
        frequency: RecurringFrequency.custom,
        intervalN: 3,
        customUnit: 'days',
      );
      expect(dates, [
        DateTime(2025, 1, 10),
        DateTime(2025, 1, 13),
        DateTime(2025, 1, 16),
      ]);
    });
  });

  group('month-end on the 31st', () {
    test('non-leap year returns to the 31st after February', () {
      final start = DateTime(2025, 1, 31);
      final dates = missed(
        start: start,
        today: DateTime(2025, 12, 31),
        frequency: RecurringFrequency.monthly,
      );
      expect(dates.map((d) => d.day).toList(), [
        31,
        28,
        31,
        30,
        31,
        30,
        31,
        31,
        30,
        31,
        30,
        31,
      ]);
      expect(dates[1], DateTime(2025, 2, 28));
      expect(dates[2], DateTime(2025, 3, 31));
      expect(dates.toSet(), hasLength(dates.length));
    });

    test('leap year uses 29 February then 31 March', () {
      final start = DateTime(2024, 1, 31);
      expect(
        next(start, start: start, frequency: RecurringFrequency.monthly),
        DateTime(2024, 2, 29),
      );
      expect(
        next(
          DateTime(2024, 2, 29),
          start: start,
          frequency: RecurringFrequency.monthly,
        ),
        DateTime(2024, 3, 31),
      );
    });

    test('next after a clamped February is 31 March, not 28 March', () {
      final start = DateTime(2025, 1, 31);
      expect(
        next(
          DateTime(2025, 2, 28),
          start: start,
          frequency: RecurringFrequency.monthly,
        ),
        DateTime(2025, 3, 31),
      );
    });

    test('lastGenerated in February does not emit February again', () {
      final dates = missed(
        start: DateTime(2025, 1, 31),
        lastGenerated: DateTime(2025, 2, 28),
        today: DateTime(2025, 4, 30),
        frequency: RecurringFrequency.monthly,
      );
      expect(dates, [DateTime(2025, 3, 31), DateTime(2025, 4, 30)]);
    });

    test('custom every 2 months keeps the 31st anchor', () {
      final dates = missed(
        start: DateTime(2025, 1, 31),
        today: DateTime(2025, 7, 31),
        frequency: RecurringFrequency.custom,
        intervalN: 2,
        customUnit: 'months',
      );
      expect(dates, [
        DateTime(2025, 1, 31),
        DateTime(2025, 3, 31),
        DateTime(2025, 5, 31),
        DateTime(2025, 7, 31),
      ]);
    });

    test('end date drops the month that falls after it', () {
      final dates = missed(
        start: DateTime(2025, 1, 31),
        today: DateTime(2025, 6, 1),
        endDate: DateTime(2025, 2, 28),
        frequency: RecurringFrequency.monthly,
      );
      expect(dates, [DateTime(2025, 1, 31), DateTime(2025, 2, 28)]);
    });
  });
}
