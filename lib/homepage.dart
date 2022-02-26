import 'package:flutter/material.dart';
import 'constants.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:rflutter_alert/rflutter_alert.dart';

final _firestore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String username = "";
  int calories = 100;
  int highscore = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<String> getInfo() async {
    await _firestore
        .collection('userinfo')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //this is not expensive
        if (loggedInUser.email == doc.id.toLowerCase()) {
          username = doc["username"];
        }
      });
    });
    return username;
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      errorAlert(e, context); //see constants.dart
    }
  }

  @override
  Widget build(BuildContext context) {
    //future builder is used to modify appBar title after info is being gathered from database
    return FutureBuilder<String>(
        future: getInfo(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white70,
            appBar: AppBar(
              automaticallyImplyLeading:
                  false, //prevents accidental backtracking
              backgroundColor: Colors.blue[900],
              title: Text("Welcome $username !"),
              actions: [
                TextButton(
                  child: Text("Logout",
                      style: TextStyle(
                          color: Colors.white54,
                          backgroundColor: Colors.blue[900])),
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
        });
  }
}
