import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';

/// Option class for customizing appearance of Custom Tabs.
/// **This option applies only on Android platform.**
///
/// See also:
///
/// * [CustomTabsIntent.Builder](https://developer.android.com/reference/android/support/customtabs/CustomTabsIntent.Builder.html)
///
@immutable
class CustomTabsOption {
  const CustomTabsOption({
    this.toolbarColor,
    this.enableUrlBarHiding,
    this.enableDefaultShare,
    this.showPageTitle,
    this.enableInstantApps,
    this.closeButtonPosition,
    this.animation,
    this.extraCustomTabs,
    this.headers,
    this.shareState,
    this.initialHeightPx,
    this.heightResizeBehaviour,
    this.toolbarCornerRadiusDp
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

  /// Define share state for the custom tabs browser.
  /// **This applies only on Android platform.**
  ///
  /// See also:
  ///
  /// * https://developer.android.com/reference/androidx/browser/customtabs/CustomTabsIntent.Builder#setShareState(int)
  ///
  final CustomTabsShareState? shareState;

  /// Extra that, if set, makes the Custom Tab Activity's height to be x pixels, the Custom Tab
  /// will behave as a bottom sheet. x will be clamped between 50% and 100% of screen height.
  /// Bottom sheet does not take effect in landscape mode or in multi-window mode.
  final int? initialHeightPx;

  /// Extra that, if set in combination with [initialHeightPx],
  /// defines the height resize behavior of the Custom Tab Activity when
  /// it behaves as a bottom sheet. Default is [ActivityHeightResizeBehaviour.defaultBehaviour].
  final ActivityHeightResizeBehaviour? heightResizeBehaviour;

  /// Extra that sets the toolbar's top corner radii in dp. This will only have
  /// effect if the custom tab is behaving as a bottom sheet. Currently, this is capped at 16dp.
  final int? toolbarCornerRadiusDp;

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
    if (shareState != null) {
      dest['shareState'] = shareState!.index;
    }
    if (initialHeightPx != null) {
      dest['initialHeightPx'] = initialHeightPx;
    }
    final behaviour = heightResizeBehaviour?.index ??
        ActivityHeightResizeBehaviour.defaultBehaviour.index;
    dest['heightResizeBehaviour'] = behaviour;

    if (toolbarCornerRadiusDp != null) {
      dest['toolbarCornerRadiusDp'] = toolbarCornerRadiusDp;
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
enum CustomTabsCloseButtonPosition { start, end }

extension CustomTabsCloseButtonPositionRawValue
    on CustomTabsCloseButtonPosition {
  @visibleForTesting
  int get rawValue {
    switch (this) {
      case CustomTabsCloseButtonPosition.start:
        return 1;
      case CustomTabsCloseButtonPosition.end:
        return 2;
    }
  }
}

/// Define share state for the custom tabs browser.
enum CustomTabsShareState {
  defaultState,
  on,
  off,
}

/// Define activity resize behaviour when set along with [initialHeightPx]
enum ActivityHeightResizeBehaviour {
  defaultBehaviour,
  adjustable,
  fixed,
}
