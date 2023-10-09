import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

/// Passes [url] with options to the underlying platform for launching a custom tab.
///
/// - On Android, the appearance and behavior of [Custom Tabs](https://developer.chrome.com/docs/android/custom-tabs/) can be customized using the [customTabsOptions] parameter.
/// - On iOS, the appearance and behavior of [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) can be customized using the [safariVCOptions] parameter.
/// - For web, customization options are not available.
///
/// Example:
///
/// ```dart
/// final theme = ...;
/// try {
///   await launchUrlString(
///     'https://flutter.dev',
///     customTabsOptions: CustomTabsOptions(
///       toolbarColor: theme.surface,
///       urlBarHidingEnabled: true,
///       showTitle: true,
///       closeButton: CustomTabsCloseButton(
///         icon: CustomTabsCloseButtonIcon.back,
///       ),
///     ),
///     safariVCOptions: SafariViewControllerOptions(
///       preferredBarTintColor: theme.colorScheme.surface,
///       preferredControlTintColor: theme.colorScheme.onSurface,
///       barCollapsingEnabled: true,
///       dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
///     ),
///   );
/// } catch (e) {
///   // An exception is thrown if browser app is not installed on Android device.
/// }
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

/// Passes [url] with options to the underlying platform for launching a custom tab.
///
/// - On Android, the appearance and behavior of [Custom Tabs](https://developer.chrome.com/docs/android/custom-tabs/) can be customized using the [customTabsOptions] parameter.
/// - On iOS, the appearance and behavior of [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) can be customized using the [safariVCOptions] parameter.
/// - For web, customization options are not available.
///
/// Example:
///
/// ```dart
/// final theme = ...;
/// try {
///   await launchUrl(
///     Uri.parse('https://flutter.dev'),
///     customTabsOptions: CustomTabsOptions(
///       toolbarColor: theme.surface,
///       urlBarHidingEnabled: true,
///       showTitle: true,
///       closeButton: CustomTabsCloseButton(
///         icon: CustomTabsCloseButtonIcon.back,
///       ),
///     ),
///     safariVCOptions: SafariViewControllerOptions(
///       preferredBarTintColor: theme.colorScheme.surface,
///       preferredControlTintColor: theme.colorScheme.onSurface,
///       barCollapsingEnabled: true,
///       dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
///     ),
///   );
/// } catch (e) {
///   // An exception is thrown if browser app is not installed on Android device.
/// }
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

// Closes all custom tabs that were opened earlier by "launchUrl" or "launchUrlString".
Future<void> closeCustomTabs() async {
  await CustomTabsPlatform.instance.closeAllIfPossible();
}
