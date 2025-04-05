import 'package:flutter/material.dart';

/// The Configuration for providing minimal options for mobile platforms when launching Custom Tabs by specifying a URL.
@immutable
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
  /// - Availability: **Only for iOS**
  final Color? onBarColor;

  /// The color configuration of the system navigation bar.
  ///
  /// - Availability: **Only for Android**
  final SystemNavigationBarParams? systemNavigationBarParams;

  /// A Boolean value that indicates whether to keep the app bar fixed, even when scrolling through the page.
  final bool? barFixingEnabled;
}

/// The color configuration of the system navigation bar.
@immutable
class SystemNavigationBarParams {
  /// The color of the system navigation bar.
  final Color backgroundColor;

  /// The color of the system navigation bar divider.
  final Color? dividerColor;

  const SystemNavigationBarParams({
    required this.backgroundColor,
    this.dividerColor,
  });
}
