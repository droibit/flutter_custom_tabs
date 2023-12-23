import 'dart:math';

import 'messages.g.dart';
import '../types/types.dart';

extension CustomTabsOptionsConverter on CustomTabsOptions {
  CustomTabsIntentOptions toMessage() {
    return CustomTabsIntentOptions(
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
  Animations toMessage() {
    final message = Animations();
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
  BrowserConfiguration toMessage() {
    return BrowserConfiguration(
      prefersExternalBrowser: prefersExternalBrowser,
      prefersDefaultBrowser: prefersDefaultBrowser,
      fallbackCustomTabs: fallbackCustomTabs,
      headers: headers,
    );
  }
}

extension CustomTabsCloseButtonConverter on CustomTabsCloseButton {
  CloseButton toMessage() {
    return CloseButton(
      icon: icon,
      position: position?.rawValue,
    );
  }
}

extension CustomTabsColorSchemesConverter on CustomTabsColorSchemes {
  ColorSchemes toMessage() {
    return ColorSchemes(
      colorScheme: colorScheme?.rawValue,
      lightParams: lightParams?.toMessage(),
      darkParams: darkParams?.toMessage(),
      defaultPrams: defaultPrams?.toMessage(),
    );
  }
}

extension CustomTabsColorSchemeParamsConverter on CustomTabsColorSchemeParams {
  ColorSchemeParams toMessage() {
    return ColorSchemeParams(
      toolbarColor: toolbarColor?.value,
      navigationBarColor: navigationBarColor?.value,
      navigationBarDividerColor: navigationBarDividerColor?.value,
    );
  }
}

extension PartialCustomTabsConfigurationConverter
    on PartialCustomTabsConfiguration {
  PartialConfiguration toMessage() {
    final message = PartialConfiguration(
      initialHeight: initialHeight,
      activityHeightResizeBehavior: activityHeightResizeBehavior.rawValue,
    );
    if (cornerRadius != null) {
      message.cornerRadius = min(cornerRadius!, 16);
    }
    return message;
  }
}
