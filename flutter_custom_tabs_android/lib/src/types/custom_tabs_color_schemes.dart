import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';

/// The configuration of a custom tab visualization.
@immutable
class CustomTabsColorSchemes {
  const CustomTabsColorSchemes({
    this.colorScheme,
    this.lightParams,
    this.darkParams,
    this.defaultPrams,
  });

  CustomTabsColorSchemes.defaults({
    CustomTabsColorScheme? colorScheme,
    Color? toolbarColor,
    Color? navigationBarColor,
    Color? navigationBarDividerColor,
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

extension BrightnessToColorScheme on Brightness {
  /// Converts the [Brightness] enum to the corresponding [CustomTabsColorScheme].
  CustomTabsColorScheme toColorScheme() {
    switch (this) {
      case Brightness.dark:
        return CustomTabsColorScheme.dark;
      case Brightness.light:
        return CustomTabsColorScheme.light;
    }
  }
}
