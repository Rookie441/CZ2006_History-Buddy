import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:history_buddy/HistSite.dart';
import 'package:jiffy/jiffy.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/mainmenu.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}


class StepCounter extends StatefulWidget {
  const StepCounter({Key? key,required this.histsite}) : super(key: key);
  final HistSite histsite;
  @override
  _StepCounterState createState() => _StepCounterState();
}


class _StepCounterState extends State<StepCounter> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  late int todaySteps;
  late int quit;
  static int today = 0;
  String Uemail = MainMenuState.loggedInUser.email.toString();


  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.openBox<int>('steps');
    await Firebase.initializeApp();
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



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
        leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
       onPressed: () {
         CollectionReference userinfo = FirebaseFirestore.instance.collection('userinfo');
         userinfo.doc(Uemail).update(
             {'quitsteps': int.parse(_steps),
               'steps': gettoday(),});
         Navigator.pop(context);
        }
        ),
        title: const Text('Pedometer'),
          backgroundColor: Colors.teal[200],
      ),
        floatingActionButton: FloatingActionButton.extended(
           onPressed: () {
               CollectionReference userinfo = FirebaseFirestore.instance.collection('userinfo');
               userinfo.doc(Uemail).update({'quitsteps': int.parse(_steps), 'steps': gettoday(),});
               Navigator.pop(context);},
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
                gettoday().toString(),
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

  Future<int> gettoday() async{
    today = await getTodaySteps(int.parse(_steps));
    return today;
  }



  Future<int> getTodaySteps(int value) async {
    Box<int> stepsBox = Hive.box('steps');
    print(value);
    int savedStepsCountKey = 999999;
    int? savedStepsCount = stepsBox.get(savedStepsCountKey, defaultValue: 0);

    int todayDayNo = Jiffy(DateTime.now()).dayOfYear;
    if (value < savedStepsCount!) {
      // Upon device reboot, pedometer resets. When this happens, the saved counter must be reset as well.
      savedStepsCount = 0;
      // persist this value using a package of your choice here
      stepsBox.put(savedStepsCountKey, savedStepsCount);
    }

    // load the last day saved using a package of your choice here
    int lastDaySavedKey = 888888;
    int? lastDaySaved = stepsBox.get(lastDaySavedKey, defaultValue: 0);

    // When the day changes, reset the daily steps count
    // and Update the last day saved as the day changes.
    if (lastDaySaved! < todayDayNo) {
      lastDaySaved = todayDayNo;
      savedStepsCount = value;

      stepsBox
        ..put(lastDaySavedKey, lastDaySaved)
        ..put(savedStepsCountKey, savedStepsCount);
    }

    setState(() async {
      todaySteps = value - savedStepsCount!;
      int tempquit = await getquit();
      int temp = value - tempquit;
      if (tempquit != 0){
        todaySteps -= temp;
      }
    });
    stepsBox.put(todayDayNo, todaySteps);
    return todaySteps; // this is your daily steps value.
  }


}


