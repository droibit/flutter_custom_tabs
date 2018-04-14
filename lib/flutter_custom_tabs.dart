import 'dart:async';

import 'package:flutter/services.dart';

class FlutterCustomTabs {
  static const MethodChannel _channel =
      const MethodChannel('flutter_custom_tabs');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
