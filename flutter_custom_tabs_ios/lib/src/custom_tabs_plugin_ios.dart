import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

import 'types/safari_view_controller_options.dart';

/// The iOS implementation of [CustomTabsPlatform].
///
/// This class implements the `package:flutter_custom_tabs` functionality for iOS.
class CustomTabsPluginIOS extends CustomTabsPlatform {
  static const MethodChannel _channel =
      MethodChannel('plugins.flutter.droibit.github.io/custom_tabs');

  /// Registers this class as the default instance of [CustomTabsPlatform].
  static void registerWith() {
    CustomTabsPlatform.instance = CustomTabsPluginIOS();
  }

  @override
  Future<void> launch(
    String urlString, {
    bool prefersDeepLink = false,
    PlatformOptions? customTabsOptions,
    PlatformOptions? safariVCOptions,
  }) {
    final options = (safariVCOptions is SafariViewControllerOptions)
        ? safariVCOptions
        : const SafariViewControllerOptions();
    final args = <String, dynamic>{
      'url': urlString,
      'prefersDeepLink': prefersDeepLink,
      'safariVCOptions': options.toMap(),
    };
    return _channel.invokeMethod('launch', args);
  }

  @override
  Future<void> closeAllIfPossible() async {
    return _channel.invokeMethod('closeAllIfPossible');
  }
}
