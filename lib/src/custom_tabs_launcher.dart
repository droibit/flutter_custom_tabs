import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart'
    show CustomTabsOption;

const MethodChannel _channel =
    const MethodChannel('com.github.droibit.flutter.plugins.custom_tabs');

Future<void> customTabsLauncher(String urlString, CustomTabsOption option) {
  final Uri url = Uri.parse(urlString.trimLeft());
  if (url.scheme != 'http' && url.scheme != 'https') {
    throw new PlatformException(
      code: 'NOT_A_WEB_SCHEME',
      message:
          'Flutter Custom Tabs only supports URLs of http or https scheme.',
    );
  }

  final args = <String, dynamic>{
    'url': urlString,
    'options': option.toMap(),
  };
  return _channel.invokeMethod('launch', args);
}
