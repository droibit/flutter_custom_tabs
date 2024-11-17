import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

import 'messages/messages.dart';
import 'types/types.dart';

/// The Android implementation of [CustomTabsPlatform].
///
/// This class implements the `package:flutter_custom_tabs` functionality for Android.
class CustomTabsPluginAndroid extends CustomTabsPlatform {
  /// Creates a new plugin implementation instance.
  CustomTabsPluginAndroid({
    CustomTabsApi? api,
  }) : _hostApi = api ?? CustomTabsApi();

  final CustomTabsApi _hostApi;

  /// Registers this class as the default instance of [CustomTabsPlatform].
  static void registerWith() {
    CustomTabsPlatform.instance = CustomTabsPluginAndroid();
  }

  @override
  Future<void> launch(
    String urlString, {
    bool prefersDeepLink = false,
    PlatformOptions? customTabsOptions,
    PlatformOptions? safariVCOptions,
  }) {
    final Map<String, Object?>? message = switch (customTabsOptions) {
      null => null,
      (CustomTabsOptions options) => options.toMessage(),
      _ => {},
    };
    return _hostApi.launch(
      urlString,
      prefersDeepLink: prefersDeepLink,
      options: message,
    );
  }

  @override
  Future<void> closeAllIfPossible() {
    return _hostApi.closeAllIfPossible();
  }

  @override
  Future<PlatformSession?> warmup([PlatformOptions? options]) async {
    if (options != null && options is! CustomTabsSessionOptions) {
      throw ArgumentError.value(
        options,
        'options',
        'must be an instance of CustomTabsSessionOptions.',
      );
    }

    final browserOptions = options as CustomTabsSessionOptions?;
    final packageName = await _hostApi.warmup(browserOptions?.toMessage());
    return packageName == null ? null : CustomTabsSession(packageName);
  }

  @override
  Future<PlatformSession?> mayLaunch(
    List<String> urls, {
    PlatformSession? session,
  }) async {
    if (session is! CustomTabsSession) {
      throw ArgumentError.value(
        session,
        'session',
        'must be an instance of CustomTabsSession.',
      );
    }

    final packageName = session.packageName;
    if (packageName == null) {
      return null;
    }
    await _hostApi.mayLaunch(urls, packageName);
    return null;
  }

  @override
  Future<void> invalidate(PlatformSession session) async {
    if (session is! CustomTabsSession) {
      throw ArgumentError.value(
        session,
        'session',
        'must be an instance of CustomTabsSession.',
      );
    }

    final packageName = session.packageName;
    if (packageName == null) {
      return;
    }
    return _hostApi.invalidate(packageName);
  }
}
