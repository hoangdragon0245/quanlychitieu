import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dayMonthYear = DateFormat('dd/MM/yyyy');
  static final DateFormat _dayMonth = DateFormat('dd/MM');
  static final DateFormat _monthYear = DateFormat('MM/yyyy');
  static final DateFormat _fullDateTime = DateFormat('HH:mm - dd/MM/yyyy');
  static final DateFormat _timeOnly = DateFormat('HH:mm');

  static String formatFull(DateTime dateTime) {
    return _fullDateTime.format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return _dayMonthYear.format(dateTime);
  }

  static String formatDayMonth(DateTime dateTime) {
    return _dayMonth.format(dateTime);
  }

  static String formatMonthYear(DateTime dateTime) {
    return _monthYear.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return _timeOnly.format(dateTime);
  }

  static String relativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final diffDays = today.difference(date).inDays;

    if (diffDays == 0) return 'Hôm nay';
    if (diffDays == 1) return 'Hôm qua';
    if (diffDays == -1) return 'Ngày mai';
    return formatDate(dateTime);
  }
}
