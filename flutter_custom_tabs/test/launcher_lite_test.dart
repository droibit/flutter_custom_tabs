import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart';
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

  test('launchUrl() launch with empty options', () async {
    final url = Uri.parse('http://example.com/');
    const prefersDeepLink = false;
    const options = LaunchOptions();
    mock.setLaunchExpectations(
      url: url.toString(),
      prefersDeepLink: prefersDeepLink,
      customTabsOptions: options.toCustomTabsOptions(),
      safariVCOptions: options.toSafariViewControllerOptions(),
    );

    try {
      await launchUrl(
        url,
        prefersDeepLink: prefersDeepLink,
        options: options,
      );
    } catch (e) {
      fail(e.toString());
    }
  });

  test('launchUrl() launch with options', () async {
    final url = Uri.parse('http://example.com/');
    const prefersDeepLink = true;
    const options = LaunchOptions(
      appBarFixed: false,
    );
    mock.setLaunchExpectations(
      url: url.toString(),
      prefersDeepLink: prefersDeepLink,
      customTabsOptions: options.toCustomTabsOptions(),
      safariVCOptions: options.toSafariViewControllerOptions(),
    );

    try {
      await launchUrl(
        url,
        prefersDeepLink: prefersDeepLink,
        options: options,
      );
    } catch (e) {
      fail(e.toString());
    }
  });
}
