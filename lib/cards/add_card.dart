import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sriwallet/cards/card_exp_formattor.dart';
import 'package:sriwallet/cards/card_input_icon.dart';
import 'package:sriwallet/cards/card_number_formattor.dart';
import 'package:sriwallet/cards/card_types.dart';
import 'package:sriwallet/ui/home/utils/go_back.dart';

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
                          icon: Icon(Icons.arrow_back_rounded),
                          onPressed: () {
                            goBack(context);
                          },
                        )),
                    SizedBox(
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
              onChanged: (val){
                getCardTypeFrmNumber();
              },
              decoration: InputDecoration(
                suffix: getCardIcon(cardType),
                  hintText: 'xxxx xxxx xxxx xxxx',
                  counterText: "",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  label: Text("Card Number")),
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
                  label: Text("Cardholder Name")),
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
                  label: Text("Bank")),
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
                        label: Text("MM/YY")),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: cvvControler,
                    decoration: InputDecoration(
                        hintText: '***',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        label: Text("CVV")),
                  ),
                ),
              ),
              
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    final newCardInfo = <String, dynamic>{
                      "bankName":bankNameController.text.toString(),
                      "cardNumber":getCleanedNumber(cardNumberController.text),
                      "cvv":cvvControler.text,
                      "expMonth":expController.text.split("/")[0],
                       "expYear":expController.text.split("/")[1],
                       "holderName":holderNameController.text.trim(),
                       "type":cardType.toString()
                    };
                    db
                        .collection('users')
                        .doc(auth.currentUser?.uid)
                        .collection('wallet')
                        .doc(auth.currentUser?.phoneNumber)
                        .collection('cards')
                        .doc()
                        .set(newCardInfo).then((value) => {
                          goBack(context)
                        });
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
      print(input);
      CardType type = getCardTypeFromNumber(input);
      if (type != cardType) {
        setState(() {
          cardType = type;
        });
      }
    
  }
}
