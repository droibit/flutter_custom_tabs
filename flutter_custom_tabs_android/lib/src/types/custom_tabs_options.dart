import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:meta/meta.dart';

import 'custom_tabs_animations.dart';
import 'custom_tabs_browser.dart';
import 'custom_tabs_close_button.dart';
import 'custom_tabs_color_schemes.dart';
import 'custom_tabs_share_state.dart';
import 'partial_custom_tabs.dart';

/// A comprehensive set of options for customizing the appearance and behavior of
/// [Custom Tabs](https://developer.chrome.com/docs/android/custom-tabs/) when launching a URL.
///
/// The [CustomTabsOptions] class allows you to tailor the Custom Tabs experience to match
/// your application's theme and requirements. You can customize colors, animations, toolbar
/// behavior, and more.
///
/// ### See Also
/// - [CustomTabsIntent.Builder](https://developer.android.com/reference/androidx/browser/customtabs/CustomTabsIntent.Builder)
@immutable
class CustomTabsOptions implements PlatformOptions {
  /// Creates a [CustomTabsOptions] instance with the specified options.
  const CustomTabsOptions({
    this.colorSchemes,
    this.urlBarHidingEnabled,
    this.shareState,
    this.showTitle,
    this.instantAppsEnabled,
    this.closeButton,
    this.animations,
    this.browser,
    this.partial,
  });

  /// Creates a [CustomTabsOptions] instance with configuration for Partial Custom Tabs.
  const CustomTabsOptions.partial({
    required PartialCustomTabsConfiguration configuration,
    CustomTabsColorSchemes? colorSchemes,
    CustomTabsShareState? shareState,
    bool? showTitle,
    CustomTabsCloseButton? closeButton,
    CustomTabsBrowserConfiguration? browser,
  }) : this(
          colorSchemes: colorSchemes,
          shareState: shareState,
          showTitle: showTitle,
          closeButton: closeButton,
          browser: browser,
          partial: configuration,
        );

  /// Creates a [CustomTabsOptions] instance with HTTP headers for an external browser.
  ///
  /// [headers] can be used to [add extra HTTP request headers](https://developer.chrome.com/docs/android/custom-tabs/howto-custom-tab-request-headers).
  /// Note: Depending on the browser used to launch Custom Tabs, it may not be possible to add arbitrary headers.
  CustomTabsOptions.externalBrowser({
    required Map<String, String> headers,
  }) : this(
          browser:
              CustomTabsBrowserConfiguration.externalBrowser(headers: headers),
        );

  /// The visualization configuration.
  final CustomTabsColorSchemes? colorSchemes;

  /// A Boolean value that enables the url bar to hide as the user scrolls down the page.
  final bool? urlBarHidingEnabled;

  /// The share state that should be applied to the custom tab.
  final CustomTabsShareState? shareState;

  /// A Boolean value that determines whether to show the page title in the toolbar of the custom tab.
  final bool? showTitle;

  /// A Boolean value that indicates whether to enable [Instant Apps](https://developer.android.com/topic/instant-apps/index.html) for this custom tab.
  final bool? instantAppsEnabled;

  /// The close button configuration.
  final CustomTabsCloseButton? closeButton;

  /// The enter and exit animations.
  final CustomTabsAnimations? animations;

  /// The configuration for the custom tab as browser.
  final CustomTabsBrowserConfiguration? browser;

  /// The configuration for Partial Custom Tabs.
  final PartialCustomTabsConfiguration? partial;
}
