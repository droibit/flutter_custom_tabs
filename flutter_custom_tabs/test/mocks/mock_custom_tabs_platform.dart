import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
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
    PlatformOptions? customTabsOptions,
    PlatformOptions? safariVCOptions,
  }) async {
    expect(urlString, url);
    expect(prefersDeepLink, this.prefersDeepLink);

    if (customTabsOptions is CustomTabsOptions) {
      expect(
        customTabsOptions.urlBarHidingEnabled,
        this.customTabsOptions!.urlBarHidingEnabled,
      );
    } else {
      expect(customTabsOptions, isNull);
    }
    if (safariVCOptions is SafariViewControllerOptions) {
      expect(
        safariVCOptions.barCollapsingEnabled,
        this.safariVCOptions!.barCollapsingEnabled,
      );
    } else {
      expect(safariVCOptions, isNull);
    }
    launchUrlCalled = true;
  }

  @override
  Future<void> closeAllIfPossible() async {
    closeAllIfPossibleCalled = true;
  }
}
