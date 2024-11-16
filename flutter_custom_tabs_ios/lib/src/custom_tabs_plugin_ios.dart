import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

import 'messages/messages.dart';
import 'types/types.dart';

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
    final SFSafariViewControllerOptions? message;
    if (safariVCOptions == null) {
      message = null;
    } else {
      message = (safariVCOptions is SafariViewControllerOptions)
          ? safariVCOptions.toMessage()
          : SFSafariViewControllerOptions();
    }

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

  @override
  Future<PlatformSession?> warmup([PlatformOptions? options]) async {
    // No-op on iOS.
    return null;
  }

  @override
  Future<void> invalidate(PlatformSession session) async {
    if (session is! SafariViewPrewarmingSession) {
      throw ArgumentError.value(
        session,
        'session',
        'must be an instance of SafariViewPrewarmingSession.',
      );
    }

    final sessionId = session.id;
    if (sessionId == null) {
      return;
    }
    return _hostApi.invalidate(sessionId);
  }
}
