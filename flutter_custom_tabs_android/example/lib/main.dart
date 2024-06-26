import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
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
                  onPressed: () => _launchDeepLinkURL(context),
                  child: const Text('Deep link to Google Maps'),
                ),
                FilledButton.tonal(
                  onPressed: () => _launchAndCloseManually(context),
                  child: const Text('Show flutter.dev + close after 5 seconds'),
                ),
                FilledButton.tonal(
                  onPressed: () => _launchInExternalBrowser(),
                  child: const Text('Show flutter.dev in external browser'),
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
          navigationBarColor: theme.colorScheme.surface,
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        animations: CustomTabsSystemAnimations.slideIn(),
        closeButton: CustomTabsCloseButton(
          icon: CustomTabsCloseButtonIcons.back,
        ),
      ),
    );
  } catch (e) {
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
          navigationBarColor: theme.colorScheme.surface,
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
          toolbarColor: theme.colorScheme.primaryContainer,
        ),
        showTitle: true,
        closeButton: const CustomTabsCloseButton(icon: "ic_round_close"),
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchDeepLinkURL(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await CustomTabsPlatform.instance.launch(
      'https://www.google.co.jp/maps/@35.681236,139.767125,15z',
      prefersDeepLink: true,
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
          navigationBarColor: theme.colorScheme.surface,
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
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
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchInExternalBrowser() async {
  try {
    await CustomTabsPlatform.instance.launch(
      'https://flutter.dev',
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
