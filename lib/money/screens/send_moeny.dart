import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({Key? key}) : super(key: key);

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  String qrResult = "";

  String? receiverName = "";

  TextEditingController amountController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  bool enableSendButton = false;
  String mobile = "";
  int amount = 0;
  final LocalAuthentication localAuthentication = LocalAuthentication();
  @override
  void initState() {
    super.initState();

    setState(() {
      qrResult = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          elevation: 8,
          onPressed: scanQrCode,
          label: Text(qrResult == ""
              ? "Scan".toUpperCase()
              : "Scan Again".toUpperCase()),
          icon: const FaIcon(FontAwesomeIcons.qrcode)),
      appBar: AppBar(
        title: const Text(
          "Send Money",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: qrResult == "" || qrResult == 'NOPE'
          ? const Center(
              child: Text(
              "Scan using the button below",
              style: TextStyle(color: Colors.black),
            ))
          : Center(
              child: Column(
              children: [
                qrResult == ""
                    ? const SizedBox()
                    : textStreamBuilder(context, qrResult),
                amountInput(context),
                ElevatedButton(
                    onPressed: !enableSendButton
                        ? null
                        : () async {
                            final bool canAuthWithBio =
                                await localAuthentication.canCheckBiometrics;

                            final bool canAuth = canAuthWithBio &&
                                await localAuthentication.isDeviceSupported();
                            final List<BiometricType> availableBiometrics =
                                await localAuthentication
                                    .getAvailableBiometrics();

                            if (canAuth &&
                                (availableBiometrics
                                    .contains(BiometricType.strong))) {
                              final bool didAuthenticate =
                                  await localAuthentication.authenticate(
                                      options: const AuthenticationOptions(
                                          sensitiveTransaction: true,
                                          biometricOnly: false),
                                      localizedReason:
                                          'Meh uba kiyala sure da?');

                              if (didAuthenticate) {
                                //do
                                if (mobile != "") {
                                  var doc = db
                                      .collection('users')
                                      .doc(qrResult.toString())
                                      .collection('wallet')
                                      .doc(mobile)
                                      .get()
                                      .then((DocumentSnapshot snapshot) {
                                    var data =
                                        snapshot.data() as Map<String, dynamic>;

                                    amount = data['amount'];
                                  });

                                  //increase money in receiver
                                  db
                                      .collection('users')
                                      .doc(qrResult.toString())
                                      .collection('wallet')
                                      .doc(mobile)
                                      .update({
                                    "balance": amount +
                                        int.parse(amountController.text)
                                  });

                                  //decrease money in receiver
                                  db
                                      .collection('users')
                                      .doc(auth.currentUser!.uid)
                                      .collection('wallet')
                                      .doc(auth.currentUser!.phoneNumber)
                                      .update({
                                    "balance": amount -
                                        int.parse(amountController.text)
                                  });
                                }

                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              } else {
                                const snackBar = SnackBar(
                                  content: Text('Authorization Failed!'),
                                );
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          },
                    child: const Text("Send Money"))
              ],
            )),
    );
  }

  scanQrCode() async {
    PermissionStatus permissionStatus = await Permission.camera.status;

    if (permissionStatus.isDenied) {
      if (await Permission.camera.request().isGranted) {
        //get receivers name
        processQr();
      }
    } else {
      processQr();
    }
  }

  processQr() async {
    String? result = await scan();

    setState(() {
      qrResult = result!;
    });
  }

  Widget textStreamBuilder(BuildContext context, String result) {
    return StreamBuilder(
        stream: db.collection('users').doc(result).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            DocumentSnapshot userdoc = snapshot.data as DocumentSnapshot;
            var name = userdoc['fullname'].toString();
            var phoneNumber = "0${userdoc['mobile']}";
            mobile = "+94${userdoc['mobile']}";
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Send Money to $name \n $phoneNumber",
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return const Text("unable to retrieve user information");
          }
        });
  }

  Widget amountInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: !(qrResult == "" || qrResult == 'NOPE'),
        child: TextField(
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                enableSendButton = false;
              });
            } else {
              setState(() {
                enableSendButton = true;
              });
            }
          },
          decoration: InputDecoration(
              label: const Text("Amount"),
              counterText: "",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor))),
          controller: amountController,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
