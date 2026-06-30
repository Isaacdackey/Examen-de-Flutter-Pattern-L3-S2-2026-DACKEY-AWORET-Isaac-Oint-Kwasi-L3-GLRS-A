import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount, {String currency = 'XOF'}) {
    final formatter = NumberFormat.currency(
      locale: 'fr_SN',
      symbol: '',
      decimalDigits: 0,
    );
    return '${formatter.format(amount)} $currency';
  }

  static String formatPhone(String phone) {
    if (phone.length == 12 && phone.startsWith('221')) {
      return '+221 ${phone.substring(3, 5)} ${phone.substring(5, 8)} ${phone.substring(8, 10)} ${phone.substring(10, 12)}';
    }
    if (phone.length == 9 && phone.startsWith('77')) {
      return '+221 ${phone.substring(0, 2)} ${phone.substring(2, 5)} ${phone.substring(5, 7)} ${phone.substring(7, 9)}';
    }
    return phone;
  }

  static String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  static String formatShortDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
