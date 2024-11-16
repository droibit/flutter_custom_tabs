import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/mock_custom_tabs_platform.dart';

void main() {
  final mock = MockCustomTabsPlatform();
  setUp(() => {CustomTabsPlatform.instance = mock});

  test('launchUrl() launch with non-web URL', () async {
    final url = Uri.parse('file:/home');
    try {
      await launchUrl(url);
      fail("failed");
    } catch (e) {
      expect(e, isA<PlatformException>());
    }
  });

  test('launchUrl() launch with null options', () async {
    final url = Uri.parse('http://example.com/');
    mock.setLaunchExpectations(
      url: url.toString(),
      prefersDeepLink: false,
    );

    try {
      await launchUrl(url);
    } catch (e) {
      fail(e.toString());
    }
  });

  test('launchUrl() launch with empty options', () async {
    final url = Uri.parse('http://example.com/');
    const customTabsOptions = CustomTabsOptions();
    const safariVCOptions = SafariViewControllerOptions();
    mock.setLaunchExpectations(
      url: url.toString(),
      prefersDeepLink: false,
      customTabsOptions: customTabsOptions,
      safariVCOptions: safariVCOptions,
    );

    try {
      await launchUrl(
        url,
        customTabsOptions: customTabsOptions,
        safariVCOptions: safariVCOptions,
      );
    } catch (e) {
      fail(e.toString());
    }
  });

  test('launchUrl() launch with options', () async {
    final url = Uri.parse('http://example.com/');
    const prefersDeepLink = true;
    const customTabsOptions = CustomTabsOptions(
      urlBarHidingEnabled: true,
    );
    const safariVCOptions = SafariViewControllerOptions(
      barCollapsingEnabled: true,
    );
    mock.setLaunchExpectations(
      url: url.toString(),
      prefersDeepLink: prefersDeepLink,
      customTabsOptions: customTabsOptions,
      safariVCOptions: safariVCOptions,
    );

    try {
      await launchUrl(
        url,
        prefersDeepLink: prefersDeepLink,
        customTabsOptions: customTabsOptions,
        safariVCOptions: safariVCOptions,
      );
    } catch (e) {
      fail(e.toString());
    }
  });

  test('closeCustomTabs() invoke method "closeAllIfPossible"', () async {
    await closeCustomTabs();
    expect(mock.closeAllIfPossibleCalled, isTrue);
  });

  test('warmupCustomTabs() invoke method "warmup" with options', () async {
    const options = CustomTabsSessionOptions(
      prefersDefaultBrowser: true,
    );
    const sessionPackageName = 'com.example.browser';
    mock.setWarmupExpectations(
      customTabsOptions: options,
      customTabsSession: const CustomTabsSession(sessionPackageName),
    );

    final actualSession = await warmupCustomTabs(options: options);
    expect(actualSession.packageName, sessionPackageName);
    expect(mock.warmupCalled, isTrue);
  });

  test('warmupCustomTabs() invoke method "warmup" with no options', () async {
    const sessionPackageName = 'com.example.browser';
    mock.setWarmupExpectations(
      customTabsSession: const CustomTabsSession(sessionPackageName),
    );

    final actualSession = await warmupCustomTabs();
    expect(actualSession.packageName, sessionPackageName);
    expect(mock.warmupCalled, isTrue);
  });

  test(
      'warmupCustomTabs() returns empty CustomTabsSession when session is null',
      () async {
    mock.setWarmupExpectations(
      customTabsSession: null,
    );

    final actualSession = await warmupCustomTabs();
    expect(actualSession.packageName, isNull);
    expect(mock.warmupCalled, isTrue);
  });

  test('invalidateSession() invoke method "invalidate" with CustomTabsSession',
      () async {
    const session = CustomTabsSession('com.example.browser');
    mock.setInvalidateExpectations(session: session);

    await invalidateSession(session);
    expect(mock.invalidateCalled, isTrue);
  });

  test(
      'invalidateSession() invoke method "invalidate" with SafariViewPrewarmingSession',
      () async {
    const session = SafariViewPrewarmingSession('test');
    mock.setInvalidateExpectations(session: session);

    await invalidateSession(session);
    expect(mock.invalidateCalled, isTrue);
  });

  test(
      'invalidateSession() invoke method "invalidate" with non-PlatformSession implementation',
      () async {
    const session = _Session();
    mock.setInvalidateExpectations(session: session);

    await invalidateSession(session);
    expect(mock.invalidateCalled, isTrue);
  });
}

class _Session implements PlatformSession {
  const _Session();
}
