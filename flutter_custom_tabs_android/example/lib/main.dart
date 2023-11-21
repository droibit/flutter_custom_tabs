import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'Flutter Custom Tabs Example',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightDynamic,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkDynamic,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Example for Android'),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                FilledButton.tonal(
                  onPressed: () => _launchURL(context),
                  child: const Text('Show flutter.dev (Chrome)'),
                ),
                FilledButton.tonal(
                  onPressed: () => _launchURLInDefaultBrowser(context),
                  child:
                      const Text('Show flutter.dev (prefer default browser)'),
                ),
                FilledButton.tonal(
                  onPressed: () => _launchURLInBottomSheet(context),
                  child: const Text('Show flutter.dev in bottom sheet'),
                ),
                FilledButton.tonal(
                  onPressed: () => _launchDeepLinkingURL(context),
                  child: const Text('Deep link to Google Maps'),
                ),
                FilledButton.tonal(
                  onPressed: () => _launchAndCloseManually(context),
                  child: const Text('Show flutter.dev + close after 5 seconds'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _launchURL(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await CustomTabsPlatform.instance.launch(
      'https://flutter.dev',
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
          navigationBarColor: theme.colorScheme.background,
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        animations: CustomTabsSystemAnimations.slideIn(),
        closeButton: CustomTabsCloseButton(
          icon: CustomTabsCloseButtonIcon.back,
        ),
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

Future<void> _launchURLInDefaultBrowser(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await CustomTabsPlatform.instance.launch(
      'https://flutter.dev',
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

Future<void> _launchURLInBottomSheet(BuildContext context) async {
  final theme = Theme.of(context);
  final mediaQuery = MediaQuery.of(context);
  try {
    await CustomTabsPlatform.instance.launch(
      'https://flutter.dev',
      customTabsOptions: CustomTabsOptions.partial(
        configuration: PartialCustomTabsConfiguration(
          initialHeight: mediaQuery.size.height * 0.7,
        ),
        colorSchemes: CustomTabsColorSchemes.defaults(
          colorScheme: theme.brightness.toColorScheme(),
          toolbarColor: theme.primaryColor,
        ),
        showTitle: true,
        closeButton: const CustomTabsCloseButton(icon: "ic_round_close"),
      ),
      safariVCOptions: SafariViewControllerOptions.pageSheet(
        configuration: const SheetPresentationControllerConfiguration(
          detents: {
            SheetPresentationControllerDetent.large,
            SheetPresentationControllerDetent.medium,
          },
          largestUndimmedDetentIdentifier:
              SheetPresentationControllerDetent.medium,
          prefersScrollingExpandsWhenScrolledToEdge: false,
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

Future<void> _launchDeepLinkingURL(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await CustomTabsPlatform.instance.launch(
      'https://www.google.co.jp/maps/@35.6908883,139.7865242,13.53z',
      prefersDeepLink: true,
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
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
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
      CustomTabsPlatform.instance.closeAllIfPossible();
    });

    await CustomTabsPlatform.instance.launch(
      'https://flutter.dev',
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
