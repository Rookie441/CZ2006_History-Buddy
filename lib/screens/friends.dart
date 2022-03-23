import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/services.dart';
import '../constants.dart';
import '../pages/mainmenu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _firestore = FirebaseFirestore.instance;

class friendsPage extends StatefulWidget {
  @override
  _friendsPageState createState() => _friendsPageState();
}

class _friendsPageState extends State<friendsPage> {
  //Retrieve information from public class MainMenuState
  String email = MainMenuState.loggedInUser.email.toString();
  String username = MainMenuState.username.toString();

  late String friendUsername;
  late String friendEmail;

  List<String> friendList = [];
  List<String> requestList = [];

  var txtController = TextEditingController();

  Future<void> getFriendList() async {
    List<String> friendList = [];
    // todo: wrap in try block
    await _firestore
        .collection('userinfo')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (email == doc.id.toLowerCase()) {
          for (String friendUsername in doc["friends"]) {
            friendList.add(friendUsername);
          }
        }
      });
    });
    this.friendList = friendList;
  }

  Future<void> getRequestList() async {
    List<String> requestList = [];
    // todo: wrap in try block
    await _firestore
        .collection('userinfo')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (email == doc.id.toLowerCase()) {
          for (String friendUsername in doc["requests"]) {
            requestList.add(friendUsername);
          }
        }
      });
    });
    this.requestList = requestList;
  }

  @override
  Widget build(BuildContext context) {
    //Cannot add function calls/setState to widgets, though can add in an onPressed async button (similar to refresh) but require user interaction (not ideal).
    //FutureBuilder allows to await the getFriendList function where the attribute friendList is updated according to data fetched from the database collection
    //This is done before building widgets, so widgets can now make use of the updated attribute friendList.
    return FutureBuilder(
        future: Future.wait([
          getFriendList(),
          getRequestList(),
        ]), //multiple futures to wait for
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white70,
            body: Center(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        'Requests:',
                        style: kHeadingTextStyle,
                      ),
                    ],
                  ),
                  //todo: cannot print request usernames together since need to accept/reject specific request. Add each button beside name (+/-)
                  Row(
                    children: [
                      Text(
                        requestList.toString(),
                        style: kHeadingTextStyle,
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      RaisedButton(
                          color: Colors.green,
                          child: Column(
                            children: [
                              Text('Accept'),
                            ],
                          ),
                          onPressed: () async {
                            for (String request in requestList) {
                              //update my request
                              List<String> newRequest = [];
                              newRequest.add(request);
                              _firestore
                                  .collection('userinfo')
                                  .doc(email)
                                  .update({
                                "requests": FieldValue.arrayRemove(newRequest)
                              });
                              getRequestList();
                              //update my friends
                              List<String> newFriend = [];
                              newFriend.add(request);
                              _firestore
                                  .collection('userinfo')
                                  .doc(email)
                                  .update({
                                "friends": FieldValue.arrayUnion(newFriend)
                              });
                              getFriendList();
                              setState(() {});
                              //update his friends
                              await _firestore
                                  .collection('userinfo')
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                querySnapshot.docs.forEach((doc) {
                                  if (request == doc["username"]) {
                                    String newFriendEmail = doc.id;
                                    List<String> newFriend = [];
                                    newFriend.add(username);
                                    _firestore
                                        .collection('userinfo')
                                        .doc(newFriendEmail)
                                        .update({
                                      "friends":
                                          FieldValue.arrayUnion(newFriend)
                                    });
                                  }
                                });
                              });
                            }
                          }),
                      RaisedButton(
                          color: Colors.red,
                          child: Column(
                            children: [
                              Text('Reject'),
                            ],
                          ),
                          onPressed: () {
                            //remove my request
                            for (String request in requestList) {
                              //update my request
                              List<String> newRequest = [];
                              newRequest.add(request);
                              _firestore
                                  .collection('userinfo')
                                  .doc(email)
                                  .update({
                                "requests": FieldValue.arrayRemove(newRequest)
                              });
                              getRequestList();
                              setState(() {});
                            }
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextField(
                    controller: txtController,
                    maxLength: 30,
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      new FilteringTextInputFormatter(
                          RegExp("[a-zA-Z0-9._]"), allow: true),
                    ],
                    onChanged: (value) {
                      friendUsername = value;
                    },
                    decoration: buildInputDecoration("Add friend by username"),
                  ),
                  RaisedButton(
                    color: Colors.lightBlue,
                    child: Column(
                      children: [
                        Text('Add'),
                      ],
                    ),
                    onPressed: () async {
                      // Cannot add yourself as friend
                      try {
                        // todo: show spinner
                        if (friendUsername == username) {
                          Alert(
                                  context: context,
                                  title: "Error",
                                  desc: "Cannot add yourself")
                              .show();
                          return;
                          //Check if request to be sent is already your friend
                        } else if (friendList.contains(friendUsername)) {
                          Alert(
                                  context: context,
                                  title: "Error",
                                  desc: "User is already in your friendlist")
                              .show();
                          return;
                        }

                        bool validFriendUsername = false;
                        await _firestore //check username to add exists in database
                            .collection('userinfo')
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            if (friendUsername == doc["username"]) {
                              validFriendUsername = true;
                              friendEmail = doc.id;
                              requestList.add(username);
                              //Change requestList field for friend, do nothing for existing user unless "pending request" is implemented
                              _firestore
                                  .collection('userinfo')
                                  .doc(friendEmail)
                                  .update({
                                "requests": FieldValue.arrayUnion(requestList)
                              }); //union set, no duplicates, no same username anyways
                              Alert(
                                      context: context,
                                      title: "Success",
                                      desc:
                                          "Friend request sent to '$friendUsername'")
                                  .show();
                            }
                          });
                        });
                        if (!validFriendUsername) {
                          Alert(
                                  context: context,
                                  title: "Error",
                                  desc: "Username does not exist")
                              .show();
                        }
                      } catch (e) {
                        errorAlert(e, context);
                      } finally {
                        txtController.clear();
                        friendUsername = "";
                        setState(
                            () {}); //refresh state and show added-new-user immediately on widget
                      }
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Friends:',
                        style: kHeadingTextStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        friendList.toString(),
                        style: kHeadingTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
