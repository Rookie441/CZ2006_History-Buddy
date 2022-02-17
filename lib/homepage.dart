import 'package:flutter/material.dart';
import 'constants.dart';

class HomePage extends StatelessWidget {
  int calories = 100;
  int highscore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('HomePage'),
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
  }
}
