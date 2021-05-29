import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      title: 'Flutter Custom Tabs Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Custom Tabs Example'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () => _launchURL(context),
            child: Text(
              'Show Flutter homepage',
              style: TextStyle(
                fontSize: 17,
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context) async {
    try {
      await launch(
        'https://flutter.dev',
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsAnimation.slideIn(),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
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
}
