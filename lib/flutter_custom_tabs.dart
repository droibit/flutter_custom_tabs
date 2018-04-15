import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'src/custom_tabs_launcher.dart';
import 'src/url_launcher.dart';

class CustomTabsOption {
  final Color toolbarColor;

  final bool enableUrlBarHiding;

  final bool enableDefaultShare;

  final bool showPageTitle;

  const CustomTabsOption({
    this.toolbarColor,
    this.enableUrlBarHiding,
    this.enableDefaultShare,
    this.showPageTitle,
  });

  Map<String, dynamic> toMap() {
    final dest = new Map<String, dynamic>();
    if (toolbarColor != null) {
      dest['toolbarColor'] = "#${toolbarColor.value.toRadixString(16)}";
    }
    if (enableUrlBarHiding != null) {
      dest['enableUrlBarHiding'] = enableUrlBarHiding;
    }
    if (enableDefaultShare != null) {
      dest['enableDefaultShare'] = enableDefaultShare;
    }
    if (showPageTitle != null) {
      dest['showPageTitle'] = showPageTitle;
    }
    return dest;
  }
}

Future<void> launch(
  String urlString, {
  @required CustomTabsOption option,
}) {
  assert(urlString != null);
  assert(option != null);

  if (Platform.isAndroid) {
    return customTabsLauncher(urlString, option);
  } else {
    return urlLauncher(urlString);
  }
}
