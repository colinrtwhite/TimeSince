import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {

  static void initSystemUIOverlayStyle() async {
    if (!Platform.isAndroid) {
      return;
    }

    var style = SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
    );

    SystemChrome.setSystemUIOverlayStyle(style);
  }
}
