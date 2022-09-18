import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sriwallet/cards/card_types.dart';

class CardItem extends StatelessWidget {
  final String cardname;
  final String types;
  final String? cardNumber;
  final int expMonth;
  final int expYear;
  final Color backgroundColor;

  const CardItem(
      {Key? key,
      required this.cardname,
      required this.types,
      required this.cardNumber,
      required this.expMonth,
      required this.expYear, required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //Card Name & Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Card Name",
                    style: TextStyle(color: Colors.grey[200]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                   Text(cardname,
                      style:const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
               FaIcon(
                getCardIcon(types),
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
          //end card name and logo

          const SizedBox(
            height: 30,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(cardNumber!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24)),
                  Text('$expMonth/$expYear',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
              //  Chip(label: Text("Default"),backgroundColor: Colors.white,)
            ],
          ),
        ]),
      ),
    );
  }
}
