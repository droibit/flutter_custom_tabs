import 'dart:math';

import 'package:flutter/painting.dart';

import '../types/types.dart';

extension CustomTabsOptionsConverter on CustomTabsOptions {
  Map<String, Object> toMessage() {
    return {
      if (colorSchemes != null) 'colorSchemes': colorSchemes!.toMessage(),
      if (urlBarHidingEnabled != null)
        'urlBarHidingEnabled': urlBarHidingEnabled!,
      if (shareState != null) 'shareState': shareState!.rawValue,
      if (showTitle != null) 'showTitle': showTitle!,
      if (instantAppsEnabled != null) 'instantAppsEnabled': instantAppsEnabled!,
      if (animations != null) 'animations': animations!.toMessage(),
      if (closeButton != null) 'closeButton': closeButton!.toMessage(),
      if (browser != null) 'browser': browser!.toMessage(),
      if (partial != null) 'partial': partial!.toMessage(),
    };
  }
}

extension CustomTabsAnimationsConverter on CustomTabsAnimations {
  Map<String, String> toMessage() {
    return {
      if (startEnter != null) 'startEnter': startEnter!,
      if (startExit != null) 'startExit': startExit!,
      if (endEnter != null) 'endEnter': endEnter!,
      if (endExit != null) 'endExit': endExit!,
    };
  }
}

extension CustomTabsBrowserConfigurationConverter
    on CustomTabsBrowserConfiguration {
  Map<String, Object> toMessage() {
    return {
      if (prefersExternalBrowser != null)
        'prefersExternalBrowser': prefersExternalBrowser!,
      if (prefersDefaultBrowser != null)
        'prefersDefaultBrowser': prefersDefaultBrowser!,
      if (fallbackCustomTabs != null) 'fallbackCustomTabs': fallbackCustomTabs!,
      if (headers != null) 'headers': headers!,
    };
  }
}

extension CustomTabsCloseButtonConverter on CustomTabsCloseButton {
  Map<String, Object> toMessage() {
    return {
      if (icon != null) 'icon': icon!,
      if (position != null) 'position': position!.rawValue,
    };
  }
}

extension CustomTabsColorSchemesConverter on CustomTabsColorSchemes {
  Map<String, Object> toMessage() {
    return {
      if (colorScheme != null) 'colorScheme': colorScheme!.rawValue,
      if (lightParams != null) 'lightParams': lightParams!.toMessage(),
      if (darkParams != null) 'darkParams': darkParams!.toMessage(),
      if (defaultPrams != null) 'defaultParams': defaultPrams!.toMessage()
    };
  }
}

extension CustomTabsColorSchemeParamsConverter on CustomTabsColorSchemeParams {
  Map<String, String> toMessage() {
    return {
      if (toolbarColor != null)
        'toolbarColor': toolbarColor!.toHexColorString(),
      if (navigationBarColor != null)
        'navigationBarColor': navigationBarColor!.toHexColorString(),
      if (navigationBarDividerColor != null)
        'navigationBarDividerColor':
            navigationBarDividerColor!.toHexColorString(),
    };
  }
}

extension PartialCustomTabsConfigurationConverter
    on PartialCustomTabsConfiguration {
  Map<String, Object> toMessage() {
    return {
      'initialHeight': initialHeight,
      if (activityHeightResizeBehavior != null)
        'activityHeightResizeBehavior': activityHeightResizeBehavior!.rawValue,
      if (cornerRadius != null) 'cornerRadius': min(cornerRadius!, 16)
    };
  }
}

extension _StringColorConverter on Color {
  String toHexColorString() {
    return '#${value.toRadixString(16)}';
  }
}
