import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import './custom_tabs_launcher.dart';
import './custom_tabs_option.dart';
import './url_launcher.dart';

/// Open the specified Web URL with Custom Tabs.
///
/// Custom Tab is only supported on the Android platform.
/// Therefore, this plugin uses [url_launcher](https://pub.dartlang.org/packages/url_launcher) on iOS to launch `SFSafariViewController`.
/// (The specified [option] is ignored on iOS.)
///
/// When Chrome is not installed on Android device, try to start other browsers.
/// If you want to launch a CustomTabs compatible browser on a device without Chrome, you can set its package name with `option.extraCustomTabs`.
/// e.g. Firefox(`org.mozilla.firefox`), Microsoft Edge(`com.microsoft.emmx`).
///
/// Example:
///
/// ```dart
/// await launch(
///   'https://flutter.io',
///   option: new CustomTabsOption(
///     toolbarColor: Theme.of(context).primaryColor,
///     enableUrlBarHiding: true,
///     showPageTitle: true,
///     animation: new CustomTabsAnimation.slideIn(),
///     extraCustomTabs: <String>[
///       'org.mozilla.firefox',
///       'com.microsoft.emmx'
///     ],
///   ),
/// );
/// ```
Future<void> launch(
  String urlString, {
  @required CustomTabsOption? option,
}) {
  assert(option != null);

  return _launcher(urlString, option!);
}

typedef _PlatformLauncher = Future<void> Function(
  String urlString,
  CustomTabsOption option,
);

_PlatformLauncher get _launcher {
  _platformLauncher = Platform.isAndroid ? customTabsLauncher : urlLauncher;
  return _platformLauncher;
}

late _PlatformLauncher _platformLauncher;
