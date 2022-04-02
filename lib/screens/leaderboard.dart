import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:history_buddy/pages/mainmenu.dart';

final _firestore = FirebaseFirestore.instance;

class leaderboardPage extends StatefulWidget {
  @override
  _leaderboardPageState createState() => _leaderboardPageState();
}

class _leaderboardPageState extends State<leaderboardPage> {
  List usernameList = [];
  var dataMap = {};
  var dropdownValue = 'steps';
  String username = MainMenuState.username.toString();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('userinfo')
            .orderBy(dropdownValue, descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final data = snapshot.data!.docs;
          var dataMap = Map();
          List usernameList = [];
          for (var document in data) {
            dataMap[document.get('username')] = document.get(dropdownValue);
            usernameList.add(document.get('username'));
          }
          this.usernameList = usernameList;

          return Scaffold(
            backgroundColor: Colors.brown[200],
            body: RefreshIndicator(
              onRefresh: () async {
                print("refreshed");
                setState(() {});
              },
              child: ListView(
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Leaderboard",
                              style: TextStyle(
                                fontSize: 30.0,
                                fontFamily: 'Pacifico',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              width: 35.0,
                            ),
                            DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>[
                                'steps',
                                'calories',
                                'quitsteps'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        height: 15,
                        thickness: 2,
                        indent: 5,
                        endIndent: 5,
                      ),
                      Container(
                          height: 500,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              for (var index in usernameList)
                                ListTile(
                                  tileColor: index.toString() == username
                                      ? Colors.grey
                                      : Colors.brown[200],
                                  leading: CircleAvatar(
                                    child: Text(index
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase()),
                                  ),
                                  title: Text(index.toString()),
                                  trailing: Text(
                                    dataMap[index].toString(),
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
