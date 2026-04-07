import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String shortDate(DateTime date) =>
      DateFormat('dd/MM/yyyy').format(date);

  static String longDate(DateTime date) =>
      DateFormat('d MMMM yyyy', 'es').format(date);

  static String monthYear(DateTime date) =>
      DateFormat('MMMM yyyy', 'es').format(date);

  static String dayMonth(DateTime date) =>
      DateFormat('d MMM', 'es').format(date);

  static String time(DateTime date) =>
      DateFormat('h:mm a').format(date);

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} horas';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} dias';
    return shortDate(date);
  }
}
