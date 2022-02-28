import 'package:flutter/material.dart';
import '../constants.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
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
                  'Calories:',
                  style: kHeadingTextStyle,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Highscore:',
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
