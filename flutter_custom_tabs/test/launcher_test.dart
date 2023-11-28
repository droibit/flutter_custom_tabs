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
}
