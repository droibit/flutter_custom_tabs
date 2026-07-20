import 'dart:math';

import 'package:flutter/painting.dart';

import '../types/types.dart';

extension CustomTabsOptionsConverter on CustomTabsOptions {
  Map<String, Object> toMessage() {
    return {
      'colorSchemes': ?colorSchemes?.toMessage(),
      'urlBarHidingEnabled': ?urlBarHidingEnabled,
      'shareState': ?shareState?.rawValue,
      'showTitle': ?showTitle,
      'instantAppsEnabled': ?instantAppsEnabled,
      'bookmarksButtonEnabled': ?bookmarksButtonEnabled,
      'downloadButtonEnabled': ?downloadButtonEnabled,
      'shareIdentityEnabled': ?shareIdentityEnabled,
      'closeButton': ?closeButton?.toMessage(),
      'animations': ?animations?.toMessage(),
      'browser': ?browser?.toMessage(),
      'partial': ?partial?.toMessage(),
    };
  }
}

extension CustomTabsAnimationsConverter on CustomTabsAnimations {
  Map<String, String> toMessage() {
    return {
      'startEnter': ?startEnter,
      'startExit': ?startExit,
      'endEnter': ?endEnter,
      'endExit': ?endExit,
    };
  }
}

extension CustomTabsBrowserConfigurationConverter
    on CustomTabsBrowserConfiguration {
  Map<String, Object> toMessage() {
    return {
      'prefersExternalBrowser': ?prefersExternalBrowser,
      'prefersDefaultBrowser': ?prefersDefaultBrowser,
      'fallbackCustomTabs': ?fallbackCustomTabs,
      'headers': ?headers,
      'sessionPackageName': ?sessionPackageName,
    };
  }
}

extension CustomTabsCloseButtonConverter on CustomTabsCloseButton {
  Map<String, Object> toMessage() {
    return {'icon': ?icon, 'position': ?position?.rawValue};
  }
}

extension CustomTabsColorSchemesConverter on CustomTabsColorSchemes {
  Map<String, Object> toMessage() {
    return {
      'colorScheme': ?colorScheme?.rawValue,
      'lightParams': ?lightParams?.toMessage(),
      'darkParams': ?darkParams?.toMessage(),
      'defaultParams': ?defaultPrams?.toMessage(),
    };
  }
}

extension CustomTabsColorSchemeParamsConverter on CustomTabsColorSchemeParams {
  Map<String, String> toMessage() {
    return {
      'toolbarColor': ?toolbarColor?.toHexColorString(),
      'navigationBarColor': ?navigationBarColor?.toHexColorString(),
      'navigationBarDividerColor': ?navigationBarDividerColor
          ?.toHexColorString(),
    };
  }
}

extension PartialCustomTabsConfigurationConverter
    on PartialCustomTabsConfiguration {
  Map<String, Object> toMessage() {
    return {
      'initialHeight': ?initialHeight,
      'activityHeightResizeBehavior': ?activityHeightResizeBehavior?.rawValue,
      'initialWidth': ?initialWidth,
      'activitySideSheetBreakpoint': ?activitySideSheetBreakpoint,
      'activitySideSheetMaximizationEnabled':
          ?activitySideSheetMaximizationEnabled,
      'activitySideSheetPosition': ?activitySideSheetPosition?.rawValue,
      'activitySideSheetDecorationType':
          ?activitySideSheetDecorationType?.rawValue,
      'activitySideSheetRoundedCornersPosition':
          ?activitySideSheetRoundedCornersPosition?.rawValue,
      if (cornerRadius != null) 'cornerRadius': min(cornerRadius!, 16),
      'backgroundInteractionEnabled': ?backgroundInteractionEnabled,
    };
  }
}

extension CustomTabsSessionOptionsConverter on CustomTabsSessionOptions {
  Map<String, Object> toMessage() {
    return {
      'prefersDefaultBrowser': ?prefersDefaultBrowser,
      'fallbackCustomTabs': ?fallbackCustomTabs,
    };
  }
}

extension _StringColorConverter on Color {
  String toHexColorString() {
    return '#${toARGB32().toRadixString(16)}';
  }
}
