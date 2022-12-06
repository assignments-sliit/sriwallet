import 'package:flutter/material.dart';

Color appBarColor(BuildContext context){
    if(Theme.of(context).brightness == Brightness.dark ) {
    return Colors.blue.shade900;
  }

  return Colors.blue;
}

Color textLabelColor(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return Colors.grey.shade300;
  }

  return Colors.white;
}

Color hintTextColor(BuildContext context){

  return Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade700
                  : Colors.grey;
}

Color inputLabelColor(BuildContext context){
      if(Theme.of(context).brightness == Brightness.dark ) {
    return Colors.blue.shade900;
  }

  return Colors.blue;
}