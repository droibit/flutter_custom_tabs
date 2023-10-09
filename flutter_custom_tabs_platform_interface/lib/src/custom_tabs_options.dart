import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';

/// The Configuration for providing comprehensive options
/// when launching [Custom Tabs](https://developer.chrome.com/docs/android/custom-tabs/) by specifying a URL.
///
/// See also:
///
/// - [CustomTabsIntent.Builder](https://developer.android.com/reference/androidx/browser/customtabs/CustomTabsIntent.Builder)
///
@immutable
class CustomTabsOptions {
  /// Creates a [CustomTabsOptions] instance with the specified options.
  const CustomTabsOptions({
    this.colorSchemes,
    this.urlBarHidingEnabled,
    this.shareState,
    this.showTitle,
    this.instantAppsEnabled,
    this.closeButton,
    this.animations,
    this.extraCustomTabs,
    this.headers,
    this.partialConfiguration,
  });

  /// Creates a [CustomTabsOptions] instance with configuration for Partial Custom Tabs.
  const CustomTabsOptions.partial({
    required PartialCustomTabsConfiguration configuration,
    CustomTabsColorSchemes? colorSchemes,
    CustomTabsShareState? shareState,
    bool? showTitle,
    CustomTabsCloseButton? closeButton,
    List<String>? extraCustomTabs,
    Map<String, String>? headers,
  }) : this(
          colorSchemes: colorSchemes,
          shareState: shareState,
          showTitle: showTitle,
          closeButton: closeButton,
          extraCustomTabs: extraCustomTabs,
          headers: headers,
          partialConfiguration: configuration,
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

  /// Package list of non-Chrome browsers supporting Custom Tabs. The top of the list is used with the highest priority.
  final List<String>? extraCustomTabs;

  /// Extra HTTP request headers.
  final Map<String, String>? headers;

  /// The configuration for Partial Custom Tabs.
  final PartialCustomTabsConfiguration? partialConfiguration;

  /// Converts the [CustomTabsOptions] instance into a [Map] instance for serialization.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (colorSchemes != null) 'colorSchemes': colorSchemes!.toMap(),
      if (urlBarHidingEnabled != null)
        'urlBarHidingEnabled': urlBarHidingEnabled,
      if (shareState != null) 'shareState': shareState!.rawValue,
      if (showTitle != null) 'showTitle': showTitle,
      if (instantAppsEnabled != null) 'instantAppsEnabled': instantAppsEnabled,
      if (animations != null) 'animations': animations!.toMap(),
      if (closeButton?.icon != null) 'closeButtonIcon': closeButton!.icon,
      if (closeButton?.position != null)
        'closeButtonPosition': closeButton!.position!.rawValue,
      if (extraCustomTabs != null) 'extraCustomTabs': extraCustomTabs,
      if (headers != null) 'headers': headers,
      if (partialConfiguration != null)
        'partial': partialConfiguration!.toMap(),
    };
  }
}

/// The configuration of a custom tab visualization.
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

  /// Desired color scheme.
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
    return <String, dynamic>{
      if (colorScheme != null) 'colorScheme': colorScheme!.rawValue,
      if (lightParams != null) 'lightColorSchemeParams': lightParams!.toMap(),
      if (darkParams != null) 'darkColorSchemeParams': darkParams!.toMap(),
      if (defaultPrams != null)
        'defaultColorSchemeParams': defaultPrams!.toMap()
    };
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
///
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
    return <String, String>{
      if (toolbarColor != null)
        'toolbarColor': '#${toolbarColor!.value.toRadixString(16)}',
      if (navigationBarColor != null)
        'navigationBarColor': '#${navigationBarColor!.value.toRadixString(16)}',
      if (navigationBarDividerColor != null)
        'navigationBarDividerColor':
            '#${navigationBarDividerColor!.value.toRadixString(16)}',
    };
  }
}

/// The enter and exit animations for the custom tab.
///
/// Specify the Resource ID according to the specifications for the Android platform.
/// - For resources within the Android app, use the resource name.
///   - e.g. `slide_up`
/// - For other cases, provide the complete Resource ID with the type 'anim'.
///   - e.g. `android:anim/fade_in`
///
/// See also:
///
/// - [View animation](https://developer.android.com/guide/topics/resources/animation-resource.html#View)
/// - [getIdentifier](https://developer.android.com/reference/android/content/res/Resources.html#getIdentifier(java.lang.String,%20java.lang.String,%20java.lang.String))
///
@immutable
class CustomTabsAnimations {
  const CustomTabsAnimations({
    this.startEnter,
    this.startExit,
    this.endEnter,
    this.endExit,
  });

  /// Resource ID of the start "enter" animation for the custom tab.
  final String? startEnter;

  /// Resource ID of the start "exit" animation for the application.
  final String? startExit;

  /// Resource ID of the exit "enter" animation for the application.
  final String? endEnter;

  /// Resource ID of the exit "exit" animation for the custom tab.
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

/// The configuration for [Partial Custom Tabs](https://developer.chrome.com/docs/android/custom-tabs/guide-partial-custom-tabs/).
@immutable
class PartialCustomTabsConfiguration {
  const PartialCustomTabsConfiguration({
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
      if (cornerRadius != null) 'cornerRadiusDp': min(cornerRadius!, 16)
    };
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

  @internal
  const CustomTabsActivityHeightResizeBehavior(this.rawValue);

  @internal
  final int rawValue;
}
