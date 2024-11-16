import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:meta/meta.dart';

/// Configuration options for launching a URL using Custom Tabs on Android.
///
/// The [CustomTabsBrowserConfiguration] class allows you to customize how the Custom Tabs browser
/// behaves when launching a URL. By default, the plugin uses Chrome as the Custom Tabs browser.
/// However, you can configure it to prioritize the device's default browser that supports Custom Tabs,
/// specify fallback browsers, or use an existing session for improved performance.
///
/// See also:
/// - [Custom Tabs Browser Support](https://developer.chrome.com/docs/android/custom-tabs/browser-support/)
/// - [Add extra HTTP Request Headers](https://developer.chrome.com/docs/android/custom-tabs/howto-custom-tab-request-headers)
@immutable
class CustomTabsBrowserConfiguration {
  /// Creates a [CustomTabsBrowserConfiguration] with the specified options.
  ///
  /// By default, Chrome is used as the Custom Tabs browser. However, you can prioritize
  /// the device's default browser that supports Custom Tabs over Chrome by setting
  /// [prefersDefaultBrowser] to `true`. You can also specify a list of fallback browsers
  /// using [fallbackCustomTabs].
  ///
  /// [headers] can be used to [add extra HTTP request headers](https://developer.chrome.com/docs/android/custom-tabs/howto-custom-tab-request-headers).
  /// Note: Depending on the browser used to launch Custom Tabs, it may not be possible to add arbitrary headers.
  const CustomTabsBrowserConfiguration({
    this.prefersDefaultBrowser,
    this.fallbackCustomTabs,
    this.headers,
  })  : prefersExternalBrowser = null,
        sessionPackageName = null;

  /// Creates a [CustomTabsBrowserConfiguration] that uses the provided [session].
  ///
  /// This constructor allows you to launch URLs using an existing [CustomTabsSession],
  /// which can improve performance by reusing the same connection.
  ///
  /// [headers] can be used to [add extra HTTP request headers](https://developer.chrome.com/docs/android/custom-tabs/howto-custom-tab-request-headers).
  /// Note: Depending on the browser used to launch Custom Tabs, it may not be possible to add arbitrary headers.
  CustomTabsBrowserConfiguration.session(
    CustomTabsSession session, {
    this.headers,
  })  : sessionPackageName = session.packageName,
        prefersDefaultBrowser = null,
        fallbackCustomTabs = null,
        prefersExternalBrowser = null;

  @internal
  const CustomTabsBrowserConfiguration.externalBrowser({
    required this.headers,
  })  : sessionPackageName = null,
        prefersDefaultBrowser = null,
        fallbackCustomTabs = null,
        prefersExternalBrowser = true;

  /// A Boolean value that determines whether to prioritize the default browser that supports Custom Tabs over Chrome.
  final bool? prefersDefaultBrowser;

  /// Package list of non-Chrome browsers supporting Custom Tabs. The top of the list is used with the highest priority.
  final List<String>? fallbackCustomTabs;

  /// Extra HTTP request headers.
  final Map<String, String>? headers;

  /// The package name of the Custom Tabs corresponding to the session.
  final String? sessionPackageName;

  /// A Boolean value that determines whether to use an external browser.
  @internal
  final bool? prefersExternalBrowser;
}
