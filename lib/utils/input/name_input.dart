  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget nameInput(TextEditingController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            label: const Text("Full Name"),
            counterText: "",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
      ),
    );
  }