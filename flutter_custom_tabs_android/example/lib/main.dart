import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = await CustomTabsPlatform.instance.warmup();
  debugPrint('Warm up session: $session');
  runApp(MyApp(session as CustomTabsSession));
}

class MyApp extends StatefulWidget {
  final CustomTabsSession session;

  const MyApp(
    this.session, {
    super.key,
  });

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // After warming up, the session might not be established immediately, so we wait for a short period.
    final session = widget.session;
    Future.delayed(const Duration(seconds: 1), () async {
      await CustomTabsPlatform.instance.mayLaunch(
        [
          'https://flutter.dev',
          'https://dart.dev',
        ],
        session: session,
      );
    });
  }

  @override
  void dispose() {
    final session = widget.session;
    Future(() async {
      await CustomTabsPlatform.instance.invalidate(session);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                onPressed: () => _launchUrl(context),
                child: const Text('Show flutter.dev (Chrome)'),
              ),
              FilledButton.tonal(
                onPressed: () => _launchUrlInDefaultBrowser(context),
                child: const Text('Show flutter.dev (prefer default browser)'),
              ),
              FilledButton.tonal(
                onPressed: () => _launchUrlInPartialCustomTabs(context),
                child: const Text('Show flutter.dev (partial Custom Tabs)'),
              ),
              FilledButton.tonal(
                onPressed: () => _launchDeepLinkUrl(context),
                child: const Text('Deep link to Google Maps'),
              ),
              FilledButton.tonal(
                onPressed: () => _launchUrlAndCloseManually(context),
                child: const Text('Show flutter.dev + close after 5 seconds'),
              ),
              FilledButton.tonal(
                onPressed: () => _launchUrlInExternalBrowser(),
                child: const Text('Show flutter.dev in external browser'),
              ),
              FilledButton.tonal(
                onPressed: () => _launchUrlWithSession(
                  context,
                  uri: 'https://flutter.dev',
                  session: widget.session,
                ),
                child: const Text('Show flutter.dev with session'),
              ),
              FilledButton.tonal(
                onPressed: () => _launchUrlWithSession(
                  context,
                  uri: 'https://dart.dev',
                  session: widget.session,
                ),
                child: const Text('Show dart.dev with session'),
              ),
              FilledButton.tonal(
                onPressed: () => _launchUrlWithButtonOptions(),
                child: const Text('Show flutter.dev (no bookmark/download)'),
              ),
              FilledButton.tonal(
                onPressed: () => _launchUrlWithAppSpecificHistory(),
                child:
                    const Text('Show flutter.dev (with app-specific history)'),
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

Future<void> _launchUrlInDefaultBrowser(BuildContext context) async {
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

Future<void> _launchUrlInPartialCustomTabs(BuildContext context) async {
  final theme = Theme.of(context);
  final mediaQuery = MediaQuery.of(context);
  try {
    await CustomTabsPlatform.instance.launch(
      'https://flutter.dev',
      customTabsOptions: CustomTabsOptions.partial(
        configuration: PartialCustomTabsConfiguration.adaptiveSheet(
          initialHeight: mediaQuery.size.height * 0.7,
          initialWidth: mediaQuery.size.width * 0.4,
          activitySideSheetMaximizationEnabled: true,
          activitySideSheetPosition: CustomTabsActivitySideSheetPosition.start,
          activitySideSheetDecorationType:
              CustomTabsActivitySideSheetDecorationType.shadow,
          activitySideSheetRoundedCornersPosition:
              CustomTabsActivitySideSheetRoundedCornersPosition.top,
          cornerRadius: 16,
          backgroundInteractionEnabled: false,
        ),
        colorSchemes: CustomTabsColorSchemes.defaults(
          colorScheme: theme.brightness.toColorScheme(),
          toolbarColor: theme.colorScheme.primaryContainer,
        ),
        showTitle: true,
        closeButton: const CustomTabsCloseButton(
          icon: "ic_round_close",
          position: CustomTabsCloseButtonPosition.end,
        ),
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchDeepLinkUrl(BuildContext context) async {
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

Future<void> _launchUrlAndCloseManually(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    Future.delayed(const Duration(seconds: 5), () async {
      await CustomTabsPlatform.instance.closeAllIfPossible();
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

Future<void> _launchUrlInExternalBrowser() async {
  try {
    await CustomTabsPlatform.instance.launch(
      'https://flutter.dev',
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchUrlWithSession(
  BuildContext context, {
  required String uri,
  required CustomTabsSession session,
}) async {
  final theme = Theme.of(context);
  try {
    await CustomTabsPlatform.instance.launch(
      uri,
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
          navigationBarColor: theme.colorScheme.surface,
        ),
        urlBarHidingEnabled: true,
        showTitle: true,
        browser: CustomTabsBrowserConfiguration.session(session),
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchUrlWithButtonOptions() async {
  try {
    await CustomTabsPlatform.instance.launch(
      'https://flutter.dev',
      customTabsOptions: const CustomTabsOptions(
        urlBarHidingEnabled: true,
        showTitle: true,
        downloadButtonEnabled: false,
        bookmarksButtonEnabled: false,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchUrlWithAppSpecificHistory() async {
  try {
    await CustomTabsPlatform.instance.launch(
      'https://flutter.dev',
      customTabsOptions: const CustomTabsOptions(
        urlBarHidingEnabled: true,
        showTitle: true,
        shareIdentityEnabled: true,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
