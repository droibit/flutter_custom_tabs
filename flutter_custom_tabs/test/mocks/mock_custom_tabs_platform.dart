import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCustomTabsPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements CustomTabsPlatform {
  String? url;
  bool? prefersDeepLink;
  CustomTabsOptions? customTabsOptions;
  SafariViewControllerOptions? safariVCOptions;

  bool launchUrlCalled = false;
  bool closeAllIfPossibleCalled = false;

  void setLaunchExpectations({
    required String url,
    bool? prefersDeepLink,
    CustomTabsOptions? customTabsOptions,
    SafariViewControllerOptions? safariVCOptions,
  }) {
    this.url = url;
    this.prefersDeepLink = prefersDeepLink;
    this.customTabsOptions = customTabsOptions;
    this.safariVCOptions = safariVCOptions;
  }

  @override
  Future<void> launch(
    String? urlString, {
    bool? prefersDeepLink,
    CustomTabsOptions? customTabsOptions,
    SafariViewControllerOptions? safariVCOptions,
  }) async {
    expect(urlString, url);
    expect(prefersDeepLink, this.prefersDeepLink);
    expect(customTabsOptions?.toMap(), this.customTabsOptions?.toMap());
    expect(safariVCOptions?.toMap(), this.safariVCOptions?.toMap());
    launchUrlCalled = true;
  }

  @override
  Future<void> closeAllIfPossible() async {
    closeAllIfPossibleCalled = true;
  }
}
