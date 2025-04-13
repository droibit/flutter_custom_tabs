import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs/src/lite/launch_options.dart';
import 'package:flutter_custom_tabs/src/lite/type_conversion.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTabsOptions', () {
    test('toCustomTabsOptions() converts LaunchOptions with null values', () {
      const launchOptions = LaunchOptions();

      final actual = launchOptions.toCustomTabsOptions();
      expect(actual.colorSchemes, isNull);
      expect(actual.urlBarHidingEnabled, isNull);
      expect(actual.shareState, CustomTabsShareState.on);
      expect(actual.showTitle, isTrue);
      expect(actual.instantAppsEnabled, isNull);
      expect(actual.downloadButtonEnabled, isNull);
      expect(actual.bookmarksButtonEnabled, isNull);
      expect(actual.shareIdentityEnabled, isTrue);
      expect(actual.closeButton, isNull);
      expect(actual.animations, isNull);
      expect(actual.browser, isNotNull);
      expect(actual.partial, isNull);

      final actualBrowser = actual.browser!;
      expect(actualBrowser.prefersDefaultBrowser, isTrue);
      expect(actualBrowser.fallbackCustomTabs, isNull);
      expect(actualBrowser.headers, isNull);
    });

    test('toCustomTabsOptions() converts with complete options', () {
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFFEBAA),
        onBarColor: Color(0xFFFFEBAB),
        systemNavigationBarParams: SystemNavigationBarParams(
          backgroundColor: Color(0xFFFFEBAC),
          dividerColor: Color(0xFFFFEBAD),
        ),
        barFixingEnabled: true,
      );

      final actual = launchOptions.toCustomTabsOptions();
      expect(actual.colorSchemes, isNotNull);
      expect(actual.urlBarHidingEnabled, isFalse);
      expect(actual.shareState, CustomTabsShareState.on);
      expect(actual.showTitle, isTrue);
      expect(actual.instantAppsEnabled, isNull);
      expect(actual.downloadButtonEnabled, isNull);
      expect(actual.bookmarksButtonEnabled, isNull);
      expect(actual.shareIdentityEnabled, isTrue);
      expect(actual.closeButton, isNull);
      expect(actual.animations, isNull);
      expect(actual.browser, isNotNull);
      expect(actual.partial, isNull);

      final actualDefaultParams = actual.colorSchemes!.defaultPrams!;
      expect(actualDefaultParams.toolbarColor, launchOptions.barColor);
      expect(
        actualDefaultParams.navigationBarColor,
        launchOptions.systemNavigationBarParams!.backgroundColor,
      );
      expect(
        actualDefaultParams.navigationBarDividerColor,
        launchOptions.systemNavigationBarParams!.dividerColor,
      );

      final actualBrowser = actual.browser!;
      expect(actualBrowser.prefersDefaultBrowser, isTrue);
      expect(actualBrowser.fallbackCustomTabs, isNull);
      expect(actualBrowser.headers, isNull);
    });

    test('toCustomTabsOptions() converts options with barColor', () {
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFEEBAA),
      );

      final actual = launchOptions.toCustomTabsOptions();
      expect(actual.colorSchemes, isNotNull);

      final actualDefaultParams = actual.colorSchemes!.defaultPrams!;
      expect(actualDefaultParams.toolbarColor, launchOptions.barColor);
      expect(actualDefaultParams.navigationBarColor, isNull);
      expect(actualDefaultParams.navigationBarDividerColor, isNull);
    });

    test(
        'toCustomTabsOptions() converts options with systemNavigationBarParams',
        () {
      const launchOptions = LaunchOptions(
        systemNavigationBarParams: SystemNavigationBarParams(
          backgroundColor: Color(0xFFFEEBAB),
          dividerColor: Color(0xFFFEEBAC),
        ),
      );

      final actual = launchOptions.toCustomTabsOptions();
      expect(actual.colorSchemes, isNotNull);

      final actualDefaultParams = actual.colorSchemes!.defaultPrams!;
      expect(actualDefaultParams.toolbarColor, isNull);
      expect(
        actualDefaultParams.navigationBarColor,
        launchOptions.systemNavigationBarParams!.backgroundColor,
      );
      expect(
        actualDefaultParams.navigationBarDividerColor,
        launchOptions.systemNavigationBarParams!.dividerColor,
      );
    });

    test(
        'toCustomTabsOptions() converts LaunchOptions with barFixingEnabled true',
        () {
      const launchOptions = LaunchOptions(
        barFixingEnabled: true,
      );

      final actual = launchOptions.toCustomTabsOptions();
      expect(actual.urlBarHidingEnabled, isFalse);
    });

    test(
        'toCustomTabsOptions() converts LaunchOptions with barFixingEnabled false',
        () {
      const launchOptions = LaunchOptions(
        barFixingEnabled: false,
      );

      final actual = launchOptions.toCustomTabsOptions();
      expect(actual.urlBarHidingEnabled, isTrue);
    });
  });

  group('SafariViewControllerOptions', () {
    test(
        'toSafariViewControllerOptions() converts LaunchOptions with null values',
        () {
      const launchOptions = LaunchOptions();

      final actual = launchOptions.toSafariViewControllerOptions();
      expect(actual.preferredBarTintColor, isNull);
      expect(actual.preferredControlTintColor, isNull);
      expect(actual.barCollapsingEnabled, isNull);
      expect(actual.entersReaderIfAvailable, isNull);
      expect(
        actual.dismissButtonStyle,
        SafariViewControllerDismissButtonStyle.done,
      );
      expect(actual.modalPresentationStyle, isNull);
      expect(actual.pageSheet, isNull);
    });

    test('toSafariViewControllerOptions() converts with complete options', () {
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFFEBAA),
        onBarColor: Color(0xFFFFEBAB),
        systemNavigationBarParams: SystemNavigationBarParams(
          backgroundColor: Color(0xFFFFEBAC),
          dividerColor: Color(0xFFFFEBAD),
        ),
        barFixingEnabled: false,
      );

      final actual = launchOptions.toSafariViewControllerOptions();
      expect(actual.preferredBarTintColor, launchOptions.barColor);
      expect(actual.preferredControlTintColor, launchOptions.onBarColor);
      expect(actual.barCollapsingEnabled, isTrue);
      expect(actual.entersReaderIfAvailable, isNull);
      expect(
        actual.dismissButtonStyle,
        SafariViewControllerDismissButtonStyle.done,
      );
      expect(actual.modalPresentationStyle, isNull);
      expect(actual.pageSheet, isNull);
    });

    test('toSafariViewControllerOptions() converts options with barColor', () {
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFFEBAA),
      );

      final actual = launchOptions.toSafariViewControllerOptions();
      expect(actual.preferredBarTintColor, launchOptions.barColor);
    });

    test('toSafariViewControllerOptions() converts options with onBarColor',
        () {
      const launchOptions = LaunchOptions(
        onBarColor: Color(0xFFFEEBAB),
      );

      final actual = launchOptions.toSafariViewControllerOptions();
      expect(actual.preferredControlTintColor, launchOptions.onBarColor);
    });

    test(
        'toSafariViewControllerOptions() converts LaunchOptions with barFixingEnabled true',
        () {
      const launchOptions = LaunchOptions(barFixingEnabled: true);

      final actual = launchOptions.toSafariViewControllerOptions();
      expect(actual.barCollapsingEnabled, isFalse);
    });

    test(
        'toSafariViewControllerOptions converts LaunchOptions with barFixingEnabled false',
        () {
      const launchOptions = LaunchOptions(barFixingEnabled: false);

      final actual = launchOptions.toSafariViewControllerOptions();
      expect(actual.barCollapsingEnabled, isTrue);
    });
  });
}
