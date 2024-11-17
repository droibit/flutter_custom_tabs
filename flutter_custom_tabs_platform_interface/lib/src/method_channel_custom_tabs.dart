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
    bool prefersDeepLink = false,
    PlatformOptions? customTabsOptions,
    PlatformOptions? safariVCOptions,
  }) {
    final args = <String, dynamic>{
      'url': urlString,
      'prefersDeepLink': prefersDeepLink,
      'customTabsOptions': <String, dynamic>{},
      'safariVCOptions': <String, dynamic>{},
    };
    return _channel.invokeMethod('launch', args);
  }

  @override
  Future<void> closeAllIfPossible() {
    return _channel.invokeMethod('closeAllIfPossible');
  }

  @override
  Future<PlatformSession?> warmup([PlatformOptions? options]) {
    return _channel.invokeMethod('warmup', <String, dynamic>{});
  }

  @override
  Future<PlatformSession?> mayLaunch(
    List<String> urls, {
    PlatformSession? session,
  }) {
    return _channel.invokeMethod('mayLaunch', <String, dynamic>{
      'urls': urls,
      'session': null,
    });
  }

  @override
  Future<void> invalidate(PlatformSession session) {
    return _channel.invokeMethod('invalidate', <String, dynamic>{});
  }
}
