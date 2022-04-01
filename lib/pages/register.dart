import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import "package:rflutter_alert/rflutter_alert.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

final _firestore = FirebaseFirestore.instance;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String name;
  late String username;
  late String password;
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 24.0),
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
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text("Name"),
                ),
                // Keyboard restriction to requirements means less cases for error handling
                TextField(
                  maxLength: 255, //Length limit with counter
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [
                    //LengthLimitingTextInputFormatter(30), //Length limit without counter
                    new FilteringTextInputFormatter(RegExp("[a-zA-Z '.-/]"),
                        allow: true),
                  ],
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: buildInputDecoration(
                      "Enter your name"), //see constants.dart
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text("Username"),
                ),
                TextField(
                  maxLength: 30,
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [
                    new FilteringTextInputFormatter(RegExp("[a-zA-Z0-9._]"),
                        allow: true),
                  ],
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: buildInputDecoration(
                      "Alphanumeric, dots and underscores only"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text("Password"),
                ),
                TextField(
                  maxLength: 128,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration:
                      buildInputDecoration("Must be at least 6 characters"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text("Email"),
                ),
                TextField(
                  maxLength: 320,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    new FilteringTextInputFormatter(RegExp("[^ ]"),
                        allow: true),
                  ],
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: buildInputDecoration("Enter your email"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          // character minimum requirement error handling (not including whitespaces and symbols)
                          int name_length =
                              name.split(RegExp(r"[a-zA-Z]")).length - 1;
                          int username_length =
                              username.split(RegExp(r"[a-zA-Z0-9]")).length - 1;
                          if (name_length < 2 || username_length < 3) {
                            if (name_length < 2) {
                              Alert(
                                      context: context,
                                      title: "Inappropriate Length",
                                      desc:
                                          "Name should contain at least 2 alphabets")
                                  .show();
                            } else {
                              Alert(
                                      context: context,
                                      title: "Inappropriate Length",
                                      desc:
                                          "Username should contain at least 3 characters")
                                  .show();
                            }
                            return;
                          }
                          bool taken = false;
                          // await to iterate through list of usernames in database and break when match is found (error popup), else allow user creation
                          await _firestore
                              .collection('userinfo')
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.forEach((doc) {
                              if (username == doc["username"]) {
                                taken = true;
                              }
                            });
                          });
                          if (taken) {
                            Alert(
                                    context: context,
                                    title: "Username taken",
                                    desc: "Please try another one")
                                .show();
                            return;
                          }
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (newUser != null) {
                            //create database collection "userinfo" with email as documentName and fields: name, username
                            _firestore.collection('userinfo').doc(email).set({
                              'name': name,
                              'username': username,
                              'friends': [],
                              'requests': [],
                              'created': DateTime.now()
                                  .toUtc()
                                  .millisecondsSinceEpoch, //Date of account creation
                              'calories': 0,
                              'steps': 0,
                              'quitsteps' : 0,
                              // calories and steps can be stored in another collection and set only when user starts a route
                            });

                            Alert(
                              context: context,
                              title: "Success!",
                              desc: "Successfully created account '$username'",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Back to MainMenu",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () =>
                                      Navigator.pushNamed(context, "/"),
                                  width: 200,
                                )
                              ],
                            ).show();
                          }
                        } catch (e) {
                          errorAlert(e, context);
                        } finally {
                          setState(() {
                            showSpinner = false;
                          });
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
        ),
      ),
    );
  }
}
