import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveMoneyPage extends StatefulWidget {
  const ReceiveMoneyPage({Key? key}) : super(key: key);

  @override
  State<ReceiveMoneyPage> createState() => _ReceiveMoneyPageState();
}

class _ReceiveMoneyPageState extends State<ReceiveMoneyPage> {
FirebaseAuth auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( iconTheme: const IconThemeData(color: Colors.white),
        
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(

          "Receive Money",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: QrImage(
        data: auth.currentUser == null ? 'NOPE' : auth.currentUser!.uid,
        version: QrVersions.auto,
        size: 400,
      )),
    );
  }
}
