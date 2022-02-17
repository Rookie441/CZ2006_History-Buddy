import 'package:flutter/material.dart';
import 'constants.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              color: Colors.red,
              child: Column(
                children: [
                  Text('function here'),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/first');
              },
            ),
          ],
        ),
      ),
    );
  }
}
