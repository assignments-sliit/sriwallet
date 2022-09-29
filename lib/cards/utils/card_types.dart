import 'package:flutter/src/widgets/icon_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum CardType { master, visa, amex, apple, invalid }

IconData getCardIconString(String cardTypes) {
  switch (cardTypes) {
    case 'visa':
      return FontAwesomeIcons.ccVisa;

    case 'apple':
      return FontAwesomeIcons.ccApplePay;

    case 'master':
      return FontAwesomeIcons.ccMastercard;

    case 'amex':
      return FontAwesomeIcons.ccAmex;
    default:
      return FontAwesomeIcons.ccVisa;
  }
}

String getCardTypeString(CardType type) {
  switch (type) {
    case CardType.visa:
      return 'visa';

    case CardType.amex:
      return 'amex';

    case CardType.master:
      return 'master';

    case CardType.apple:
      return 'apple';
    default:
      return 'visa';
  }
}
