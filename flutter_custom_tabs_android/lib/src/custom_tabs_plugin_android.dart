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
  Future<void> closeAllIfPossible() async {
    return _hostApi.closeAllIfPossible();
  }
}
