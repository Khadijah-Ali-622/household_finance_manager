import 'package:intl/intl.dart';

final _dayKey = DateFormat('yyyy-MM-dd');
final _displayDay = DateFormat('EEE, d MMM yyyy');
final _displayMonth = DateFormat('MMMM yyyy');

String dayKey(DateTime date) => _dayKey.format(date);

String formatDayHeader(DateTime date) => _displayDay.format(date);

String formatMonth(DateTime date) => _displayMonth.format(date);

DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month, 1);

DateTime endOfMonth(DateTime date) =>
    DateTime(date.year, date.month + 1, 1).subtract(const Duration(milliseconds: 1));

DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime endOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
