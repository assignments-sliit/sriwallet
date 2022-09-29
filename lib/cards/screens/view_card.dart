import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sriwallet/cards/utils/card_exp_formattor.dart';
import 'package:sriwallet/cards/utils/card_input_icon.dart';
import 'package:sriwallet/cards/utils/card_number_formattor.dart';
import 'package:sriwallet/cards/utils/card_types.dart';
import 'package:sriwallet/home/screens/homepage.dart';
import 'package:sriwallet/home/utils/go_back.dart';


class ViewCardPage extends StatefulWidget {
  const ViewCardPage({Key? key}) : super(key: key);

  @override
  State<ViewCardPage> createState() => _ViewCardPageState();
}

class _ViewCardPageState extends State<ViewCardPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController holderNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController expController = TextEditingController();

  TextEditingController cvvControler = TextEditingController();
  CardType cardType = CardType.invalid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        //padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.grey[350], shape: BoxShape.circle),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                          },
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Add ",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Cards",
                      style: TextStyle(fontSize: 28),
                    ),
                  ],
                ),
                //add cards button
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              maxLength: 22,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                // LengthLimitingTextInputFormatter(17),
                CardNumberInputFormatter()
              ],
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                getCardTypeFrmNumber();
              },
              decoration: InputDecoration(
                  suffix: getCardIcon(cardType),
                  hintText: 'xxxx xxxx xxxx xxxx',
                  counterText: "",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  label: const Text("Card Number")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: holderNameController,
              decoration: InputDecoration(
                  hintText: 'polroti',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  label: const Text("Cardholder Name")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: bankNameController,
              decoration: InputDecoration(
                  hintText: 'Commercial bank',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  label: const Text("Bank")),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: expController,
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      CardMonthInputFormatter(),
                    ],
                    decoration: InputDecoration(
                        counterText: "",
                        hintText: 'MM/YY',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        label: const Text("MM/YY")),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    controller: cvvControler,
                    decoration: InputDecoration(
                        counterText: "",
                        hintText: '***',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        label: const Text("CVV")),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                final newCardInfo = <String, dynamic>{
                  "bankName": bankNameController.text.toString(),
                  "cardNumber": getCleanedNumber(cardNumberController.text),
                  "cvv": cvvControler.text,
                  "expMonth": expController.text.split("/")[0],
                  "expYear": expController.text.split("/")[1],
                  "holderName": holderNameController.text.trim(),
                  "type": getCardTypeString(cardType)
                };
                if (db
                    .collection('users')
                    .doc(auth.currentUser?.uid)
                    .collection('wallet')
                    .doc(auth.currentUser?.phoneNumber)
                    .collection('cards')
                    .path
                    .isEmpty) {
                  db
                      .collection('users')
                      .doc(auth.currentUser?.uid)
                      .collection('wallet')
                      .doc(auth.currentUser?.phoneNumber)
                      .collection('cards')
                      .add(newCardInfo)
                      .then((value) => {goBack(context)});
                }
                db
                    .collection('users')
                    .doc(auth.currentUser?.uid)
                    .collection('wallet')
                    .doc(auth.currentUser?.phoneNumber)
                    .collection('cards')
                    .doc()
                    .set(newCardInfo)
                    .then((value) => {goBack(context)});
              },
              child: const Text("SAVE"),
            ),
          ),
        ],
      ),
    ));
  }

  void getCardTypeFrmNumber() {
    String input = getCleanedNumber(cardNumberController.text);

    CardType type = getCardTypeFromNumber(input);
    if (type != cardType) {
      setState(() {
        cardType = type;
      });
    }
  }
}
