import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:history_buddy/HistSite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/mainmenu.dart';


class StepCounter extends StatefulWidget {
  const StepCounter({Key? key,required this.histsite}) : super(key: key);
  final HistSite histsite;
  @override
  _StepCounterState createState() => _StepCounterState();
}


class _StepCounterState extends State<StepCounter> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?',
      _steps = '?';
  late int quit;
  late int today;
  String Uemail = MainMenuState.loggedInUser.email.toString();


  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    getquit();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }


  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  Future<int> getquit() async {
    await FirebaseFirestore.instance
        .collection('userinfo')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //this is not expensive
        if (Uemail == doc.id.toLowerCase()) {
          quit = doc["quitsteps"];
        }
      });
    });
    return quit;
  }

  Future<int> getsteps() async {
    await FirebaseFirestore.instance
        .collection('userinfo')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //this is not expensive
        if (Uemail == doc.id.toLowerCase()) {
          today = doc["steps"];
        }
      });
    });
    return today;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                getsteps();
                CollectionReference userinfo = FirebaseFirestore.instance
                    .collection('userinfo');
                userinfo.doc(Uemail).update(
                    {'quitsteps': int.parse(_steps),
                      'steps': today + int.parse(_steps) - quit,});
                Navigator.pop(context);
              }
          ),
          title: const Text('Pedometer'),
          backgroundColor: Colors.teal[200],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            CollectionReference userinfo = FirebaseFirestore.instance
                .collection('userinfo');
            userinfo.doc(Uemail).update(
                {'quitsteps': int.parse(_steps), 'steps': today + int.parse(_steps) - quit,});
            Navigator.pop(context);
          },
          label: const Text('Stop Counting'),
          backgroundColor: Colors.teal[200],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Steps taken:',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                (int.parse(_steps)- quit).toString(),
                style: TextStyle(fontSize: 60),
              ),
              Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              Text(
                'Pedestrian status:',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                    ? Icons.accessibility_new
                    : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 30)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}


