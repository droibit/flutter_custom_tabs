import 'dart:async';

import 'package:flutter/services.dart';

import 'custom_tabs_option.dart';

const MethodChannel _channel =
    MethodChannel('com.github.droibit.flutter.plugins.custom_tabs');

Future<void> customTabsLauncher(String urlString, CustomTabsOption option) {
  final args = <String, dynamic>{
    'url': urlString,
    'option': option.toMap(),
  };
  return _channel.invokeMethod('launch', args);
}
