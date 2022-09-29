import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sriwallet/auth/screens/login.dart';
import 'package:sriwallet/cards/screens/add_card.dart';
import 'package:sriwallet/cards/utils/card_color.dart';
import 'package:sriwallet/cards/widgets/card.dart';
import 'package:sriwallet/cards/widgets/no_card.dart';
import 'package:sriwallet/cards/screens/view_card.dart';
import 'package:sriwallet/money/screens/receive_money.dart';
import 'package:sriwallet/money/screens/send_moeny.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore db = FirebaseFirestore.instance;
  //CollectionReference users = FirebaseFirestore.instance.collection('users');

  String? displayName = "";

  final _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
              onPressed: () {
                auth.signOut();
                     Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              icon: const Icon(Icons.logout_outlined),
              label: const Text(
                "SIGN OUT",
                style: TextStyle(color: Colors.white),
              ))
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: const [
                Text(
                  "My Balance",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          textStreamBuilder(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                //add cards button
                Container(
                    child: IconButton(
                  icon: Icon(
                    Icons.add_card_rounded,
                    size: 28,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddCardPage()));
                  },
                ))
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildCardSlider(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReceiveMoneyPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.blue.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.45,
                    //color: Colors.blue,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.file_download_outlined),
                        Text("Receive Money")
                      ],
                    )),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SendMoneyPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.blue.shade900, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.file_upload_outlined),
                        Text("Send Money")
                      ],
                    )),
                    // color: Colors.amber,
                  ),
                ),
              )
            ],
          )
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
            child: Container(
              height: 250,
              child: snapshot.data != null && snapshot.data!.docs.isEmpty
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
            ),
          );
        }));
  }

  Widget buildCardItem(BuildContext context, QueryDocumentSnapshot? snapshot) {
    return Container(
      height: 200,
      child: CardItem(
        types: snapshot!["type"],
        cardNumber: snapshot["cardNumber"].toString(),
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

  Widget textStreamBuilder(BuildContext context) {
    return StreamBuilder(
        stream: db
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('wallet')
            .doc(auth.currentUser!.phoneNumber)
            .snapshots(),
        builder: (context, snapshot) {
          final userdoc = snapshot.data as DocumentSnapshot?;
          if (userdoc != null) {
            var amount = userdoc['balance'].toString();
            var currency = userdoc['currency'].toString();
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "$currency $amount",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            );
          } else {
            return const  Text("Failed to load balance");
          }
        });
  }
}
