import 'dart:async';

import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

/// The web implementation of [CustomTabsPlatform].
///
/// This class implements the `package:flutter_custom_tabs` functionality for the web.
class CustomTabsPlugin extends CustomTabsPlatform {
  /// Registers this class as the default instance of [CustomTabsPlatform].
  static void registerWith(Registrar registrar) {
    CustomTabsPlatform.instance = CustomTabsPlugin();
  }

  @override
  Future<void> launch(
    String urlString, {
    CustomTabsOptions? customTabsOptions,
    SafariViewControllerOptions? safariVCOptions,
  }) {
    final plugin = UrlLauncherPlatform.instance as UrlLauncherPlugin;
    return plugin.launch(urlString).then((_) => null);
  }

  @override
  Future<void> closeAllIfPossible() async {}
}
