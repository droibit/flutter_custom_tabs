import 'dart:math';

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
    this.colorSchemes,
    this.urlBarHidingEnabled,
    this.shareState,
    this.showPageTitle,
    this.enableInstantApps,
    this.closeButton,
    this.animation,
    this.extraCustomTabs,
    this.headers,
    this.bottomSheetConfiguration,
  });

  const CustomTabsOptions.bottomSheet({
    required CustomTabsBottomSheetConfiguration configuration,
    CustomTabsColorSchemes? colorSchemes,
    CustomTabsShareState? shareState,
    bool? showPageTitle,
    CustomTabsCloseButton? closeButton,
    List<String>? extraCustomTabs,
    Map<String, String>? headers,
  }) : this(
          colorSchemes: colorSchemes,
          shareState: shareState,
          showPageTitle: showPageTitle,
          closeButton: closeButton,
          extraCustomTabs: extraCustomTabs,
          headers: headers,
          bottomSheetConfiguration: configuration,
        );

  /// The visualization configuration.
  final CustomTabsColorSchemes? colorSchemes;

  /// If enabled, hides the toolbar when the user scrolls down the page.
  final bool? urlBarHidingEnabled;

  /// If enabled, default sharing menu is added.
  final CustomTabsShareState? shareState;

  /// Show web page title in tool bar.
  final bool? showPageTitle;

  /// If enabled, allow custom tab to use [Instant Apps](https://developer.android.com/topic/instant-apps/index.html).
  final bool? enableInstantApps;

  /// The close button configuration.
  final CustomTabsCloseButton? closeButton;

  ///  Enter and exit animation.
  final CustomTabsAnimation? animation;

  ///  Package list of non-Chrome browsers supporting Custom Tabs. The top of the list is used with the highest priority.
  final List<String>? extraCustomTabs;

  /// Request Headers.
  final Map<String, String>? headers;

  /// The bottom sheet configuration.
  final CustomTabsBottomSheetConfiguration? bottomSheetConfiguration;

  /// Converts the [CustomTabsOptions] instance into a [Map] instance for serialization.
  Map<String, dynamic> toMap() {
    final dest = <String, dynamic>{};
    if (colorSchemes != null) {
      dest['colorSchemes'] = colorSchemes!.toMap();
    }
    if (urlBarHidingEnabled != null) {
      dest['urlBarHidingEnabled'] = urlBarHidingEnabled;
    }
    if (shareState != null) {
      dest['shareState'] = shareState!.rawValue;
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
    if (closeButton != null) {
      if (closeButton!.icon != null) {
        dest['closeButtonIcon'] = closeButton!.icon;
      }
      if (closeButton!.position != null) {
        dest['closeButtonPosition'] = closeButton!.position!.rawValue;
      }
    }
    if (extraCustomTabs != null) {
      dest['extraCustomTabs'] = extraCustomTabs;
    }
    if (headers != null) {
      dest['headers'] = headers;
    }
    if (bottomSheetConfiguration != null) {
      dest['bottomSheet'] = bottomSheetConfiguration!.toMap();
    }
    return dest;
  }
}

/// Configuration of a custom tab visualization.
@immutable
class CustomTabsColorSchemes {
  const CustomTabsColorSchemes({
    this.colorScheme,
    this.lightParams,
    this.darkParams,
    this.defaultPrams,
  });

  CustomTabsColorSchemes.theme({
    Color? toolbarColor,
    Color? navigationBarColor,
    Color? navigationBarDividerColor,
    CustomTabsColorScheme? colorScheme,
  }) : this(
          colorScheme: colorScheme,
          defaultPrams: CustomTabsColorSchemeParams(
            toolbarColor: toolbarColor,
            navigationBarColor: navigationBarColor,
            navigationBarDividerColor: navigationBarDividerColor,
          ),
        );

  ///  Desired color scheme.
  final CustomTabsColorScheme? colorScheme;

  /// The [CustomTabsColorSchemeParams] for the light color scheme.
  final CustomTabsColorSchemeParams? lightParams;

  /// The [CustomTabsColorSchemeParams] for the dark color scheme.
  final CustomTabsColorSchemeParams? darkParams;

  /// The default [CustomTabsColorSchemeParams].
  ///
  /// If there is no [CustomTabsColorSchemeParams] for the current scheme,
  /// or a particular field of it is null, Custom Tabs will fall back to the defaults provided via [defaultPrams].
  final CustomTabsColorSchemeParams? defaultPrams;

  @internal
  Map<String, dynamic> toMap() {
    final dest = <String, dynamic>{};
    if (colorScheme != null) {
      dest['colorScheme'] = colorScheme!.rawValue;
    }
    if (lightParams != null) {
      dest['lightColorSchemeParams'] = lightParams!.toMap();
    }
    if (darkParams != null) {
      dest['darkColorSchemeParams'] = darkParams!.toMap();
    }
    if (defaultPrams != null) {
      dest['defaultColorSchemeParams'] = defaultPrams!.toMap();
    }
    return dest;
  }
}

/// Desired color scheme on a custom tab.
enum CustomTabsColorScheme {
  /// Applies either a light or dark color scheme to the user interface in the custom tab depending on the user's system settings.
  system(0),

  /// Applies a light color scheme to the user interface in the custom tab.
  light(1),

  /// Applies a dark color scheme to the user interface in the custom tab.
  dark(2);

  @internal
  const CustomTabsColorScheme(this.rawValue);

  @internal
  final int rawValue;
}

/// Contains visual parameters of a custom tab that may depend on the color scheme.
///
/// See also:
/// - [CustomTabColorSchemeParams](https://developer.android.com/reference/androidx/browser/customtabs/CustomTabColorSchemeParams)
@immutable
class CustomTabsColorSchemeParams {
  const CustomTabsColorSchemeParams({
    this.toolbarColor,
    this.navigationBarColor,
    this.navigationBarDividerColor,
  });

  /// Toolbar color.
  final Color? toolbarColor;

  /// Navigation bar color.
  final Color? navigationBarColor;

  /// Navigation bar divider color.
  final Color? navigationBarDividerColor;

  @internal
  Map<String, String> toMap() {
    final dest = <String, String>{};
    if (toolbarColor != null) {
      dest['toolbarColor'] = '#${toolbarColor!.value.toRadixString(16)}';
    }
    if (navigationBarColor != null) {
      dest['navigationBarColor'] =
          '#${navigationBarColor!.value.toRadixString(16)}';
    }
    if (navigationBarDividerColor != null) {
      dest['navigationBarDividerColor'] =
          '#${navigationBarDividerColor!.value.toRadixString(16)}';
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

/// The configuration for close button on the custom tab.
@immutable
class CustomTabsCloseButton {
  const CustomTabsCloseButton({
    this.icon,
    this.position,
  });

  /// Resource identifier of the close button icon for the custom tab.
  final String? icon;

  /// The position of the close button on the custom tab.
  final CustomTabsCloseButtonPosition? position;
}

/// The position of the close button on the custom tab.
enum CustomTabsCloseButtonPosition {
  /// Positions the close button at the start of the toolbar.
  start(1),

  /// Positions the close button at the end of the toolbar.
  end(2);

  @internal
  const CustomTabsCloseButtonPosition(this.rawValue);

  @internal
  final int rawValue;
}

/// The share state that should be applied to the custom tab.
enum CustomTabsShareState {
  /// Applies the default share settings depending on the browser.
  browserDefault(0),

  /// Explicitly does not show a share option in the tab.
  on(1),

  /// Shows a share option in the tab.
  off(2);

  @internal
  const CustomTabsShareState(this.rawValue);

  @internal
  final int rawValue;
}

/// The configuration to show custom tab as a bottom sheet.
@immutable
class CustomTabsBottomSheetConfiguration {
  const CustomTabsBottomSheetConfiguration({
    required this.initialHeight,
    this.activityHeightResizeBehavior =
        CustomTabsActivityHeightResizeBehavior.defaultBehavior,
    this.cornerRadius,
  });

  /// The Custom Tab Activity's initial height.
  ///
  /// *The minimum partial custom tab height is 50% of the screen height.
  final double initialHeight;

  /// The Custom Tab Activity's desired resize behavior.
  final CustomTabsActivityHeightResizeBehavior activityHeightResizeBehavior;

  /// The toolbar's top corner radius.
  ///
  /// *The maximum corner radius is 16dp(lp).
  final int? cornerRadius;

  @internal
  Map<String, dynamic> toMap() {
    final dest = <String, dynamic>{
      'initialHeightDp': initialHeight,
      'activityHeightResizeBehavior': activityHeightResizeBehavior.rawValue,
    };
    if (cornerRadius != null) {
      dest['cornerRadiusDp'] = min(cornerRadius!, 16);
    }
    return dest;
  }
}

/// Desired height behavior for the custom tab.
enum CustomTabsActivityHeightResizeBehavior {
  /// Applies the default height resize behavior for the Custom Tab Activity when it behaves as a bottom sheet.
  defaultBehavior(0),

  /// The Custom Tab Activity, when it behaves as a bottom sheet, can have its height manually resized by the user.
  adjustable(1),

  /// The Custom Tab Activity, when it behaves as a bottom sheet, cannot have its height manually resized by the user.
  fixed(2);

  const CustomTabsActivityHeightResizeBehavior(this.rawValue);

  @internal
  final int rawValue;
}
