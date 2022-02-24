import 'package:flutter/material.dart';
import 'homepage.dart';
import 'mainmenu.dart';
import 'register.dart';
import "package:firebase_core/firebase_core.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainMenu(),
        '/homepage': (context) => HomePage(),
        '/register': (context) => Register(),
      },
    );
  }
}
