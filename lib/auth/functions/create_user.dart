import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createUserAndWallet(
  String fullName,
  String email,
  String nic,
  String phoneNumber,
) {
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final newUserData = <String, dynamic>{
    "fullname": fullName,
    "email": email,
    "nic": nic,
    "mobile": phoneNumber
  };

  final walletInfo = <String, dynamic>{
    "name": "Default Wallet",
    "mobile": phoneNumber,
    "currency": "LKR",
  };

  return users.doc(auth.currentUser?.uid).set(newUserData).then((result) => {
        users
            .doc(auth.currentUser?.uid)
            .collection('wallet')
            .doc(phoneNumber)
            .set(walletInfo)
      });
}
