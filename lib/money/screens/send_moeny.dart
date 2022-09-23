import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({Key? key}) : super(key: key);

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  String? qrResult = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      qrResult = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          elevation: 8,
          onPressed: scanQrCode,
          child: const FaIcon(FontAwesomeIcons.qrcode)),
      appBar: AppBar(title: const Text("Send Money")),
      body: qrResult == null
          ? const Center(child: Text("Scan using the button below"))
          : Center(child: Text(qrResult!)),
    );
  }

  scanQrCode() async {
    String? result = await scan();

    setState(() {
      qrResult = result;
    });
  }
}
