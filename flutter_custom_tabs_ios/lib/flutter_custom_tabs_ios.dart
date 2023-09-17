import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

/// The iOS implementation of [CustomTabsPlatform].
///
/// This class implements the `package:flutter_custom_tabs` functionality for Android.
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
    CustomTabsOptions? customTabsOptions,
    SafariViewControllerOptions? safariVCOptions,
  }) {
    final args = <String, dynamic>{
      'url': urlString,
      'safariVCOptions': safariVCOptions?.toMap() ?? <String, dynamic>{},
    };
    return _channel.invokeMethod('launch', args);
  }

  @override
  Future<void> closeAllIfPossible() async {
    return _channel.invokeMethod('closeAllIfPossible');
  }
}
