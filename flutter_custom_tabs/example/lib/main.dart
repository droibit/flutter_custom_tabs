import 'package:flutter/material.dart';

// ignore:depend_on_referenced_packages
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
// ignore:depend_on_referenced_packages
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () => _launchUrl(context),
                  child: const Text('Show flutter.dev'),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => _launchUrlLite(context),
                  child: Text(
                    'Show flutter.dev(lite ver)',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _launchUrlInBottomSheet(context),
                  child: Text(
                    'Show flutter.dev in bottom Sheet',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse('https://flutter.dev'),
        prefersDeepLink: true,
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
            navigationBarColor: theme.colorScheme.background,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
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

  Future<void> _launchUrlLite(BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await lite.launchUrl(
        Uri.parse('https://flutter.dev'),
        options: lite.LaunchOptions(
          barColor: theme.colorScheme.surface,
          onBarColor: theme.colorScheme.onSurface,
          appBarFixed: false,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
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
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
