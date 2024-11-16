import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

/// Launches a web URL using a custom tab or browser, with various customization options.
///
/// The [launchUrl] function provides a way to open web content within your app using
/// a customizable in-app browser experience on Android and iOS platforms.
///
/// ### Supported Platforms
///
/// - **Android**: Uses [Custom Tabs](https://developer.chrome.com/docs/android/custom-tabs/)
///   to display web content within your app. Customize the appearance and behavior
///   using the [customTabsOptions] parameter.
/// - **iOS**: Uses [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
///   to present web content. Customize using the [safariVCOptions] parameter.
/// - **Web**: Customization options are not available; the URL will be opened in a new browser tab.
///
/// ### Examples
///
/// **Launch a URL with customization:**
///
/// ```dart
/// final theme = ...;
/// try {
///   await launchUrl(
///     Uri.parse('https://flutter.dev'),
///     customTabsOptions: CustomTabsOptions(
///       colorSchemes: CustomTabsColorSchemes.defaults(
///         toolbarColor: theme.colorScheme.surface,
///       ),
///       urlBarHidingEnabled: true,
///       showTitle: true,
///       closeButton: CustomTabsCloseButton(
///         icon: CustomTabsCloseButtonIcons.back,
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
///   // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
/// }
/// ```
///
/// **Launch a URL in the external browser:**
///
/// ```dart
/// try {
///   await launchUrl(Uri.parse('https://flutter.dev'));
/// } catch (e) {
///   // An exception is thrown if browser app is not installed on Android device.
/// }
/// ```
/// 
/// ### Notes
///
/// - The URL must have an `http` or `https` scheme; otherwise, a [PlatformException] is thrown.
/// - Use [closeCustomTabs] to programmatically close the custom tab if needed.
/// - Make sure to call the [warmupCustomTabs] function before launching the URL to improve performance.
///
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

/// Closes all Custom Tabs that were opened earlier by [launchUrl].
/// 
/// **Platform Availability:**
/// - **Android:** Supported on SDK 23 (Android 6.0) and above.
/// - **iOS:** All versions.
/// - **Web:** Not supported.
Future<void> closeCustomTabs() async {
  await CustomTabsPlatform.instance.closeAllIfPossible();
}

/// Pre-warms the Custom Tabs browser process, potentially improving performance when launching a URL.
///
/// On **Android**, calling `warmupCustomTabs()` initializes the Custom Tabs service,
/// causing the browser process to start in the background even before the user clicks on a link.
/// This can save up to **700ms** when opening a link. If [options] are not provided,
/// the default browser to warm up is **Chrome**.
///
/// For more details, see
/// [Warm-up and pre-fetch: using the Custom Tabs Service](https://developer.chrome.com/docs/android/custom-tabs/guide-warmup-prefetch).
///
/// On **other platforms**, this method does nothing.
/// 
/// **Note:** It's recommended to call [invalidateSession] when the session is no longer needed to release resources.
///
/// Returns a [CustomTabsSession] which can be used when launching a URL with a specific session.
/// 
/// ### Example
///
/// ```dart
/// final session = await warmupCustomTabs(
///   options: const CustomTabsSessionOptions(prefersDefaultBrowser: true),
/// );
/// debugPrint('Warm up session: $session');
/// 
/// await launchUrl(
///   Uri.parse('https://flutter.dev'),
///   customTabsOptions: CustomTabsOptions(
///     colorSchemes: CustomTabsColorSchemes.defaults(
///       toolbarColor: theme.colorScheme.surface,
///     ),
///     urlBarHidingEnabled: true,
///     showTitle: true,
///     browser: CustomTabsBrowserConfiguration.session(session),
///   ),
///   safariVCOptions: SafariViewControllerOptions(
///     preferredBarTintColor: theme.colorScheme.surface,
///     preferredControlTintColor: theme.colorScheme.onSurface,
///     barCollapsingEnabled: true,
///   ),
/// );
/// ```
Future<CustomTabsSession> warmupCustomTabs({
  CustomTabsSessionOptions? options,
}) async {
  final session = await CustomTabsPlatform.instance.warmup(options);
  return session as CustomTabsSession? ?? const CustomTabsSession(null);
}

Future<void> invalidateSession(PlatformSession session) {
  return CustomTabsPlatform.instance.invalidate(session);
}