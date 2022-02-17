import 'package:flutter/material.dart';
import 'homepage.dart';
import 'mainmenu.dart';
import 'login.dart';
import 'register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainMenu(),
        '/login': (context) => Login(), //login
        '/register': (context) => Register(), //register
      },
    );
  }
}
