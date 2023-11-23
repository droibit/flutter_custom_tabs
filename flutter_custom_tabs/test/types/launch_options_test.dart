import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart';
import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTabsOptions', () {
    test('toCustomTabsOptions() converts with complete options', () {
      final launchOptions = LaunchOptions(
        barColor: const Color(0xFFFFEBAA),
        onBarColor: const Color(0xFFFFEBAB),
        systemNavigationBarParams: SystemNavigationBarParams(
          backgroundColor: const Color(0xFFFFEBAC),
          dividerColor: const Color(0xFFFFEBAD),
        ),
        appBarFixed: true,
      );

      final customTabsOptions = launchOptions.toCustomTabsOptions();
      expect(customTabsOptions.colorSchemes, isNotNull);
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.toolbarColor,
        const Color(0xFFFFEBAA),
      );
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.navigationBarColor,
        const Color(0xFFFFEBAC),
      );
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.navigationBarDividerColor,
        const Color(0xFFFFEBAD),
      );
      expect(customTabsOptions.urlBarHidingEnabled, isFalse);
      expect(customTabsOptions.showTitle, isTrue);
    });

    test('toCustomTabsOptions() converts options with barColor', () {
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFFEBAA),
      );

      final customTabsOptions = launchOptions.toCustomTabsOptions();
      expect(customTabsOptions.colorSchemes, isNotNull);
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.toolbarColor,
        const Color(0xFFFFEBAA),
      );
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.navigationBarColor,
        isNull,
      );
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.navigationBarDividerColor,
        isNull,
      );
      expect(customTabsOptions.urlBarHidingEnabled, isNull);
      expect(customTabsOptions.showTitle, isTrue);
    });

    test(
        'toCustomTabsOptions() converts options with systemNavigationBarParams',
        () {
      final launchOptions = LaunchOptions(
        systemNavigationBarParams: SystemNavigationBarParams(
          backgroundColor: const Color(0xFFFFEBBA),
          dividerColor: const Color(0xFFFFEBBB),
        ),
      );

      final customTabsOptions = launchOptions.toCustomTabsOptions();
      expect(customTabsOptions.colorSchemes, isNotNull);
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.toolbarColor,
        isNull,
      );
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.navigationBarColor,
        const Color(0xFFFFEBBA),
      );
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.navigationBarDividerColor,
        const Color(0xFFFFEBBB),
      );
      expect(customTabsOptions.urlBarHidingEnabled, isNull);
      expect(customTabsOptions.showTitle, isTrue);
    });

    test('toCustomTabsOptions() converts LaunchOptions with appBarFixed true',
        () {
      const launchOptions = LaunchOptions(
        appBarFixed: true,
      );

      final customTabsOptions = launchOptions.toCustomTabsOptions();
      expect(customTabsOptions.colorSchemes, isNull);
      expect(customTabsOptions.urlBarHidingEnabled, isFalse);
      expect(customTabsOptions.showTitle, isTrue);
    });

    test('toCustomTabsOptions() converts LaunchOptions with appBarFixed false',
        () {
      const launchOptions = LaunchOptions(
        appBarFixed: false,
      );

      final customTabsOptions = launchOptions.toCustomTabsOptions();
      expect(customTabsOptions.colorSchemes, isNull);
      expect(customTabsOptions.urlBarHidingEnabled, isTrue);
      expect(customTabsOptions.showTitle, isTrue);
    });

    test('toCustomTabsOptions converts LaunchOptions with null values', () {
      const launchOptions = LaunchOptions();

      final customTabsOptions = launchOptions.toCustomTabsOptions();
      expect(customTabsOptions.colorSchemes, isNull);
      expect(customTabsOptions.urlBarHidingEnabled, isNull);
      expect(customTabsOptions.showTitle, isTrue);
    });
  });

  group('SafariViewControllerOptions', () {
    test('toSafariViewControllerOptions() converts with complete options', () {
      final launchOptions = LaunchOptions(
        barColor: const Color(0xFFFFEBAA),
        onBarColor: const Color(0xFFFFEBAB),
        systemNavigationBarParams: SystemNavigationBarParams(
          backgroundColor: const Color(0xFFFFEBAC),
          dividerColor: const Color(0xFFFFEBAD),
        ),
        appBarFixed: false,
      );

      final safariVCOptions = launchOptions.toSafariViewControllerOptions();
      expect(
        safariVCOptions.preferredBarTintColor,
        const Color(0xFFFFEBAA),
      );
      expect(
        safariVCOptions.preferredControlTintColor,
        const Color(0xFFFFEBAB),
      );
      expect(safariVCOptions.barCollapsingEnabled, isTrue);
      expect(
        safariVCOptions.dismissButtonStyle,
        SafariViewControllerDismissButtonStyle.done,
      );
    });

    test('toSafariViewControllerOptions() converts options with barColor', () {
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFFEBAA),
      );

      final safariVCOptions = launchOptions.toSafariViewControllerOptions();
      expect(
        safariVCOptions.preferredBarTintColor,
        const Color(0xFFFFEBAA),
      );
      expect(
        safariVCOptions.preferredControlTintColor,
        isNull,
      );
      expect(safariVCOptions.barCollapsingEnabled, isNull);
      expect(
        safariVCOptions.dismissButtonStyle,
        SafariViewControllerDismissButtonStyle.done,
      );
    });

    test('toSafariViewControllerOptions() converts options with onBarColor',
        () {
      const launchOptions = LaunchOptions(
        onBarColor: Color(0xFFFFEBAB),
      );

      final safariVCOptions = launchOptions.toSafariViewControllerOptions();
      expect(
        safariVCOptions.preferredBarTintColor,
        isNull,
      );
      expect(
        safariVCOptions.preferredControlTintColor,
        const Color(0xFFFFEBAB),
      );
      expect(safariVCOptions.barCollapsingEnabled, isNull);
      expect(
        safariVCOptions.dismissButtonStyle,
        SafariViewControllerDismissButtonStyle.done,
      );
    });

    test(
        'toSafariViewControllerOptions() converts LaunchOptions with appBarFixed true',
        () {
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFFEBBA),
        onBarColor: Color(0xFFFFEBBB),
        appBarFixed: true,
      );

      final safariVCOptions = launchOptions.toSafariViewControllerOptions();
      expect(
        safariVCOptions.preferredBarTintColor,
        const Color(0xFFFFEBBA),
      );
      expect(
        safariVCOptions.preferredControlTintColor,
        const Color(0xFFFFEBBB),
      );
      expect(safariVCOptions.barCollapsingEnabled, isFalse);
      expect(
        safariVCOptions.dismissButtonStyle,
        SafariViewControllerDismissButtonStyle.done,
      );
    });

    test(
        'toSafariViewControllerOptions converts LaunchOptions with appBarFixed false',
        () {
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFFEBBC),
        onBarColor: Color(0xFFFFEBBD),
        appBarFixed: false,
      );

      final safariVCOptions = launchOptions.toSafariViewControllerOptions();
      expect(
        safariVCOptions.preferredBarTintColor,
        const Color(0xFFFFEBBC),
      );
      expect(
        safariVCOptions.preferredControlTintColor,
        const Color(0xFFFFEBBD),
      );
      expect(safariVCOptions.barCollapsingEnabled, isTrue);
      expect(
        safariVCOptions.dismissButtonStyle,
        SafariViewControllerDismissButtonStyle.done,
      );
    });

    test(
        'toSafariViewControllerOptions() converts LaunchOptions with null values',
        () {
      const launchOptions = LaunchOptions();

      final safariVCOptions = launchOptions.toSafariViewControllerOptions();
      expect(safariVCOptions.preferredBarTintColor, isNull);
      expect(safariVCOptions.preferredControlTintColor, isNull);
      expect(safariVCOptions.barCollapsingEnabled, isNull);
      expect(
        safariVCOptions.dismissButtonStyle,
        SafariViewControllerDismissButtonStyle.done,
      );
    });
  });
}
