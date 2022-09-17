import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sriwallet/auth/register.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String? displayName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }

  Future<void> getUserData(){
    return db.collection('users').where("uid",isEqualTo: auth.currentUser!.uid).get().then((value) => {
        
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        return false;
      }),
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Welcome polroti!")),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                auth.signOut().then((value) => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()))
                    });
              },
              child: const Text("Set avam apa")),
        ),
      ),
    );
  }
}
