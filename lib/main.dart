import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sriwallet/auth/register.dart';
import 'package:sriwallet/home/screens/homepage.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SRI WALLET',
      theme: ThemeData(
        useMaterial3: true,
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser == null ? const RegisterPage() : const HomePage(),
      routes:  <String, WidgetBuilder>{
        '/home':(_) => const HomePage(),
        '/register':(_) => const RegisterPage(),
      //  '/login':(_) => const 
      },
    );
  }
}
