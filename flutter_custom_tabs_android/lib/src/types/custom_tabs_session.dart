import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:meta/meta.dart';

/// Represents a session with a Custom Tabs application.
///
/// A [CustomTabsSession] allows you to establish a connection to a Custom Tabs provider,
/// enabling features like pre-warming the browser and pre-fetching content to improve
/// performance when launching URLs. 
@immutable
class CustomTabsSession implements PlatformSession {  
  const CustomTabsSession(this.packageName);

  /// The package name of the Custom Tabs application corresponding to the session.
  final String? packageName;

  @override
  String toString() => 'CustomTabsSession: $packageName';
}

/// Options for creating a Custom Tabs session.
///
/// [CustomTabsSessionOptions] allows you to customize the behavior of a custom tabs session
/// when establishing a connection to a Custom Tabs provider. 
@immutable
class CustomTabsSessionOptions implements PlatformOptions {
  const CustomTabsSessionOptions({
    this.prefersDefaultBrowser,
    this.fallbackCustomTabs,
  });

  /// A Boolean value that determines whether to prioritize the default browser that supports Custom Tabs over Chrome.
  final bool? prefersDefaultBrowser;

  /// Package list of non-Chrome browsers supporting Custom Tabs. The top of the list is used with the highest priority.
  final List<String>? fallbackCustomTabs;
}