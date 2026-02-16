
import 'package:intl/intl.dart';

class Utils {
  static String addCurrencyIcon(String price) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatter.format(double.parse(price));
  }
}