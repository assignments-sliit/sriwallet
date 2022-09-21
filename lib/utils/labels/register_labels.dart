  import 'package:flutter/cupertino.dart';

Widget registerWithPhoneNoText() {
    return Row(
      children: const [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              "Register with your phone number",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }