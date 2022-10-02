import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color getIconColorFromTheme(BuildContext context){
 if (Theme.of(context).brightness == Brightness.dark) {
    return Colors.white;
  }
  return Theme.of(context).primaryColor;
}