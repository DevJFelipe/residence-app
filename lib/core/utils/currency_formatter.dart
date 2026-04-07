import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _format = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
  );

  static String format(double amount) => _format.format(amount);

  static String compact(double amount) {
    if (amount >= 1e9) {
      return '\$${(amount / 1e9).toStringAsFixed(1)}B';
    }
    if (amount >= 1e6) {
      return '\$${(amount / 1e6).toStringAsFixed(1)}M';
    }
    if (amount >= 1e3) {
      return '\$${(amount / 1e3).toStringAsFixed(0)}K';
    }
    return format(amount);
  }
}
