import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sriwallet/auth/login.dart';
import 'package:sriwallet/auth/register.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String? displayName = "";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() {
    final userRef =
        db.collection('users').where("uid", isEqualTo: auth.currentUser?.uid);

    Map userdata;
    String? name;
    userRef.get().then((value) => {
          userdata = value.docs.first.data(),
          displayName = userdata["fullname"].toString().split(" ")[0]
        });

    if (name != null) {
      setState(() {
        displayName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        return false;
      }),
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Welcome ${displayName} !")),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                auth.signOut().then((value) => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()))
                    });
              },
              child: const Text("SIGN OUT")),
        ),
      ),
    );
  }
}
