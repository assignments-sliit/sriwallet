import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        return false;
      }),
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false, title: const Text("Welcome Manoj!")),
        body: const Center(
          child: Text("enna kadhe"),
        ),
      ),
    );
  }
}
