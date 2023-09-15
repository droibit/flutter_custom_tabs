import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

/// Open the specified Web URL with Custom Tabs.
///
/// Custom Tabs is only supported on the Android platform.
/// Therefore, Open the web page using Safari View Controller ([`SFSafariViewController`]((https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)),
/// whose appearance can be customized even on iOS.
///
/// When Chrome is not installed on Android device, try to start other browsers.
/// If you want to launch a Custom Tabs compatible browser on a device without Chrome, you can set its package name with `options.extraCustomTabs`.
/// e.g. Firefox(`org.mozilla.firefox`), Microsoft Edge(`com.microsoft.emmx`).
///
/// Example:
///
/// ```dart
/// await launch(
///   'https://flutter.io',
///   customTabsOptions: CustomTabsOptions(
///     toolbarColor: Theme.of(context).primaryColor,
///     urlBarHidingEnabled: true,
///     showPageTitle: true,
///     animation: CustomTabsAnimation.slideIn(),
///     extraCustomTabs: <String>[
///       'org.mozilla.firefox',
///       'com.microsoft.emmx'
///     ],
///   ),
///   safariVCOptions: SafariViewControllerOptions(
///     preferredBarTintColor: Theme.of(context).primaryColor,
///     preferredControlTintColor: Colors.white,
///     barCollapsingEnabled: true,
///     entersReaderIfAvailable: false,
///     dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
///   ),
/// );
/// ```
Future<void> launch(
  String urlString, {
  CustomTabsOptions? customTabsOptions,
  SafariViewControllerOptions? safariVCOptions,
}) async {
  final url = Uri.parse(urlString.trimLeft());
  if (url.scheme != 'http' && url.scheme != 'https') {
    throw PlatformException(
      code: 'NOT_A_WEB_SCHEME',
      message: 'Flutter Custom Tabs only supports URL of http or https scheme.',
    );
  }

  await CustomTabsPlatform.instance.launch(
    url.toString(),
    customTabsOptions: customTabsOptions,
    safariVCOptions: safariVCOptions,
  );
}

Future<void> closeAllIfPossible() async {
  await CustomTabsPlatform.instance.closeAllIfPossible();
}
