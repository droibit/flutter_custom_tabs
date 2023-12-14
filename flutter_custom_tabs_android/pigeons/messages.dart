import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  javaOut:
      'android/src/main/java/com/github/droibit/flutter/plugins/customtabs/Messages.java',
  javaOptions: JavaOptions(
    className: 'Messages',
    package: 'com.github.droibit.flutter.plugins.customtabs',
  ),
  dartOut: 'lib/src/messages/messages.g.dart',
))
@HostApi()
abstract class CustomTabsApi {
  void launch(
    String urlString, {
    required bool prefersDeepLink,
    CustomTabsIntentOptions? options,
  });

  void closeAllIfPossible();
}

class CustomTabsIntentOptions {
  const CustomTabsIntentOptions({
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

  final ColorSchemes? colorSchemes;
  final bool? urlBarHidingEnabled;
  final int? shareState;
  final bool? showTitle;
  final bool? instantAppsEnabled;
  final CloseButton? closeButton;
  final Animations? animations;
  final BrowserConfiguration? browser;
  final PartialConfiguration? partial;
}

class Animations {
  const Animations({
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

class BrowserConfiguration {
  const BrowserConfiguration({
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

class CloseButton {
  const CloseButton({
    this.icon,
    this.position,
  });

  final String? icon;
  final int? position;
}

class ColorSchemes {
  const ColorSchemes({
    this.colorScheme,
    this.lightParams,
    this.darkParams,
    this.defaultPrams,
  });

  final int? colorScheme;
  final ColorSchemeParams? lightParams;
  final ColorSchemeParams? darkParams;
  final ColorSchemeParams? defaultPrams;
}

class ColorSchemeParams {
  const ColorSchemeParams({
    this.toolbarColor,
    this.navigationBarColor,
    this.navigationBarDividerColor,
  });

  final int? toolbarColor;
  final int? navigationBarColor;
  final int? navigationBarDividerColor;
}

class PartialConfiguration {
  const PartialConfiguration({
    required this.initialHeight,
    required this.activityHeightResizeBehavior,
    this.cornerRadius,
  });

  final double initialHeight;
  final int activityHeightResizeBehavior;
  final int? cornerRadius;
}
