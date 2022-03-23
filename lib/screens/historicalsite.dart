import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:geojson/geojson.dart';
import 'package:http/http.dart';
import 'package:history_buddy/sitesData.dart';

class historicalsite extends StatefulWidget {
  @override
  _historicalsiteState createState() => _historicalsiteState();
}

class _historicalsiteState extends State<historicalsite> {
  @override
  SitesMgr _sitesmgr = new SitesMgr();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Text(
                  'Historical Sites:',
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
