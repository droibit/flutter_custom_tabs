import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../flutter_custom_tabs_platform_interface.dart';
import 'method_channel_custom_tabs.dart';

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

  /// Open the specified Web URL with Custom Tabs or implementation by platform.
  Future<void> launch(
    String urlString, {
    CustomTabsOption? customTabsOption,
    SafariViewControllerOption? safariVCOption,
  }) {
    throw UnimplementedError('launch() has not been implemented.');
  }
}
