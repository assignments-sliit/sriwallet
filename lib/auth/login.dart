import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:sriwallet/auth/screens/register.dart';
import 'package:sriwallet/home/screens/homepage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _registerPageKey = GlobalKey<FormState>();
  bool verificationSent = false;
  bool phoneNumberFilled = false;

  TextEditingController phoneNoControlller = TextEditingController();
  TextEditingController codeController = TextEditingController();

  bool isOtpFilled = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String phoneNumber = "";
  String verificationIdReceived = "";
  String dialogMessage = "Logging in...";

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
        
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(

          "Login",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _registerPageKey,
          child: Column(

              children: [
                Form(
                    child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    phoneNumberInput(),
                    otpInput(),
                    masterButton(),
                    const SizedBox(height: 370,),
                    register()
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
                      //   FocusScope.of(context).nextFocus();
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
          primary: Colors.lightBlue[500],
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
        child: Text(!verificationSent ? "Send OTP" : "LOGIN", style:const TextStyle(color: Colors.white)),
      ),
    );
  }
      Widget register() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: ElevatedButton(  
        style: ElevatedButton.styleFrom(
         
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: () {
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()));
              },
        child: const Text("REGISTER",style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  void loginWithMobileNo(BuildContext context) async {
    await progressDialog.show();
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationIdReceived, smsCode: codeController.text);

    await auth.signInWithCredential(phoneAuthCredential).then((value) => {
          {
            
            progressDialog.hide().then((value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage())))
          }
        });
  }
}
