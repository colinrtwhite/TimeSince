import 'package:flutter/material.dart';
import 'package:time_since/constants.dart';
import 'package:time_since/count_up.dart';
import 'package:time_since/preference_container.dart';
import 'package:time_since/prefs.dart';
import 'package:time_since/utils.dart';

void main() => runApp(TimeSinceApp());

class TimeSinceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Utils.initSystemUIOverlayStyle();

    return PreferenceContainer(
      child: MaterialApp(
        title: 'Time Since',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainActivity(),
      ),
    );
  }
}

class MainActivity extends StatefulWidget {
  @override
  MainActivityState createState() => MainActivityState();
}

class MainActivityState extends State<MainActivity> with TickerProviderStateMixin {

  AnimationController controller;
  DateTime startTime;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(days: 999)
    );
    controller.forward();
    startTime = _getStartTime();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CountUp(
              listenable: controller,
              startTime: startTime,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showResetStartTimeDialog,
        tooltip: 'Update',
        child: Icon(Icons.update),
      ),
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
    showDatePicker(
      context: context,
      initialDate: startTime,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(startTime)
        ).then((time) {
          if (time != null) {
            var newStartTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
            var now = DateTime.now();
            if (newStartTime.isAfter(now)) {
              newStartTime = now;
            }
            _setStartTime(newStartTime);
          }
        });
      }
    });
  }

  void _setStartTime(DateTime startTime) async {
    Prefs.setInt(Constants.PREF_START_TIME, startTime.millisecondsSinceEpoch);
    setState(() {
      this.startTime = startTime;
    });
  }

  DateTime _getStartTime() {
    var startTimeMillis = Prefs.getInt(Constants.PREF_START_TIME, -1);
    if (startTimeMillis == -1) {
      var now = DateTime.now();
      _setStartTime(now);
      return now;
    } else {
      return DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
    }
  }
}
