import 'package:intl/intl.dart';

String getCurrencyFormatted(double amount) {
  return NumberFormat.currency(
    name: "LKR",
  ).format(amount);
}