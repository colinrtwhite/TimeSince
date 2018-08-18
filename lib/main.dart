import 'dart:async';

import 'package:flutter/material.dart';

import 'count_up.dart';
import 'prefs.dart';
import 'utils.dart';

void main() => runApp(TimeSinceApp());

class TimeSinceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Utils.initStatusBar();

    return MaterialApp(
      title: "Time Since",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainActivity(),
    );
  }
}

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> with TickerProviderStateMixin {
  static const PREF_START_TIME = 'start_time';

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    Prefs.init();
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 999)
    );
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    Prefs.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildCountUp()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showResetStartTimeDialog,
        tooltip: 'Update',
        child: Icon(Icons.update),
      ),
    );
  }

  FutureBuilder<int> _buildCountUp() {
    return FutureBuilder<int>(
      future: _getStartTime(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return CountUp(
            listenable: controller,
            startTime: DateTime.fromMillisecondsSinceEpoch(snapshot.data),
          );
        }
      },
    );
  }

  void _showResetStartTimeDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set the timer to...'),
          actions: <Widget>[
            FlatButton(
              child: Text('Now'),
              onPressed: () {
                _setStartTime(DateTime.now());
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Custom time'),
              onPressed: () {
                Navigator.of(context).pop();
                _showDateTimePicker();
              },
            )
          ]
        );
      },
    );
  }

  void _showDateTimePicker() async {
    var now = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: now,
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now()
        ).then((time) {
          if (time != null) {
            var newStartTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
            if (newStartTime.isAfter(DateTime.now())) {
              newStartTime = DateTime.now();
            }
            _setStartTime(newStartTime);
          }
        });
      }
    });
  }

  void _setStartTime(DateTime startTime) async {
    await Prefs.setInt(PREF_START_TIME, startTime.millisecondsSinceEpoch);
    setState(() { /* Force this widget's state to rebuild. */ });
  }

  Future<int> _getStartTime() async {
    var startTimeMillis = await Prefs.getIntF(PREF_START_TIME, -1);
    if (startTimeMillis == -1) {
      _setStartTime(DateTime.fromMillisecondsSinceEpoch(startTimeMillis));
    }
    return startTimeMillis;
  }
}
