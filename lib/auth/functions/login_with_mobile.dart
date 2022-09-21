//   import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

// void loginWithMobileNo(BuildContext context, String dialogMessage, String verificationIdReceived, String sms code ) async {
  
//   late ProgressDialog progressDialog;
//   progressDialog = ProgressDialog(context, type: ProgressDialogType.normal);
//     progressDialog.style(
//         message: dialogMessage,
//         borderRadius: 10.0,
//         backgroundColor: Colors.white,
//         progressWidget: const CircularProgressIndicator(),
//         elevation: 10.0,
//         insetAnimCurve: Curves.easeInOut,
//         progress: 0.0,
//         maxProgress: 100.0,
//         progressTextStyle: const TextStyle(
//             color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
//         messageTextStyle: const TextStyle(
//             color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
//     await progressDialog.show();
//     PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
//         verificationId: verificationIdReceived, smsCode: codeController.text);

//     await auth.signInWithCredential(phoneAuthCredential).then((value) => {
//           {
//             dialogMessage = "Creating user...",
//             createUserAndWallet(
//               nameController.text,
//               emailController.text,
//               nicController.text,
//               phoneNoControlller.text,
//             ),
//             dialogMessage = "Logging in...",
//             progressDialog.hide().then((value) => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const HomePage())))
//           }
//         });
//   }