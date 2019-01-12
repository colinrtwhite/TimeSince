import 'package:flutter/material.dart';
import 'package:time_since/prefs.dart';

/// A widget that ensures the preferences singleton
/// is set up before rendering the child widget.
class PreferenceContainer extends StatefulWidget {
  const PreferenceContainer({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => PreferenceContainerState(child);
}

class PreferenceContainerState extends State<PreferenceContainer> {
  PreferenceContainerState(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Prefs.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError) {
          return child;
        } else {
          return Container();
        }
      }
    );
  }
}