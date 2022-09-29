import 'package:flutter/cupertino.dart';

Widget loginWithMobileNoText() {
  return Row(
    children: const [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            "Login with your phone number",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ],
  );
}


