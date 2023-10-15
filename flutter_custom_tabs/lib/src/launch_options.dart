import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:meta/meta.dart';

/// The Configuration for providing minimal options for mobile platforms when launching Custom Tabs by specifying a URL.
class LaunchOptions {
  /// Creates a [LaunchOptions] instance with the specified options.
  const LaunchOptions({
    this.barColor,
    this.onBarColor,
    this.appBarFixed,
  });

  /// The background color of the app bar and navigation bar.
  final Color? barColor;

  /// The color to tint the control buttons on the app bar and navigation bar.
  ///
  /// **Only for iOS**
  final Color? onBarColor;

  /// A Boolean value that indicates whether to keep the app bar fixed, even when scrolling through the page.
  final bool? appBarFixed;

  /// Converts to [CustomTabsOptions].
  @internal
  CustomTabsOptions toCustomTabsOptions() {
    CustomTabsColorSchemes? colorSchemes;
    if (barColor != null) {
      colorSchemes = CustomTabsColorSchemes.theme(
        toolbarColor: barColor,
      );
    }

    bool? urlBarHidingEnabled;
    if (appBarFixed != null) {
      urlBarHidingEnabled = !(appBarFixed!);
    }
    return CustomTabsOptions(
      colorSchemes: colorSchemes,
      urlBarHidingEnabled: urlBarHidingEnabled,
      showTitle: true,
    );
  }

  /// Converts to [SafariViewControllerOptions].
  @internal
  SafariViewControllerOptions toSafariViewControllerOptions() {
    bool? barCollapsingEnabled;
    if (appBarFixed != null) {
      barCollapsingEnabled = !(appBarFixed!);
    }
    return SafariViewControllerOptions(
      preferredBarTintColor: barColor,
      preferredControlTintColor: onBarColor,
      barCollapsingEnabled: barCollapsingEnabled,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
    );
  }
}
