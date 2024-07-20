import 'package:meta/meta.dart';

/// The configuration for the custom tab as browser.
///
/// By default, Chrome is used as the custom tab browser.
/// However, the default browser for the device can be prioritized over Chrome.
///
/// See also:
/// - [Custom Tabs Browser Support](https://developer.chrome.com/docs/android/custom-tabs/browser-support/)
@immutable
class CustomTabsBrowserConfiguration {
  const CustomTabsBrowserConfiguration({
    this.prefersDefaultBrowser,
    this.fallbackCustomTabs,
    this.headers,
  }) : prefersExternalBrowser = null;

  @internal
  const CustomTabsBrowserConfiguration.externalBrowser({
    required this.headers,
  })  : prefersDefaultBrowser = null,
        fallbackCustomTabs = null,
        prefersExternalBrowser = true;

  /// A Boolean value that determines whether to prioritize the default browser that supports Custom Tabs over Chrome.
  final bool? prefersDefaultBrowser;

  /// Package list of non-Chrome browsers supporting Custom Tabs. The top of the list is used with the highest priority.
  final List<String>? fallbackCustomTabs;

  /// Extra HTTP request headers.
  final Map<String, String>? headers;

  @internal
  final bool? prefersExternalBrowser;
}
