import 'package:intl/intl.dart';

convertTextFormat(int value) {
  return NumberFormat.compactCurrency(
    decimalDigits: 0,
    symbol: '',
  ).format(value);
}
