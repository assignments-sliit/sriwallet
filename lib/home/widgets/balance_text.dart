import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sriwallet/money/utils/currency_formatter.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

Widget balanceTextBuilder(BuildContext context) {
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
          var amount =
              getCurrencyFormatted(double.parse(userdoc['balance'].toString()));
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  textAlign: TextAlign.center,
                  amount,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          );
        } else {
          return const Text("Failed to load balance");
        }
      });
}
