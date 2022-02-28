import 'package:flutter/material.dart';
import '../constants.dart';

class leaderboardPage extends StatefulWidget {
  @override
  _leaderboardPageState createState() => _leaderboardPageState();
}

class _leaderboardPageState extends State<leaderboardPage> {
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
                  'Leaderboard:',
                  style: kHeadingTextStyle,
                ),
              ],
            ),
            RaisedButton(
              color: Colors.green,
              child: Column(
                children: [
                  Text('Refresh'),
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
