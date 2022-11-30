import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_web_admin_portal/authentication/login_screen.dart';
import 'package:foodpanda_web_admin_portal/main_screen/home_screen.dart';

Future<void> main() async
{
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDu2OMqZJo_1gE6dhmSyMYbTJ2yucSjgPA",
          authDomain: "foodpanda-app-25d0a.firebaseapp.com",
          projectId: "foodpanda-app-25d0a",
          storageBucket: "foodpanda-app-25d0a.appspot.com",
          messagingSenderId: "220675427037",
          appId: "1:220675427037:web:6b123071d96c6034f7e934"
          // apiKey: "your info",
          // authDomain: "your info",
          // projectId: "your info",
          // storageBucket: "your info",
          // messagingSenderId: "your info",
          // appId: "your info"
          ));

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Web Portal',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}

