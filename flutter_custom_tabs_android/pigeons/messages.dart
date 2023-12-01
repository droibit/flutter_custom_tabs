import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  javaOut:
      'android/src/main/java/com/github/droibit/flutter/plugins/customtabs/Messages.java',
  javaOptions: JavaOptions(
    className: 'Messages',
    package: 'com.github.droibit.flutter.plugins.customtabs',
  ),
  dartOut: 'lib/src/messages.g.dart',
))
@HostApi()
abstract class CustomTabsApi {
  void launch(
    String urlString, {
    required bool prefersDeepLink,
    CustomTabsOptionsMessage? options,
  });

  void closeAllIfPossible();
}

class CustomTabsOptionsMessage {
  const CustomTabsOptionsMessage({
    this.colorSchemes,
    this.urlBarHidingEnabled,
    this.shareState,
    this.showTitle,
    this.instantAppsEnabled,
    this.closeButton,
    this.animations,
    this.browser,
    this.partial,
  });

  final CustomTabsColorSchemesMessage? colorSchemes;
  final bool? urlBarHidingEnabled;
  final int? shareState;
  final bool? showTitle;
  final bool? instantAppsEnabled;
  final CustomTabsCloseButtonMessage? closeButton;
  final CustomTabsAnimationsMessage? animations;
  final CustomTabsBrowserConfigurationMessage? browser;
  final PartialCustomTabsConfigurationMessage? partial;
}

class CustomTabsAnimationsMessage {
  const CustomTabsAnimationsMessage({
    this.startEnter,
    this.startExit,
    this.endEnter,
    this.endExit,
  });

  final String? startEnter;
  final String? startExit;
  final String? endEnter;
  final String? endExit;
}

class CustomTabsBrowserConfigurationMessage {
  const CustomTabsBrowserConfigurationMessage({
    required this.prefersExternalBrowser,
    this.prefersDefaultBrowser,
    this.fallbackCustomTabs,
    this.headers,
  });

  final bool prefersExternalBrowser;
  final bool? prefersDefaultBrowser;
  final List<String?>? fallbackCustomTabs;
  final Map<String?, String?>? headers;
}

class CustomTabsCloseButtonMessage {
  const CustomTabsCloseButtonMessage({
    this.icon,
    this.position,
  });

  final String? icon;
  final int? position;
}

class CustomTabsColorSchemesMessage {
  const CustomTabsColorSchemesMessage({
    this.colorScheme,
    this.lightParams,
    this.darkParams,
    this.defaultPrams,
  });

  final int? colorScheme;
  final CustomTabsColorSchemeParamsMessage? lightParams;
  final CustomTabsColorSchemeParamsMessage? darkParams;
  final CustomTabsColorSchemeParamsMessage? defaultPrams;
}

class CustomTabsColorSchemeParamsMessage {
  const CustomTabsColorSchemeParamsMessage({
    this.toolbarColor,
    this.navigationBarColor,
    this.navigationBarDividerColor,
  });

  final String? toolbarColor;
  final String? navigationBarColor;
  final String? navigationBarDividerColor;
}

class PartialCustomTabsConfigurationMessage {
  const PartialCustomTabsConfigurationMessage({
    required this.initialHeight,
    required this.activityHeightResizeBehavior,
    this.cornerRadius,
  });

  final double initialHeight;
  final int activityHeightResizeBehavior;
  final int? cornerRadius;
}
