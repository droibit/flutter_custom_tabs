import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PlatformSession? _session;

  @override
  void initState() {
    super.initState();

    Future(() async {
      _session = await CustomTabsPlatform.instance.mayLaunch(
        ['https://flutter.dev'],
        session: null,
      );
      debugPrint('Warm up session: $_session');
    });
  }

  @override
  void dispose() {
    final session = _session;
    if (session != null) {
      Future(() async {
        await CustomTabsPlatform.instance.invalidate(session);
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
            title: const Text('Example for iOS'),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              FilledButton(
                onPressed: () => _launchURL(context),
                child: const Text('Show flutter.dev'),
              ),
              FilledButton(
                onPressed: () => _launchURLInBottomSheet(context),
                child: const Text('Show flutter.dev in bottom sheet'),
              ),
              FilledButton(
                onPressed: () => _launchDeepLinkURL(context),
                child: const Text('Deep link to Apple Maps'),
              ),
              FilledButton(
                onPressed: () => _launchAndCloseManually(context),
                child: const Text('Show flutter.dev + close after 5 seconds'),
              ),
              FilledButton(
                onPressed: () => _launchInExternalBrowser(),
                child: const Text('Show flutter.dev in external browser'),
              ),
            ],
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

Future<void> _launchURLInBottomSheet(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await CustomTabsPlatform.instance.launch(
      'https://flutter.dev',
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
        preferredBarTintColor: theme.colorScheme.primaryContainer,
        preferredControlTintColor: theme.colorScheme.onPrimaryContainer,
        entersReaderIfAvailable: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
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
      'https://maps.apple.com/?q=tokyo+station',
      prefersDeepLink: true,
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

Future<void> _launchAndCloseManually(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    Future.delayed(const Duration(seconds: 5), () async {
      await CustomTabsPlatform.instance.closeAllIfPossible();
    });

    await CustomTabsPlatform.instance.launch(
      'https://flutter.dev',
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        barCollapsingEnabled: true,
        modalPresentationStyle: ViewControllerModalPresentationStyle.automatic,
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
