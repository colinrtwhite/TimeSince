import 'package:flutter/material.dart';
import 'dart:async';
import 'prefs.dart';
import 'count_up.dart';
import 'utils.dart';

void main() => runApp(TimeSinceApp());

class TimeSinceApp extends StatelessWidget {
  final String title = "Time Since";

  @override
  Widget build(BuildContext context) {
    Utils.initStatusBar();

    return MaterialApp(
      title: title,
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
  static const ANIMATION_DURATION = Duration.secondsPerDay * 999;

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    Prefs.init();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: ANIMATION_DURATION),
    );
    _loadStartTime();
  }

  @override
  void dispose() {
    super.dispose();
    Prefs.dispose();
  }

  void _loadStartTime() async {
    var startTimeMillis = await Prefs.getIntF(PREF_START_TIME);

    if (startTimeMillis == 0) {
      _setStartTime(DateTime.now());
    } else {
      _syncStartTime(startTimeMillis);
    }
  }

  void _setStartTime(DateTime startTime) async {
    var startTimeMillis = startTime.millisecondsSinceEpoch;
    await Prefs.setInt(PREF_START_TIME, startTimeMillis);
    _syncStartTime(startTimeMillis);
  }

  void _syncStartTime(int startTimeMillis) {
    var nowMillis = DateTime.now().millisecondsSinceEpoch;
    var secondsSince = (nowMillis - startTimeMillis) / Duration.millisecondsPerSecond;
    controller.forward(from: secondsSince / ANIMATION_DURATION);
  }

  Future<Null> _showResetStartTimeDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset timer?'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Wrap(
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                    ButtonTheme.bar(
                      child: FlatButton(
                        child: Text('Set to now'),
                        onPressed: () {
                          _setStartTime(DateTime.now());
                          Navigator.of(context).pop();
                        },
                      )
                    )
                  ]
                ),
                Wrap(
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                    ButtonTheme.bar(
                      child: FlatButton(
                        child: Text('Set to custom time'),
                        onPressed: () {
                          _showDateTimePicker();
                          Navigator.of(context).pop();
                        },
                      )
                    )
                  ]
                ),
                Wrap(
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                    ButtonTheme.bar(
                      child: FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    )
                  ]
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Null> _showDateTimePicker() async {
    var now = DateTime.now();
    return showDatePicker(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CountUp(
              animation: StepTween(begin: 0, end: ANIMATION_DURATION).animate(controller),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showResetStartTimeDialog,
        tooltip: 'Reset',
        child: Icon(Icons.update),
      ),
    );
  }
}
