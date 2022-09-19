import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sriwallet/cards/card_types.dart';

CardType getCardTypeFromNumber(String input) {
  CardType cardType;
  if (input.startsWith(RegExp(
      r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
    cardType = CardType.master;
  } else if (input.startsWith(RegExp(r'[4]'))) {
    cardType = CardType.visa;
  } else if (input.startsWith(RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
    cardType = CardType.apple;
  } else if (input.startsWith(RegExp(r'((34)|(37))'))) {
    cardType = CardType.amex;
  } else {
    cardType = CardType.invalid;
  }
  return cardType;
}

Widget? getCardIcon(CardType? cardType) {
  Widget? icon;
  switch (cardType) {
    case CardType.master:
      icon = const FaIcon(FontAwesomeIcons.ccMastercard);
      break;
    case CardType.visa:
      icon = const FaIcon(FontAwesomeIcons.ccVisa);
      break;
    case CardType.apple:
      icon = const FaIcon(FontAwesomeIcons.ccApplePay);
      break;
    case CardType.amex:
      icon = const FaIcon(FontAwesomeIcons.ccAmex);
      break;

    default:
      icon = const Icon(
        Icons.credit_card_rounded,
        size: 24.0,
        color: Color(0xFFB8B5C3),
      );
      break;
  }

  return icon;
}

String getCleanedNumber(String text) {
  RegExp regExp = RegExp(r"[^0-9]");
  return text.replaceAll(RegExp(r"\s+"), "");
}
