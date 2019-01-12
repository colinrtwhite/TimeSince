import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CountUp extends AnimatedWidget {
  CountUp({Key key, Listenable listenable, @required this.startTime}) : super(key: key, listenable: listenable);

  static const int SECONDS_PER_YEAR = 365 * Duration.secondsPerDay;
  static const int SECONDS_PER_MONTH = 30 * Duration.secondsPerDay;
  static const int SECONDS_PER_WEEK = 7 * Duration.secondsPerDay;
  static const int SECONDS_PER_DAY = Duration.secondsPerDay;
  static const int SECONDS_PER_HOUR = Duration.secondsPerHour;
  static const int SECONDS_PER_MINUTE = Duration.secondsPerMinute;

  final DateTime startTime;

  @override
  Widget build(BuildContext context) {
    var result = _buildText();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.0),
      child: AutoSizeText(
        result.text,
        maxLines: max(result.numLines, 1),
        style: TextStyle(fontSize: 64.0),
      ),
    );
  }

  _Result _buildText() {
    var builder = StringBuffer();
    var numLines = 0;
    var timeInSeconds = DateTime.now().difference(startTime).inSeconds;

    var numYears = timeInSeconds ~/ SECONDS_PER_YEAR;
    timeInSeconds -= numYears * SECONDS_PER_YEAR;
    if (numYears > 0) {
      builder.write(numYears);
      builder.writeln(numYears > 1 ? " years" : " year");
      numLines++;
    }

    var numMonths = timeInSeconds ~/ SECONDS_PER_MONTH;
    timeInSeconds -= numMonths * SECONDS_PER_MONTH;
    if (numMonths > 0) {
      builder.write(numMonths);
      builder.writeln(numMonths > 1 ? " months" : " month");
      numLines++;
    }

    var numWeeks = timeInSeconds ~/ SECONDS_PER_WEEK;
    timeInSeconds -= numWeeks * SECONDS_PER_WEEK;
    if (numWeeks > 0) {
      builder.write(numWeeks);
      builder.writeln(numWeeks > 1 ? " weeks" : " week");
      numLines++;
    }

    var numDays = timeInSeconds ~/ SECONDS_PER_DAY;
    timeInSeconds -= numDays * SECONDS_PER_DAY;
    if (numDays > 0) {
      builder.write(numDays);
      builder.writeln(numDays > 1 ? " days" : " day");
      numLines++;
    }

    var numHours = timeInSeconds ~/ SECONDS_PER_HOUR;
    timeInSeconds -= numHours * SECONDS_PER_HOUR;
    if (numHours > 0) {
      builder.write(numHours);
      builder.writeln(numHours > 1 ? " hours" : " hour");
      numLines++;
    }

    var numMinutes = timeInSeconds ~/ SECONDS_PER_MINUTE;
    timeInSeconds -= numMinutes * SECONDS_PER_MINUTE;
    if (numMinutes > 0) {
      builder.write(numMinutes);
      builder.writeln(numMinutes > 1 ? " minutes" : " minute");
      numLines++;
    }

    var numSeconds = timeInSeconds;
    if (numSeconds > 0) {
      builder.write(numSeconds);
      builder.writeln(numSeconds > 1 ? " seconds" : " second");
      numLines++;
    }

    return _Result(
      text: builder.toString().trim(),
      numLines: numLines
    );
  }
}

class _Result {
  _Result({@required this.text, @required this.numLines});

  final String text;
  final int numLines;
}