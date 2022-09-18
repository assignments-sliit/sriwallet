// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sriwallet/auth/login.dart';
import 'package:sriwallet/auth/register.dart';
import 'package:sriwallet/cards/card.dart';
import 'package:sriwallet/cards/card_types.dart';
import 'package:sriwallet/cards/no_card.dart';

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

  final _controller = PageController();

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                    //padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey[350], shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_card_rounded,
                        size: 28,
                      ),
                      onPressed: () {
                        showModalBottomSheet<void>(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 300,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text('Modal BottomSheet'),
                                      ElevatedButton(
                                        child: const Text('Close BottomSheet'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          buildCardSlider(context)
        ],
      )),
    );
  }

  Widget buildCardSlider(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('users')
            .doc(auth.currentUser?.uid)
            .collection('wallet')
            .doc(auth.currentUser?.phoneNumber)
            .collection('cards')
            .snapshots(),
        builder: ((context, snapshot) {
          return Container(
            height: 200,
            child: snapshot.data!.size < 1
                ? NoCard()
                : PageView.builder(
                    controller: _controller,
                    itemCount:
                        snapshot.hasData ? snapshot.data?.docs.length : 0,
                    itemBuilder: (context, index) {
                      return Column(
                        
                        children: <Widget>[
                        buildCardItem(context, snapshot.data?.docs[index]),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: SmoothPageIndicator(
                              effect: ExpandingDotsEffect(
                                  activeDotColor: Colors.grey.shade800,
                                  radius: 10,
                                  dotHeight: 10,
                                  dotWidth: 10),
                              controller: _controller,
                              count: snapshot.data!.size),
                        )
                      ]);
                    },
                  ),
          );
        }));
  }

  Widget buildCardItem(BuildContext context, QueryDocumentSnapshot? snapshot) {
    return Container(
      height: 175,
      child: CardItem(
          cardname: snapshot!["cardname"],
          types: snapshot["type"],
          cardNumber: snapshot["cardNumber"],
          expMonth: snapshot["expMonth"],
          expYear: snapshot["expYear"],
          backgroundColor: Colors.blue),
    );
  }
}
