import 'package:flutter/cupertino.dart';

Widget registerWithPhoneNoText() {
  return Row(
    children: const [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 5),
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

Widget alreadyHaveAccPrompt() {
  return const Padding(
    padding: EdgeInsets.all(8.0),
    child: Text("Already have an account?"),
  );
}
