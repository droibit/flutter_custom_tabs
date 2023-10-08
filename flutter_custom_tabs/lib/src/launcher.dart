import 'dart:async';

import 'package:flutter/services.dart';
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
/// await launchUrlString(
///   'https://flutter.dev',
///   customTabsOptions: CustomTabsOptions(
///     toolbarColor: Theme.of(context).primaryColor,
///     urlBarHidingEnabled: true,
///     showTitle: true,
///     closeButton: CustomTabsCloseButton(
///       icon: CustomTabsCloseButtonIcon.back,
///     ),
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
Future<void> launchUrlString(
  String urlString, {
  bool prefersDeepLink = false,
  CustomTabsOptions? customTabsOptions,
  SafariViewControllerOptions? safariVCOptions,
}) async {
  await launchUrl(
    Uri.parse(urlString.trimLeft()),
    prefersDeepLink: prefersDeepLink,
    customTabsOptions: customTabsOptions,
    safariVCOptions: safariVCOptions,
  );
}

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
/// await launchUrl(
///   'https://flutter.dev',
///   customTabsOptions: CustomTabsOptions(
///     toolbarColor: Theme.of(context).primaryColor,
///     urlBarHidingEnabled: true,
///     showTitle: true,
///     closeButton: CustomTabsCloseButton(
///       icon: CustomTabsCloseButtonIcon.back,
///     ),
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
Future<void> launchUrl(
  Uri url, {
  bool prefersDeepLink = false,
  CustomTabsOptions? customTabsOptions,
  SafariViewControllerOptions? safariVCOptions,
}) async {
  if (url.scheme != 'http' && url.scheme != 'https') {
    throw PlatformException(
      code: 'NOT_A_WEB_SCHEME',
      message: 'Flutter Custom Tabs only supports URL of http or https scheme.',
    );
  }

  await CustomTabsPlatform.instance.launch(
    url.toString(),
    prefersDeepLink: prefersDeepLink,
    customTabsOptions: customTabsOptions,
    safariVCOptions: safariVCOptions,
  );
}

Future<void> closeCustomTabs() async {
  await CustomTabsPlatform.instance.closeAllIfPossible();
}
