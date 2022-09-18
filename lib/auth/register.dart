import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:sriwallet/auth/login.dart';
import 'package:sriwallet/ui/home/homepage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerPageKey = GlobalKey<FormState>();
  bool verificationSent = false;
  bool phoneNumberFilled = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController nicController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoControlller = TextEditingController();
  TextEditingController codeController = TextEditingController();

  bool isOtpFilled = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String phoneNumber = "";
  String verificationIdReceived = "";
  String dialogMessage = "";

  late ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.normal);
    progressDialog.style(
        message: dialogMessage,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _registerPageKey,
          child: Column(children: [
            Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                registerWithPhoneNoText(),
                nameInput(),
                nicInput(),
                emailInput(),
                phoneNumberInput(),
                otpInput(),
                masterButton(),
                const SizedBox(
                  height: 100,
                ),
                goAndLogin()
              ],
            )),
          ]),
        ),
      ),
    );
  }

  void verifyMobile() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        verificationIdReceived = verificationId;

        setState(() {
          verificationSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Widget registerWithPhoneNoText() {
    return Row(
      children: const [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              "Register with your phone number",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget phoneNumberInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            if (value.length == 9) {
              setState(() {
                phoneNumber = "+94${phoneNoControlller.text}";
                phoneNumberFilled = true;
              });
            } else {
              setState(() {
                phoneNumberFilled = false;
              });
            }
          });
        },
        controller: phoneNoControlller,
        maxLength: 9,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            counterText: "",
            label: const Text("Mobile No"),
            prefix: const Padding(
              padding: EdgeInsets.all(1.0),
              child: Text(
                "+94",
                style: TextStyle(color: Colors.black),
              ),
            ),
            hintText: "771234567",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
      ),
    );
  }

  Widget otpInput() {
    //verification
    return Visibility(
        visible: verificationSent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 10),
                child: TextFormField(
                  onChanged: (value) {
                    if (value.length == 6) {
                      setState(() {
                        isOtpFilled = true;
                      });
                    } else {
                      setState(() {
                        isOtpFilled = false;
                      });
                    }
                  },
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  controller: codeController,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: const Text("OTP Code"),
                      counterText: "",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor))),
                ),
              ),
            ),
          ],
        ));
  }

  Widget masterButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: !phoneNumberFilled
            ? null
            : () {
                if (!verificationSent) {
                  verifyMobile();
                } else {
                  if (_registerPageKey.currentState!.validate()) {
                    loginWithMobileNo(context);
                  }
                }
              },
        child: Text(!verificationSent ? "Send OTP" : "Register with Mobile"),
      ),
    );
  }

  Widget goAndLogin() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.lightBlue[500],
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        child: const Text("LOGIN"),
      ),
    );
  }

  void loginWithMobileNo(BuildContext context) async {
    await progressDialog.show();
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationIdReceived, smsCode: codeController.text);

    await auth.signInWithCredential(phoneAuthCredential).then((value) => {
          {
            dialogMessage = "Creating user...",
            createUser(),
            dialogMessage = "Logging in...",
            progressDialog.hide().then((value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage())))
          }
        });
  }

  Future<void> createUser() {
    final newUserData = <String, dynamic>{
      "fullname": nameController.text,
      "email": emailController.text,
      "nic": nicController.text,
      "mobile": phoneNoControlller.text,
      //     "uid": auth.currentUser!.uid
    };

    final walletInfo = <String, dynamic>{
      "name": "Default Wallet",
      "mobile": phoneNoControlller.text,
      "currency": "LKR",
    };

    return users.doc(auth.currentUser?.uid).set(newUserData).then((result) => {
          users.doc(auth.currentUser?.uid).collection('wallet').doc(phoneNumber).set(walletInfo)
        });
  }

  Widget nameInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
            label: const Text("Full Name"),
            counterText: "",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
      ),
    );
  }

  Widget nicInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: TextFormField(
        controller: nicController,
        validator: nicValidator,
        //  onChanged: nicValidator,
        decoration: InputDecoration(
            label: const Text("NIC"),
            counterText: "",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: TextFormField(
        controller: emailController,
        validator: emailValidator,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            label: const Text("Email Address"),
            counterText: "",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
      ),
    );
  }

  String nicValidator(String? input) {
    String pattern = r'^([0-9]{9}[x|X|v|V]|[0-9]{12})$)';
    //regexp obtained from https://www.regextester.com/100137
    RegExp exp = RegExp(pattern);

    if (exp.hasMatch(input!)) {
      print(exp.hasMatch(input));
      return "";
    } else {
      return "INVALID NIC";
    }

    // return exp.hasMatch(input!);
  }

  String emailValidator(String? input) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(input!)) {
      return "INVALID EMAIL";
    } else {
      return "";
    }
  }
}
