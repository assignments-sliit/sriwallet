import 'package:flutter/material.dart';

Color getInputPrefixTextColorForTheme(BuildContext context){

  if (Theme.of(context).brightness == Brightness.dark) {
    return Colors.white;
  }
  return Colors.black;
}

Color getTextColorFromTheme(BuildContext context){

  if (Theme.of(context).brightness == Brightness.dark) {
    return Colors.white;
  }
  return Colors.black;
}

