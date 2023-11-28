import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart' as lite;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Tabs Example',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Custom Tabs Example'),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              FilledButton(
                onPressed: () => _launchUrl(context),
                child: const Text('Show flutter.dev (Chrome)'),
              ),
              FilledButton(
                onPressed: () => _launchURLInDefaultBrowserOnAndroid(context),
                child: const Text('Show flutter.dev (prefer default browser)'),
              ),
              FilledButton(
                onPressed: () => _launchUrlLite(context),
                child: const Text('Show flutter.dev (lite ver)'),
              ),
              FilledButton(
                onPressed: () => _launchDeepLinkingURL(context),
                child: const Text('Deep link to platform maps'),
              ),
              FilledButton(
                onPressed: () => _launchUrlInBottomSheet(context),
                child: const Text('Show flutter.dev in bottom sheet'),
              ),
              FilledButton(
                onPressed: () => _launchWithCustomCloseButton(context),
                child: const Text('Show flutter.dev with custom close button'),
              ),
              FilledButton(
                onPressed: () => _launchWithCustomAnimation(context),
                child: const Text('Show flutter.dev with custom animation'),
              ),
              FilledButton(
                onPressed: () => _launchAndCloseManually(context),
                child: const Text('Show flutter.dev + close after 5 seconds'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launchUrl(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await launchUrl(
      Uri.parse('https://flutter.dev'),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
          navigationBarColor: theme.colorScheme.background,
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

Future<void> _launchURLInDefaultBrowserOnAndroid(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await launchUrl(
      Uri.parse('https://flutter.dev'),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
          navigationBarColor: theme.colorScheme.background,
        ),
        urlBarHidingEnabled: true,
        showTitle: true,
        browser: const CustomTabsBrowserConfiguration(
          prefersDefaultBrowser: true,
        ),
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchUrlLite(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await lite.launchUrl(
      Uri.parse('https://flutter.dev'),
      options: lite.LaunchOptions(
        barColor: theme.colorScheme.surface,
        onBarColor: theme.colorScheme.onSurface,
        barFixingEnabled: false,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

Future<void> _launchDeepLinkingURL(BuildContext context) async {
  final theme = Theme.of(context);
  final uri = Platform.isIOS
      ? 'https://maps.apple.com/?q=tokyo+station'
      : 'https://www.google.co.jp/maps/@35.6908883,139.7865242,13.53z';
  try {
    await launchUrl(
      Uri.parse(uri),
      prefersDeepLink: true,
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
          navigationBarColor: theme.colorScheme.background,
        ),
        urlBarHidingEnabled: true,
        showTitle: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        barCollapsingEnabled: true,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchUrlInBottomSheet(BuildContext context) async {
  final theme = Theme.of(context);
  final mediaQuery = MediaQuery.of(context);
  try {
    await launchUrl(
      Uri.parse('https://flutter.dev'),
      customTabsOptions: CustomTabsOptions.partial(
        configuration: PartialCustomTabsConfiguration(
          initialHeight: mediaQuery.size.height * 0.7,
        ),
        colorSchemes: CustomTabsColorSchemes.defaults(
          colorScheme: theme.brightness.toColorScheme(),
          toolbarColor: theme.primaryColor,
        ),
        showTitle: true,
      ),
      safariVCOptions: SafariViewControllerOptions.pageSheet(
        configuration: const SheetPresentationControllerConfiguration(
          detents: {
            SheetPresentationControllerDetent.large,
            SheetPresentationControllerDetent.medium,
          },
          prefersScrollingExpandsWhenScrolledToEdge: true,
          prefersGrabberVisible: true,
          prefersEdgeAttachedInCompactHeight: true,
          preferredCornerRadius: 16.0,
        ),
        preferredBarTintColor: theme.primaryColor,
        preferredControlTintColor: Colors.white,
        entersReaderIfAvailable: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchWithCustomCloseButton(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await launchUrl(
      Uri.parse('https://flutter.dev'),
      customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
          ),
          showTitle: true,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          )),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchWithCustomAnimation(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await launchUrl(
      Uri.parse('https://flutter.dev'),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
        ),
        showTitle: true,
        animations: CustomTabsSystemAnimations.fade(),
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        modalPresentationStyle: ViewControllerModalPresentationStyle.automatic,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchAndCloseManually(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    Timer(const Duration(seconds: 5), () {
      closeCustomTabs();
    });

    await launchUrl(
      Uri.parse('https://flutter.dev'),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
        ),
        showTitle: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
