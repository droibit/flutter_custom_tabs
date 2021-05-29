import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/src/safari_view_controller_option.dart';

import 'custom_tabs_option.dart';

const MethodChannel _channel =
    MethodChannel('com.github.droibit.flutter.plugins.custom_tabs');

Future<void> customTabsLauncher(
  String urlString,
  CustomTabsOption? customTabsOption,
  SafariViewControllerOption? safariVCOption,
) {
  final args = <String, dynamic>{
    'url': urlString,
    'customTabsOption': customTabsOption?.toMap() ?? <String, dynamic>{},
    'safariVCOption': safariVCOption?.toMap() ?? <String, dynamic>{}
  };
  return _channel.invokeMethod('launch', args);
}
