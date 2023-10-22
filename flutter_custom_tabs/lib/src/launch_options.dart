import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:meta/meta.dart';

/// The Configuration for providing minimal options for mobile platforms when launching Custom Tabs by specifying a URL.
@experimental
class LaunchOptions {
  /// Creates a [LaunchOptions] instance with the specified options.
  const LaunchOptions({
    this.barColor,
    this.onBarColor,
    this.appBarFixed,
    this.systemNavigationBarColor,
  });

  /// The background color of the app bar and bottom bar.
  final Color? barColor;

  /// The color to tint the control buttons on the app bar and bottom bar.
  ///
  /// Availability: **Only for iOS**
  final Color? onBarColor;

  /// The color configuration of the system navigation bar.
  ///
  /// Availability: **Only for Android**
  final SystemNavigationBarColor? systemNavigationBarColor;

  /// A Boolean value that indicates whether to keep the app bar fixed, even when scrolling through the page.
  final bool? appBarFixed;

  /// Converts to [CustomTabsOptions].
  @internal
  CustomTabsOptions toCustomTabsOptions() {
    CustomTabsColorSchemes? colorSchemes;
    if (barColor != null || systemNavigationBarColor != null) {
      colorSchemes = CustomTabsColorSchemes.theme(
        toolbarColor: barColor,
        navigationBarColor: systemNavigationBarColor?.background,
        navigationBarDividerColor: systemNavigationBarColor?.divider,
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
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.done,
    );
  }
}

/// The color configuration of the system navigation bar.
@experimental
class SystemNavigationBarColor {
  /// The color of the system navigation bar.
  final Color background;

  /// The color of the system navigation bar divider.
  final Color? divider;

  SystemNavigationBarColor({
    required this.background,
    this.divider,
  });
}
