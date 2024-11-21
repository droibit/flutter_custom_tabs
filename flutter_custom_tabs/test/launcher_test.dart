import 'package:flutter/foundation.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/mock_custom_tabs_platform.dart';

void main() {
  final mock = MockCustomTabsPlatform();
  setUp(() => {CustomTabsPlatform.instance = mock});

  test('launchUrl() throws ArgumentError when URL scheme is not http or https',
      () async {
    final url = Uri.parse('file:/home');
    expect(
      () => launchUrl(url),
      throwsA(isA<ArgumentError>()),
    );
    expect(mock.launchUrlCalled, isFalse);
  });

  test('launchUrl() launch with null options', () async {
    final url = Uri.parse('http://example.com/');
    mock.setLaunchExpectations(
      url: url.toString(),
      prefersDeepLink: false,
    );

    expect(
      () async => await launchUrl(url),
      returnsNormally,
    );
    expect(mock.launchUrlCalled, isTrue);
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

    expect(
      () async => await launchUrl(
        url,
        customTabsOptions: customTabsOptions,
        safariVCOptions: safariVCOptions,
      ),
      returnsNormally,
    );
    expect(mock.launchUrlCalled, isTrue);
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

    expect(
      () async => await launchUrl(
        url,
        prefersDeepLink: prefersDeepLink,
        customTabsOptions: customTabsOptions,
        safariVCOptions: safariVCOptions,
      ),
      returnsNormally,
    );
    expect(mock.launchUrlCalled, isTrue);
  });

  test('closeCustomTabs() invoke method "closeAllIfPossible"', () async {
    expect(
      () async => await closeCustomTabs(),
      returnsNormally,
    );
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

  test(
      'mayLaunchUrl() throws ArgumentError when URL scheme is not http or https',
      () async {
    final url = Uri.parse('file:/home');
    expect(
      () => mayLaunchUrl(url),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
      'mayLaunchUrl() invoke method "mayLaunch" with CustomTabsSession on Android',
      () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    const url = 'http://example.com/';
    const customTabsSession = CustomTabsSession('com.example.browser');
    mock.setMayLaunchExpectations(
      urls: [url],
      customTabsSession: customTabsSession,
    );

    final actualSession = await mayLaunchUrl(
      Uri.parse(url),
      customTabsSession: customTabsSession,
    );
    expect(actualSession.id, isNull);
    expect(mock.mayLaunchCalled, isTrue);
  });

  test('mayLaunchUrl() invoke method "mayLaunch" with null on iOS', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    const url = 'http://example.com/';
    const prewarmingSession = SafariViewPrewarmingSession('test-session-id');
    mock.setMayLaunchExpectations(
        urls: [url],
        customTabsSession: null,
        prewarmingSession: prewarmingSession);

    final actualSession = await mayLaunchUrl(Uri.parse(url));
    expect(actualSession.id, prewarmingSession.id);
    expect(mock.mayLaunchCalled, isTrue);
  });

  test(
      'mayLaunchUrls() throws ArgumentError when URL scheme is not http or https',
      () async {
    final urls = [
      Uri.parse('https://example.com/'),
      Uri.parse('file:/home'),
    ];
    expect(
      () => mayLaunchUrls(urls),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
      'mayLaunchUrls() invoke method "mayLaunch" with CustomTabsSession on Android',
      () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    const urls = [
      'http://example.com/',
      'http://flutter.dev/',
    ];
    const customTabsSession = CustomTabsSession('com.example.browser');
    mock.setMayLaunchExpectations(
      urls: urls,
      customTabsSession: customTabsSession,
    );

    final actualSession = await mayLaunchUrls(
      urls.map(Uri.parse).toList(),
      customTabsSession: customTabsSession,
    );
    expect(actualSession.id, isNull);
    expect(mock.mayLaunchCalled, isTrue);
  });

  test('mayLaunchUrls() invoke method "mayLaunch" with null on iOS', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    const urls = [
      'http://example.com/',
      'http://flutter.dev/',
    ];
    const prewarmingSession = SafariViewPrewarmingSession('test-session-id');
    mock.setMayLaunchExpectations(
      urls: urls,
      customTabsSession: null,
      prewarmingSession: prewarmingSession,
    );

    final actualSession = await mayLaunchUrls(
      urls.map(Uri.parse).toList(),
    );
    expect(actualSession.id, prewarmingSession.id);
    expect(mock.mayLaunchCalled, isTrue);
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
