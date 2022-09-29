import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sriwallet/cards/utils/card_exp_formattor.dart';
import 'package:sriwallet/cards/utils/card_input_icon.dart';
import 'package:sriwallet/cards/utils/card_number_formattor.dart';
import 'package:sriwallet/cards/utils/card_types.dart';
import 'package:sriwallet/home/utils/go_back.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({Key? key}) : super(key: key);

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
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
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Add a card",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  maxLength: 22,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
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
