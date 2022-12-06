import 'package:flutter/material.dart';
import 'package:sriwallet/themes/theme.dart';

Widget nameInput(TextEditingController controller, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
          label: const Text("Full Name"),
          counterText: "",
          hintText: "Manoj Kumar",
          hintStyle: TextStyle(color: hintTextColor(context)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                width: 2,
              ))),
    ),
  );
}
