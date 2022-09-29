import 'package:flutter/material.dart';

Color getCardColor(String bankName) {
  if (bankName.contains("Commercial")) {
    return Colors.blue;
  }
  if (bankName.contains("HNB") || bankName.contains("Hatton")) {
    return Colors.yellow;
  } else {
    return Colors.black;
  }
}
