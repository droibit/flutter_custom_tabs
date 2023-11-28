import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';
import 'package:meta/meta.dart';

/// The Configuration for providing minimal options for mobile platforms when launching Custom Tabs by specifying a URL.
@experimental
class LaunchOptions {
  /// Creates a [LaunchOptions] instance with the specified options.
  const LaunchOptions({
    this.barColor,
    this.onBarColor,
    this.systemNavigationBarParams,
    this.barFixingEnabled,
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
  final SystemNavigationBarParams? systemNavigationBarParams;

  /// A Boolean value that indicates whether to keep the app bar fixed, even when scrolling through the page.
  final bool? barFixingEnabled;

  /// Converts to [CustomTabsOptions].
  @internal
  CustomTabsOptions toCustomTabsOptions() {
    CustomTabsColorSchemes? colorSchemes;
    if (barColor != null || systemNavigationBarParams != null) {
      colorSchemes = CustomTabsColorSchemes.defaults(
        toolbarColor: barColor,
        navigationBarColor: systemNavigationBarParams?.backgroundColor,
        navigationBarDividerColor: systemNavigationBarParams?.dividerColor,
      );
    }

    bool? urlBarHidingEnabled;
    if (barFixingEnabled != null) {
      urlBarHidingEnabled = !(barFixingEnabled!);
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
    if (barFixingEnabled != null) {
      barCollapsingEnabled = !(barFixingEnabled!);
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
class SystemNavigationBarParams {
  /// The color of the system navigation bar.
  final Color backgroundColor;

  /// The color of the system navigation bar divider.
  final Color? dividerColor;

  SystemNavigationBarParams({
    required this.backgroundColor,
    this.dividerColor,
  });
}
