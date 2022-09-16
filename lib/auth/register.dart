import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  String phoneNumber = "";
  String verificationIdReceived = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _registerPageKey,
          child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                    child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    registerWithPhoneNoText(),
        
                    nameInput(),
                    nicInput(),
                    emailInput(),
                    phoneNumberInput(),
                    otpInput(),
                    masterButton(),
                    
        
                    // const Text("OR"),
                    // const Divider(),
                    // const Text("Verify with GOOGLE"),
                    // ElevatedButton.icon(
                    //     onPressed: () {},
                    //     icon: const FaIcon(FontAwesomeIcons.google),
                    //     label: const Text("SIGN UP WITH GOOGLE")),
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

  void loginWithMobileNo(BuildContext context) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationIdReceived, smsCode: codeController.text);

    await auth.signInWithCredential(phoneAuthCredential).then((value) => {
          {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()))
          }
        });
  }

  Widget registerWithPhoneNoText() {
    return Row(
      children: const [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 50, bottom: 20),
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
              //    height: MediaQuery.of(context).size.width / 4,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 10),
                child: TextFormField(
                  onChanged: (value) {
                    if (value.length == 6) {
                      FocusScope.of(context).nextFocus();
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
      padding: const EdgeInsets.only(left: 10, right: 10),
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
                  if(_registerPageKey.currentState!.validate()){
                    loginWithMobileNo(context);
                  }
                  
                }
              },
        child: Text(!verificationSent ? "Send OTP" : "LOGIN"),
      ),
    );
  }

  createUser(){
    final newUserData = <String,String>{
      "fullname": nameController.text,
      "email":emailController.text,

    };

    db.collection("users").add(newUserData).then((DocumentReference doc) => {
      print(doc.id)
    });
  }

  Widget nameInput() {
    return Padding(
      padding:  const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
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
