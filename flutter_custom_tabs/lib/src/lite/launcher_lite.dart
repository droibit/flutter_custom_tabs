import 'dart:async';

import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

import 'launch_options.dart';
import 'type_conversion.dart';

/// Passes [url] with options to the underlying platform for launching a Custom Tab.
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
///       barFixingEnabled: false,
///     ),
///   );
/// } catch (e) {
///   // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
/// }
Future<void> launchUrl(
  Uri url, {
  bool prefersDeepLink = false,
  LaunchOptions options = const LaunchOptions(),
}) async {
  if (url.scheme != 'http' && url.scheme != 'https') {
    throw ArgumentError.value(
      url,
      'url',
      'must have an http or https scheme.',
    );
  }

  await CustomTabsPlatform.instance.launch(
    url.toString(),
    prefersDeepLink: prefersDeepLink,
    customTabsOptions: options.toCustomTabsOptions(),
    safariVCOptions: options.toSafariViewControllerOptions(),
  );
}
