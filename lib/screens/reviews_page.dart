import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:history_buddy/screens/historicalsite.dart';
import 'package:history_buddy/HistSite.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({required this.histsite});

  final HistSite histsite;

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(histsite.getName()),
        elevation: 0.0,
      ),
      body: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          print("pressed");
        },
      ),
      );

  }



}