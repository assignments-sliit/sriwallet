import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({Key? key}) : super(key: key);

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  String? qrResult = "";

  String? receiverName = "";

  TextEditingController amountController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;
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
              //     mainAxisAlignment: MainAxisAlignment.center,
              children: [
                qrResult == ""
                    ? const SizedBox()
                    : textStreamBuilder(context, qrResult!),
                amountInput(context)
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
    String name = "";
    const source = Source.cache;

    setState(() {
      qrResult = result;
    });
  }

  Widget textStreamBuilder(BuildContext context, String result) {
    return StreamBuilder(
        stream: db.collection('users').doc(result).snapshots(),
        builder: (context, snapshot) {
          DocumentSnapshot userdoc = snapshot.data as DocumentSnapshot;
          var name = userdoc['fullname'].toString();
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Send Money to $name",
              style: const TextStyle(fontSize: 20),
            ),
          );
        });
  }

  Widget amountInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: !(qrResult == "" || qrResult == 'NOPE'),
        child: TextField(
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
