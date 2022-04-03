import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class leaderboardPage extends StatefulWidget {
  @override
  _leaderboardPageState createState() => _leaderboardPageState();
}

class _leaderboardPageState extends State<leaderboardPage> {
  List usernameList = [];
  var dataMap = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('userinfo')
            .orderBy('calories', descending: true)
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
            dataMap[document.get('username')] = document.get('calories');
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
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Leaderboard",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30.0,
                                fontFamily: 'Pacifico',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              width: 35.0,
                            ),
                            Text(
                              "Calories Burnt",
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
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("images/Avatar.png"),
                                  ),
                                  title: Text(index.toString()),
                                  trailing: Text(dataMap[index].toString()),
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
