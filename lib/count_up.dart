import 'package:flutter/material.dart';

class CountUp extends AnimatedWidget {
  CountUp({Key key, this.animation}) : super(key: key, listenable: animation);

  final Animation<int> animation;

  final int secondsPerYear = 365 * Duration.secondsPerDay;
  final int secondsPerMonth = 30 * Duration.secondsPerDay;
  final int secondsPerWeek = 7 * Duration.secondsPerDay;
  final int secondsPerDay = Duration.secondsPerDay;
  final int secondsPerHour = Duration.secondsPerHour;
  final int secondsPerMinute = Duration.secondsPerMinute;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatText(),
      style: TextStyle(fontSize: 48.0),
    );
  }

  String formatText() {
    var builder = StringBuffer();
    var timeInSeconds = animation.value;

    var numYears = timeInSeconds ~/ secondsPerYear;
    timeInSeconds -= numYears * secondsPerYear;
    if (numYears > 0) {
      builder.write(numYears);
      builder.writeln(numYears > 1 ? " years" : " year");
    }

    var numMonths = timeInSeconds ~/ secondsPerMonth;
    timeInSeconds -= numMonths * secondsPerMonth;
    if (numMonths > 0) {
      builder.write(numMonths);
      builder.writeln(numMonths > 1 ? " months" : " month");
    }

    var numWeeks = timeInSeconds ~/ secondsPerWeek;
    timeInSeconds -= numWeeks * secondsPerWeek;
    if (numWeeks > 0) {
      builder.write(numWeeks);
      builder.writeln(numWeeks > 1 ? " weeks" : " week");
    }

    var numDays = timeInSeconds ~/ secondsPerDay;
    timeInSeconds -= numDays * secondsPerDay;
    if (numDays > 0) {
      builder.write(numDays);
      builder.writeln(numDays > 1 ? " days" : " day");
    }

    var numHours = timeInSeconds ~/ secondsPerHour;
    timeInSeconds -= numHours * secondsPerHour;
    if (numHours > 0) {
      builder.write(numHours);
      builder.writeln(numHours > 1 ? " hours" : " hour");
    }

    var numMinutes = timeInSeconds ~/ secondsPerMinute;
    timeInSeconds -= numMinutes * secondsPerMinute;
    if (numMinutes > 0) {
      builder.write(numMinutes);
      builder.writeln(numMinutes > 1 ? " minutes" : " minute");
    }

    var numSeconds = timeInSeconds;
    if (numSeconds > 0) {
      builder.write(numSeconds);
      builder.writeln(numSeconds > 1 ? " seconds" : " second");
    }

    return builder.toString();
  }
}
