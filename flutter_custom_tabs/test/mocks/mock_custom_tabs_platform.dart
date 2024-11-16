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
  PlatformOptions? sessionOptions;
  PlatformSession? session;
  bool launchUrlCalled = false;
  bool closeAllIfPossibleCalled = false;
  bool warmupCalled = false;
  bool invalidateCalled = false;  

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

  void setWarmupExpectations({
    PlatformOptions? customTabsOptions,
    PlatformSession? customTabsSession,
  }) {
    sessionOptions = customTabsOptions;
    session = customTabsSession;
  }

  void setInvalidateExpectations({
    required PlatformSession session,
  }) {
    this.session = session;
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

  @override
  Future<PlatformSession?> warmup([PlatformOptions? options]) async {
    if (options is CustomTabsSessionOptions) {
      final expected = sessionOptions as CustomTabsSessionOptions;
      expect(options.prefersDefaultBrowser, expected.prefersDefaultBrowser);
    } else {
      expect(options, isNull);
    }
    warmupCalled = true;
    return session;
  }

  @override
  Future<void> invalidate(PlatformSession session) async {
    if (session is CustomTabsSession) {
      final expected = sessionOptions as CustomTabsSession;  
      expect(session.packageName, expected.packageName);
    } else if (session is SafariViewPrewarmingSession) {
      final expected = sessionOptions as SafariViewPrewarmingSession;
      expect(session.id, expected.id);
    } else {
      expect(session, isNotNull);
    }
    invalidateCalled = true;
  }
}
