import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';

/// Options class for customizing appearance of Custom Tabs.
/// **This options applied only on Android platform.**
///
/// See also:
///
/// * [CustomTabsIntent.Builder](https://developer.android.com/reference/android/support/customtabs/CustomTabsIntent.Builder.html)
///
@immutable
class CustomTabsOptions {
  const CustomTabsOptions({
    this.toolbarColor,
    this.enableUrlBarHiding,
    this.enableDefaultShare,
    this.showPageTitle,
    this.enableInstantApps,
    this.closeButtonPosition,
    this.animation,
    this.extraCustomTabs,
    this.headers,
  });

  /// Custom tab toolbar color.
  final Color? toolbarColor;

  /// If enabled, hides the toolbar when the user scrolls down the page.
  final bool? enableUrlBarHiding;

  /// If enabled, default sharing menu is added.
  final bool? enableDefaultShare;

  /// Show web page title in tool bar.
  final bool? showPageTitle;

  /// If enabled, allow custom tab to use [Instant Apps](https://developer.android.com/topic/instant-apps/index.html).
  final bool? enableInstantApps;

  /// The position of the close button of Custom Tabs.
  final CustomTabsCloseButtonPosition? closeButtonPosition;

  ///  Enter and exit animation.
  final CustomTabsAnimation? animation;

  ///  Package list of non-Chrome browsers supporting Custom Tabs. The top of the list is used with the highest priority.
  final List<String>? extraCustomTabs;

  /// Request Headers
  final Map<String, String>? headers;

  @internal
  Map<String, dynamic> toMap() {
    final dest = <String, dynamic>{};
    if (toolbarColor != null) {
      dest['toolbarColor'] = '#${toolbarColor!.value.toRadixString(16)}';
    }
    if (enableUrlBarHiding != null) {
      dest['enableUrlBarHiding'] = enableUrlBarHiding;
    }
    if (enableDefaultShare != null) {
      dest['enableDefaultShare'] = enableDefaultShare;
    }
    if (showPageTitle != null) {
      dest['showPageTitle'] = showPageTitle;
    }
    if (enableInstantApps != null) {
      dest['enableInstantApps'] = enableInstantApps;
    }
    if (animation != null) {
      dest['animations'] = animation!.toMap();
    }
    if (extraCustomTabs != null) {
      dest['extraCustomTabs'] = extraCustomTabs;
    }
    if (closeButtonPosition != null) {
      dest['closeButtonPosition'] = closeButtonPosition!.rawValue;
    }
    if (headers != null) {
      dest['headers'] = headers;
    }
    return dest;
  }
}

/// Enter and exit animation for Custom Tabs.
/// **This animation applies only on Android platform.**
///
/// An animation specification is as follows:
/// * For application animation resources, only resource file name.
///  * e.g. `slide_up`
/// * Otherwise a resource identifier and type `anim` fixed.
///  * e.g. `android:anim/fade_in`
///
/// See also:
///
/// * [View Animation](https://developer.android.com/guide/topics/resources/animation-resource.html#View)
/// * https://developer.android.com/reference/android/content/res/Resources.html#getIdentifier(java.lang.String,%20java.lang.String,%20java.lang.String)
///
@immutable
class CustomTabsAnimation {
  const CustomTabsAnimation({
    this.startEnter,
    this.startExit,
    this.endEnter,
    this.endExit,
  });

  /// Enter animation for the custom tab.
  final String? startEnter;

  /// Exit animation for the application.
  final String? startExit;

  /// Enter animation for the application.
  final String? endEnter;

  /// Exit animation for the custom tab.
  final String? endExit;

  @internal
  Map<String, String> toMap() {
    final dest = <String, String>{};
    if (startEnter != null && startExit != null) {
      dest['startEnter'] = startEnter!;
      dest['startExit'] = startExit!;
    }
    if (endEnter != null && endExit != null) {
      dest['endEnter'] = endEnter!;
      dest['endExit'] = endExit!;
    }
    return dest;
  }
}

/// The position of the close button of Custom Tabs.
enum CustomTabsCloseButtonPosition {
  start(1),
  end(2);

  @internal
  const CustomTabsCloseButtonPosition(this.rawValue);

  @internal
  final int rawValue;
}
