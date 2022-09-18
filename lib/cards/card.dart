import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sriwallet/cards/card_types.dart';

class CardItem extends StatelessWidget {

  final String types;
  final String? cardNumber;
  final int expMonth;
  final int expYear;
  final Color backgroundColor;
  final String bankName;
  final String holderName;

  const CardItem(
      {Key? key,

      required this.types,
      required this.cardNumber,
      required this.expMonth,
      required this.expYear,
      required this.backgroundColor,
      required this.bankName,
      required this.holderName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: 350,
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
            
                  Text(bankName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ],
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
                children: [
                  Text(cardNumber!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24)),
                          const SizedBox(height: 7,),
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
         const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(holderName.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              FaIcon(
                getCardIcon(types),
                color: Colors.white,
                size: 36,
              ),
            ],
          )
        ]),
      ),
    );
  }
}
