import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../pages/mainmenu.dart';

final _firestore = FirebaseFirestore.instance;

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int steps = 0;
  int calories = 0;

  final _auth = FirebaseAuth.instance;
  static late User loggedInUser;
  late String email;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        email = loggedInUser.email.toString();
      }
    } catch (e) {
      errorAlert(e, context); //see constants.dart
    }
  }

  Future getInfo() async {
    getCurrentUser();
    await _firestore
        .collection('userinfo')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //this is not expensive
        if (email == doc.id.toLowerCase()) {
          steps = doc["steps"];
          calories = doc["calories"];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getInfo(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white70,
            body: Center(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        'Calories: $calories',
                        style: kHeadingTextStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Steps: $steps',
                        style: kHeadingTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  CircleAvatar(
                    radius: 100.0,
                    backgroundImage: AssetImage("images/Logo.png"),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    child: Column(
                      children: [
                        Text('Play'),
                      ],
                    ),
                    onPressed: () {
                      print("pressed");
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
