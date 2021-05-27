import 'dart:async';

import 'package:flutter/services.dart';

import './custom_tabs_launcher.dart';
import './custom_tabs_option.dart';
import './safari_view_controller_option.dart';

/// Open the specified Web URL with Chrome Custom Tabs(Safari View Controller).
///
/// Chrome Custom Tabs is only supported on the Android platform.
/// Therefore, Open the web page using Safari View Controller ([`SFSafariViewController`]((https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)),
/// whose appearance can be customized even on iOS.
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
///   customTabsOption: CustomTabsOption(
///     toolbarColor: Theme.of(context).primaryColor,
///     enableUrlBarHiding: true,
///     showPageTitle: true,
///     animation: CustomTabsAnimation.slideIn(),
///     extraCustomTabs: <String>[
///       'org.mozilla.firefox',
///       'com.microsoft.emmx'
///     ],
///   ),
///   safariVCOption: SafariViewControllerOption(
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
  CustomTabsOption? customTabsOption,
  SafariViewControllerOption? safariVCOption,
}) {
  final url = Uri.parse(urlString.trimLeft());
  if (url.scheme != 'http' && url.scheme != 'https') {
    throw PlatformException(
      code: 'NOT_A_WEB_SCHEME',
      message: 'Flutter Custom Tabs only supports URL of http or https scheme.',
    );
  }
  return customTabsLauncher(urlString, customTabsOption, safariVCOption);
}
