import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sriwallet/auth/screens/login.dart';
import 'package:sriwallet/cards/screens/add_card.dart';
import 'package:sriwallet/cards/utils/card_color.dart';
import 'package:sriwallet/cards/utils/card_number_formattor.dart';
import 'package:sriwallet/cards/widgets/card.dart';
import 'package:sriwallet/cards/widgets/no_card.dart';
import 'package:sriwallet/cards/screens/view_card.dart';
import 'package:sriwallet/constants/colors/icon_color.dart';
import 'package:sriwallet/constants/colors/text_color.dart';
import 'package:sriwallet/home/widgets/balance_text.dart';
import 'package:sriwallet/money/screens/receive_money.dart';
import 'package:sriwallet/money/screens/send_moeny.dart';
import 'package:sriwallet/money/utils/currency_formatter.dart';
import 'package:sriwallet/themes/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore db = FirebaseFirestore.instance;

  String displayName = "";

  final _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black87
          : Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              const Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: const Text('MK'),
                                  )),
                              appbarUserName(context)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Icon(
                            Icons.notifications,
                            size: 32,
                            color: getIconColor(context),
                          ),
                        )
                      ]),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 15),
            child: Row(
              children: [
                Text(
                  "My Balance",
                  style: TextStyle(
                    color: getTextColorFromTheme(context),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          balanceTextBuilder(context),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Text(
                      "My Cards",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildCardSlider(context),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.import_export_outlined),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                print("sssss");
              },
              label: Text("Send/Receive Money".toUpperCase()),
            ),
          ),
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
          return GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewCardPage()));
            },
            child: SizedBox(
              height: 250,
              child: snapshot.data != null && snapshot.data!.docs.isEmpty
                  ? const NoCard()
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
            ),
          );
        }));
  }

  Widget buildCardItem(BuildContext context, QueryDocumentSnapshot? snapshot) {
    return SizedBox(
      height: 200,
      child: CardItem(
        types: snapshot!["type"],
        cardNumber: getCardNumberFormatted(snapshot["cardNumber"].toString()),
        expMonth: snapshot["expMonth"].toString(),
        expYear: snapshot["expYear"].toString(),
        backgroundColor: getCardColor(
          snapshot["bankName"],
        ),
        bankName: snapshot["bankName"],
        holderName: snapshot["holderName"],
      ),
    );
  }

  Widget appbarUserName(BuildContext context) {
    //  return Text(displayName, style: const TextStyle(fontSize: 24, color: Colors.black),);

    return StreamBuilder<DocumentSnapshot>(
      stream: db
          .collection('users')
          .doc(auth.currentUser?.uid)
          .snapshots(includeMetadataChanges: false),
      builder: ((context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Text("loading your name...");
        }

        if (snapshot.hasData) {
          
          return Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10),
            child: Text(
              snapshot.data!['fullname'],
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          );
        }

        return const Text('loading....');
      }),
    );
  }
}
