import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs/src/launch_options.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTabsOptions', () {
    test('toCustomTabsOptions() converts LaunchOptions with appBarFixed true',
        () {
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFFEBAA),
        onBarColor: Color(0xFFFFEBAB),
        appBarFixed: true,
      );

      final customTabsOptions = launchOptions.toCustomTabsOptions();
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.toolbarColor,
        const Color(0xFFFFEBAA),
      );
      expect(customTabsOptions.urlBarHidingEnabled, false);
      expect(customTabsOptions.showTitle, true);
    });

    test('toCustomTabsOptions() converts LaunchOptions with appBarFixed false',
        () {
      // Arrange
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFFEBAC),
        onBarColor: Color(0xFFFFEBAD),
        appBarFixed: false,
      );

      // Act
      final customTabsOptions = launchOptions.toCustomTabsOptions();

      // Assert
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.toolbarColor,
        const Color(0xFFFFEBAC),
      );
      expect(customTabsOptions.urlBarHidingEnabled, true);
      expect(customTabsOptions.showTitle, true);
    });

    test('toCustomTabsOptions() converts LaunchOptions with null appBarFixed',
        () {
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFFEBAE),
        onBarColor: Color(0xFFFFEBAF),
      );

      final customTabsOptions = launchOptions.toCustomTabsOptions();
      expect(
        customTabsOptions.colorSchemes!.defaultPrams!.toolbarColor,
        const Color(0xFFFFEBAE),
      );
      expect(customTabsOptions.urlBarHidingEnabled, null);
      expect(customTabsOptions.showTitle, true);
    });

    test('toCustomTabsOptions converts LaunchOptions with null values', () {
      const launchOptions = LaunchOptions();

      final customTabsOptions = launchOptions.toCustomTabsOptions();
      expect(customTabsOptions.colorSchemes, null);
      expect(customTabsOptions.urlBarHidingEnabled, null);
      expect(customTabsOptions.showTitle, true);
    });
  });

  group('SafariViewControllerOptions', () {
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
      expect(safariVCOptions.barCollapsingEnabled, false);
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
      expect(safariVCOptions.barCollapsingEnabled, true);
      expect(
        safariVCOptions.dismissButtonStyle,
        SafariViewControllerDismissButtonStyle.done,
      );
    });

    test(
        'toSafariViewControllerOptions converts LaunchOptions with null appBarFixed',
        () {
      // Arrange
      const launchOptions = LaunchOptions(
        barColor: Color(0xFFFFEBBE),
        onBarColor: Color(0xFFFFEBBF),
      );

      final safariVCOptions = launchOptions.toSafariViewControllerOptions();
      expect(
        safariVCOptions.preferredBarTintColor,
        const Color(0xFFFFEBBE),
      );
      expect(
        safariVCOptions.preferredControlTintColor,
        const Color(0xFFFFEBBF),
      );
      expect(safariVCOptions.barCollapsingEnabled, null);
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
      expect(safariVCOptions.preferredBarTintColor, null);
      expect(safariVCOptions.preferredControlTintColor, null);
      expect(safariVCOptions.barCollapsingEnabled, null);
      expect(
        safariVCOptions.dismissButtonStyle,
        SafariViewControllerDismissButtonStyle.done,
      );
    });
  });
}
