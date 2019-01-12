import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {

  static void initSystemUIOverlayStyle() async {
    if (!Platform.isAndroid) {
      return;
    }

    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

    var style = SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
    );

    if (androidInfo.version.sdkInt > 27) {
      style = style.copyWith(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.black
      );
    }

    SystemChrome.setSystemUIOverlayStyle(style);
  }
}
