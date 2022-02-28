import 'package:flutter/material.dart';
import '../constants.dart';

class friendsPage extends StatefulWidget {
  @override
  _friendsPageState createState() => _friendsPageState();
}

class _friendsPageState extends State<friendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Text(
                  'Friends:',
                  style: kHeadingTextStyle,
                ),
              ],
            ),
            RaisedButton(
              color: Colors.red,
              child: Column(
                children: [
                  Text('Add'),
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
