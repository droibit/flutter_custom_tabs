import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart' as lite;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = await warmupCustomTabs(
    options: const CustomTabsSessionOptions(prefersDefaultBrowser: true),
  );
  debugPrint('Warm up session: $session');
  runApp(MyApp(session));
}

class MyApp extends StatefulWidget {
  final CustomTabsSession customTabsSession;

  const MyApp(this.customTabsSession, {super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SafariViewPrewarmingSession? _prewarmingSession;

  @override
  void initState() {
    super.initState();

    // After warming up, the session might not be established immediately, so we wait for a short period.
    final customTabsSession = widget.customTabsSession;
    Future.delayed(const Duration(seconds: 1), () async {
      _prewarmingSession = await mayLaunchUrl(
        Uri.parse('https://flutter.dev'),
        customTabsSession: customTabsSession,
      );
      debugPrint('Prewarming connection: $_prewarmingSession');
    });
  }

  @override
  void dispose() {
    final session = _prewarmingSession;
    if (session != null) {
      Future(() async {
        await invalidateSession(session);
      });
    }
    super.dispose();
  }

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
                child: Text(
                  Platform.isAndroid
                      ? 'Show flutter.dev (Chrome)'
                      : 'Show flutter.dev',
                ),
              ),
              if (Platform.isAndroid)
                FilledButton(
                  onPressed: () => _launchUrlInDefaultBrowserOnAndroid(context),
                  child:
                      const Text('Show flutter.dev (prefer default browser)'),
                ),
              FilledButton(
                onPressed: () => _launchUrlLite(context),
                child: const Text('Show flutter.dev (lite ver)'),
              ),
              FilledButton(
                onPressed: () => _launchDeepLinkUrl(context),
                child: const Text('Deep link to platform maps'),
              ),
              FilledButton(
                onPressed: () => _launchUrlInBottomSheet(context),
                child: const Text('Show flutter.dev in bottom sheet'),
              ),
              FilledButton(
                onPressed: () => _launchUrlWithCustomCloseButton(context),
                child: const Text('Show flutter.dev with custom close button'),
              ),
              FilledButton(
                onPressed: () => _launchUrlWithCustomAnimation(context),
                child: const Text('Show flutter.dev with custom animation'),
              ),
              FilledButton(
                onPressed: () => _launchUrlAndCloseManually(context),
                child: const Text('Show flutter.dev + close after 5 seconds'),
              ),
              FilledButton(
                onPressed: () => _launchUrlInExternalBrowser(),
                child: const Text('Show flutter.dev in external browser'),
              ),
              FilledButton(
                onPressed: () =>
                    _launchUrlWithSession(context, widget.customTabsSession),
                child: const Text('Show flutter.dev with session'),
              ),
              if (Platform.isAndroid)
                FilledButton(
                  onPressed: () => _launchUrlWithAppSpecificHistoryOnAndroid(),
                  child: const Text(
                      'Show flutter.dev (with app-specific history)'),
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
          navigationBarColor: theme.colorScheme.surface,
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
    // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
    debugPrint(e.toString());
  }
}

Future<void> _launchUrlInDefaultBrowserOnAndroid(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await launchUrl(
      Uri.parse('https://flutter.dev'),
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
    // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
    debugPrint(e.toString());
  }
}

Future<void> _launchDeepLinkUrl(BuildContext context) async {
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
          navigationBarColor: theme.colorScheme.surface,
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
          toolbarColor: theme.colorScheme.primary,
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
        preferredBarTintColor: theme.colorScheme.primary,
        preferredControlTintColor: theme.colorScheme.onPrimary,
        entersReaderIfAvailable: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchUrlWithCustomCloseButton(BuildContext context) async {
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

Future<void> _launchUrlWithCustomAnimation(BuildContext context) async {
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

Future<void> _launchUrlAndCloseManually(BuildContext context) async {
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

Future<void> _launchUrlInExternalBrowser() async {
  try {
    await launchUrl(
      Uri.parse('https://flutter.dev'),
      prefersDeepLink: false,
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _launchUrlWithSession(
  BuildContext context,
  CustomTabsSession session,
) async {
  final theme = Theme.of(context);
  try {
    await launchUrl(
      Uri.parse('https://flutter.dev'),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
          navigationBarColor: theme.colorScheme.surface,
        ),
        urlBarHidingEnabled: true,
        showTitle: true,
        browser: CustomTabsBrowserConfiguration.session(session),
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

Future<void> _launchUrlWithAppSpecificHistoryOnAndroid() async {
  await launchUrl(
    Uri.parse('https://flutter.dev'),
    customTabsOptions: const CustomTabsOptions(
      urlBarHidingEnabled: true,
      showTitle: true,
      shareIdentityEnabled: true,
    ),
  );
}
