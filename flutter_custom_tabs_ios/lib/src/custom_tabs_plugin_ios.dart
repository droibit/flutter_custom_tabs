import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

import 'message_converters.dart';
import 'messages.g.dart';
import 'types/safari_view_controller_options.dart';

/// The iOS implementation of [CustomTabsPlatform].
///
/// This class implements the `package:flutter_custom_tabs` functionality for iOS.
class CustomTabsPluginIOS extends CustomTabsPlatform {
  /// Creates a new plugin implementation instance.
  CustomTabsPluginIOS({
    CustomTabsApi? api,
  }) : _hostApi = api ?? CustomTabsApi();

  final CustomTabsApi _hostApi;

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
        ? safariVCOptions.toMessage()
        : SafariViewControllerOptionsMessage();
    return _hostApi.launchUrl(
      urlString,
      prefersDeepLink: prefersDeepLink,
      options: options,
    );
  }

  @override
  Future<void> closeAllIfPossible() async {
    return _hostApi.closeAllIfPossible();
  }
}
