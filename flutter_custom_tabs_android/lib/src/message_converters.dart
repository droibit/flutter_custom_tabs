import 'dart:math';

import 'package:flutter/painting.dart';

import 'types/types.dart';
import 'messages.g.dart';

extension CustomTabsOptionsConverter on CustomTabsOptions {
  CustomTabsOptionsMessage toMessage() {
    return CustomTabsOptionsMessage(
      colorSchemes: colorSchemes?.toMessage(),
      urlBarHidingEnabled: urlBarHidingEnabled,
      shareState: shareState?.rawValue,
      showTitle: showTitle,
      instantAppsEnabled: instantAppsEnabled,
      closeButton: closeButton?.toMessage(),
      animations: animations?.toMessage(),
      browser: browser?.toMessage(),
      partial: partial?.toMessage(),
    );
  }
}

extension CustomTabsAnimationsConverter on CustomTabsAnimations {
  CustomTabsAnimationsMessage toMessage() {
    final message = CustomTabsAnimationsMessage();
    if (startEnter != null && startExit != null) {
      message.startEnter = startEnter;
      message.startExit = startExit;
    }
    if (endEnter != null && endExit != null) {
      message.endEnter = endEnter;
      message.endExit = endExit;
    }
    return message;
  }
}

extension CustomTabsBrowserConfigurationConverter
    on CustomTabsBrowserConfiguration {
  CustomTabsBrowserConfigurationMessage toMessage() {
    return CustomTabsBrowserConfigurationMessage(
      prefersExternalBrowser: prefersExternalBrowser,
      prefersDefaultBrowser: prefersDefaultBrowser,
      fallbackCustomTabs: fallbackCustomTabs,
      headers: headers,
    );
  }
}

extension CustomTabsCloseButtonConverter on CustomTabsCloseButton {
  CustomTabsCloseButtonMessage toMessage() {
    return CustomTabsCloseButtonMessage(
      icon: icon,
      position: position?.rawValue,
    );
  }
}

extension CustomTabsColorSchemesConverter on CustomTabsColorSchemes {
  CustomTabsColorSchemesMessage toMessage() {
    return CustomTabsColorSchemesMessage(
      colorScheme: colorScheme?.rawValue,
      lightParams: lightParams?.toMessage(),
      darkParams: darkParams?.toMessage(),
      defaultPrams: defaultPrams?.toMessage(),
    );
  }
}

extension CustomTabsColorSchemeParamsConverter on CustomTabsColorSchemeParams {
  CustomTabsColorSchemeParamsMessage toMessage() {
    return CustomTabsColorSchemeParamsMessage(
      toolbarColor: toolbarColor?.toHexString(),
      navigationBarColor: navigationBarColor?.toHexString(),
      navigationBarDividerColor: navigationBarDividerColor?.toHexString(),
    );
  }
}

extension PartialCustomTabsConfigurationConverter
    on PartialCustomTabsConfiguration {
  PartialCustomTabsConfigurationMessage toMessage() {
    final message = PartialCustomTabsConfigurationMessage(
      initialHeight: initialHeight,
      activityHeightResizeBehavior: activityHeightResizeBehavior.rawValue,
    );
    if (cornerRadius != null) {
      message.cornerRadius = min(cornerRadius!, 16);
    }
    return message;
  }
}

extension _StringConveter on Color {
  String toHexString() {
    return '#${value.toRadixString(16)}';
  }
}
