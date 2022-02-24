import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "constants.dart";
import "package:rflutter_alert/rflutter_alert.dart";
import 'package:animated_text_kit/animated_text_kit.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  late String name;
  late String username;
  late String password;
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
              child: Text(
                "Registration",
                style: TextStyle(
                  fontSize: 45.0,
                  fontFamily: 'Pacifico',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
              child: Text("Name"),
            ),
            TextField(
              onChanged: (value) {
                name = value;
              },
              decoration: buildInputDecoration(""),
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
              child: Text("Username"),
            ),
            TextField(
              onChanged: (value) {
                username = value;
              },
              decoration: buildInputDecoration(""),
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
              child: Text("Password"),
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: buildInputDecoration(""),
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
              child: Text("Email"),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: buildInputDecoration(""),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                    try {
                      if (name != null && username != null) {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, "/");
                          Alert(
                                  context: context,
                                  title: "Success!",
                                  desc:
                                      "Successfully created account '$username'")
                              .show();
                        }
                      }
                    } catch (e) {
                      // 2 different types of errors --> "error_type: error_msg" and "[error_type] error_msg"
                      int start = 0;
                      String error = e.toString();
                      int index = error.indexOf(":");
                      if (index == -1) {
                        index = error.indexOf("]");
                        start++;
                      }

                      String error_type = error.substring(start, index);
                      String error_msg = error.substring(index + 1);
                      Alert(
                              context: context,
                              title: error_type,
                              desc: error_msg)
                          .show();
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
