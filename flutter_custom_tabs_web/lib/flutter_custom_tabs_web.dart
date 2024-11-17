import 'dart:async';

import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

/// The web implementation of [CustomTabsPlatform].
///
/// This class implements the `package:flutter_custom_tabs` functionality for the web.
class CustomTabsPluginWeb extends CustomTabsPlatform {
  /// Registers this class as the default instance of [CustomTabsPlatform].
  static void registerWith(Registrar registrar) {
    CustomTabsPlatform.instance = CustomTabsPluginWeb();
  }

  @override
  Future<void> launch(
    String urlString, {
    bool prefersDeepLink = false,
    PlatformOptions? customTabsOptions,
    PlatformOptions? safariVCOptions,
  }) {
    final plugin = UrlLauncherPlatform.instance as UrlLauncherPlugin;
    return plugin.launch(urlString).then((_) => null);
  }

  @override
  Future<void> closeAllIfPossible() async {
    // No-op on web.
  }

  @override
  Future<PlatformSession?> warmup([PlatformOptions? options]) async {
    // No-op on web.
    return null;
  }

  @override
  Future<PlatformSession?> mayLaunch(
    List<String> urls, {
    PlatformSession? session,
  }) async {
    // No-op on web.
    return null;
  }

  @override
  Future<void> invalidate(PlatformSession session) async {
    // No-op on web.
  }
}
