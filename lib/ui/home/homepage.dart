// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sriwallet/auth/login.dart';
import 'package:sriwallet/auth/register.dart';
import 'package:sriwallet/auth/utils/card_number_formattor.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("New Card"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Form(
                                        child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: TextFormField(
                                            maxLength: 19,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  17),
                                              CardNumberInputFormatter()
                                            ],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText: 'xxxx xxxx xxxx xxxx',
                                                counterText: "",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                label: Text("Card Number")),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                hintText: 'polroti',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                label: Text("Cardholder Name")),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                hintText: 'Commercial bank',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                label: Text("Bank")),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: TextFormField(
                                                  maxLength: 5,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    counterText: "",
                                                      hintText: 'MM/YY',
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      label: Text("MM/YY")),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      hintText: '***',
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      label: Text("CVV")),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel")),
                                  TextButton(
                                    
                                      onPressed: () {
                                        // db
                                        //     .collection('users')
                                        //     .doc(auth.currentUser?.uid)
                                        //     .collection('wallet')
                                        //     .doc(auth.currentUser?.phoneNumber)
                                        //     .collection('cards').doc().set("data")
                                      },
                                      child: Text("Save card"))
                                ],
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
            height: 250,
            child: snapshot.data == null
                ? NoCard()
                : PageView.builder(
                    controller: _controller,
                    itemCount:
                        snapshot.hasData ? snapshot.data?.docs.length : 0,
                    itemBuilder: (context, index) {
                      return Column(children: <Widget>[
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
      height: 200,
      child: CardItem(
        types: snapshot!["type"],
        cardNumber: snapshot["cardNumber"],
        expMonth: snapshot["expMonth"],
        expYear: snapshot["expYear"],
        backgroundColor: Colors.blue,
        bankName: snapshot["bankName"],
        holderName: snapshot["holderName"],
      ),
    );
  }
}
