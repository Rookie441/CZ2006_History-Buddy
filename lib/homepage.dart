import 'package:flutter/material.dart';
import 'constants.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:rflutter_alert/rflutter_alert.dart';
import "package:cloud_firestore/cloud_firestore.dart";

//final _firestore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  int calories = 100;
  int highscore = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        //print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        automaticallyImplyLeading: false, //prevents accidental backtracking
        backgroundColor: Colors.blue[900],
        title: Text('HomePage'),
        actions: [
          TextButton(
            child: Text("Logout",
                style: TextStyle(
                    color: Colors.white54, backgroundColor: Colors.blue[900])),
            onPressed: () {
              Alert(
                context: context,
                title: "Confirmation",
                desc: "Are you sure you want to logout?",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      _auth.signOut();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  DialogButton(
                    child: Text(
                      "No",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ).show();
            },
          )
        ],
      ),
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
                  'Highscore: $highscore',
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
  }
}
