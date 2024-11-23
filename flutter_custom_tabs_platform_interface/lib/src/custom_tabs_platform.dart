import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_custom_tabs.dart';
import 'types.dart';

/// The interface that implementations of flutter_custom_tabs must implement.
///
/// Platform implementations should extend this class rather than implement it as `flutter_custom_tabs`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
abstract class CustomTabsPlatform extends PlatformInterface {
  /// Constructs a CustomTabsPlatform.
  CustomTabsPlatform() : super(token: _token);

  static final Object _token = Object();

  static CustomTabsPlatform _instance = MethodChannelCustomTabs();

  /// The default instance of [CustomTabsPlatform] to use.
  ///
  /// Defaults to [MethodChannelCustomTabs].
  static CustomTabsPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [CustomTabsPlatform] when they register themselves.
  static set instance(CustomTabsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Passes [url] with options to the underlying platform for launching a custom tab.
  Future<void> launch(
    String urlString, {
    bool prefersDeepLink = false,
    PlatformOptions? customTabsOptions,
    PlatformOptions? safariVCOptions,
  }) {
    throw UnimplementedError('launch() has not been implemented.');
  }

  /// Closes all custom tabs that were opened earlier by [launch].
  Future<void> closeAllIfPossible() {
    throw UnimplementedError('closeAllIfPossible() has not been implemented.');
  }

  /// On Android, Warm up the browser process.
  ///
  /// Allows the browser application to pre-initialize itself in the background.
  /// Significantly speeds up URL opening in the browser.
  Future<PlatformSession?> warmup([PlatformOptions? options]) {
    throw UnimplementedError('warmup() has not been implemented.');
  }

  /// Tells the browser of potential URLs that might be launched later,
  /// improving performance when the URL is actually launched.
  Future<PlatformSession?> mayLaunch(
    List<String> urls, {
    PlatformSession? session,
  }) {
    throw UnimplementedError('mayLaunchUrl() has not been implemented.');
  }

  /// Invalidates a session to release resources and properly dispose of it.
  Future<void> invalidate(PlatformSession session) {
    throw UnimplementedError('invalidate() has not been implemented.');
  }
}
