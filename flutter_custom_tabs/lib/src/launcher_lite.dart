import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:meta/meta.dart';

import 'types/launch_options.dart';

/// Passes [url] with options to the underlying platform for launching a custom tab.
///
/// Example:
///
/// ```dart
/// final theme = ...;
/// try {
///   await launchUrl(
///     Uri.parse('https://flutter.dev'),
///     options: LaunchOptions(
///       barColor: theme.colorScheme.surface,
///       onBarColor: theme.colorScheme.onSurface,
///       appBarFixed: false,
///     ),
///   );
/// } catch (e) {
///   // An exception is thrown if browser app is not installed on Android device.
/// }
@experimental
Future<void> launchUrl(
  Uri url, {
  bool prefersDeepLink = false,
  LaunchOptions options = const LaunchOptions(),
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
    customTabsOptions: options.toCustomTabsOptions(),
    safariVCOptions: options.toSafariViewControllerOptions(),
  );
}
