import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../flutter_custom_tabs_platform_interface.dart';

/// An implementation of [CustomTabsPlatform] that uses method channels.
@internal
class MethodChannelCustomTabs extends CustomTabsPlatform {
  static const MethodChannel _channel =
      MethodChannel('plugins.flutter.droibit.github.io/custom_tabs');

  @override
  Future<void> launch(
    String urlString, {
    CustomTabsOptions? customTabsOptions,
    SafariViewControllerOptions? safariVCOptions,
  }) {
    final args = <String, dynamic>{
      'url': urlString,
      'customTabsOptions': customTabsOptions?.toMap() ?? <String, dynamic>{},
      'safariVCOptions': safariVCOptions?.toMap() ?? <String, dynamic>{}
    };
    return _channel.invokeMethod('launch', args);
  }

  @override
  Future<void> closeAllIfPossible() {
    return _channel.invokeMethod('closeAllIfPossible');
  }
}
