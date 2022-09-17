// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    getUserData();
    super.initState();
  }

  getUserData() async {
    final userRef =
        db.collection('users').where("uid", isEqualTo: auth.currentUser?.uid);

    Map userdata;
    String? name;
    await userRef.get().then((value) => {
          userdata = value.docs.first.data(),
          name = userdata["fullname"].toString().split(" ")[0]
        });

    setState(() {
      displayName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    //   onWillPop: (() async {
    //     return false;
    //   }),
    //   child: Scaffold(
    //     backgroundColor: Colors.grey[300],
    //     appBar: AppBar(
    //         automaticallyImplyLeading: false,
    //         title: Text("Welcome $displayName !")),
    //     body: Center(
    //       child: ElevatedButton(
    //           onPressed: () {
    //             auth.signOut().then((value) => {
    //                   Navigator.pushReplacement(
    //                       context,
    //                       MaterialPageRoute(
    //                           builder: (context) => const LoginPage()))
    //                 });
    //           },
    //           child: const Text("SIGN OUT")),
    //     ),
    //   ),
    // );
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Text(
                      "My ",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Cards",
                      style: TextStyle(fontSize: 28),
                    ),
                  ],
                ),
                //add cards button
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey[350], shape: BoxShape.circle),
                    child: const Icon(
                      Icons.add_card_rounded,
                      size: 28,
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            width: 300,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Card Number",
                style: TextStyle(color: Colors.grey[200]),
              ),
              SizedBox(
                height: 5,
              ),
              Text("**** 8543",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Expiry Date",
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                      SizedBox(height: 5),
                      Text('10/24',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold))
                    ],
                  ),
                  FaIcon(
                    FontAwesomeIcons.ccVisa,
                    color: Colors.white,
                  )
                ],
              )
            ]),
          )
        ],
      )),
    );
  }
}
