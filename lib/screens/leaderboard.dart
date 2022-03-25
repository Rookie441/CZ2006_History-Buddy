import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class leaderboardPage extends StatefulWidget {
  @override
  _leaderboardPageState createState() => _leaderboardPageState();
}

class _leaderboardPageState extends State<leaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          children: <Widget>[
            Column(
              children: const [
                Text(
                  "Leaderboard",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 15,
                  thickness: 2,
                  indent: 5,
                  endIndent: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
