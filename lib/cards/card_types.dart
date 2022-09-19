import 'package:flutter/src/widgets/icon_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum CardType {
  master,
  visa,
  amex,
  apple,
  invalid
}

IconData getCardIconString(String cardTypes){
  FaIcon icon ;//= const FaIcon(FontAwesomeIcons.ccVisa);

  switch (cardTypes){
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

  //return icon;
}