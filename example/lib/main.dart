import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new MaterialApp(
      title: 'Flutter Custom Tabs Example',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Flutter Custom Tabs Example'),
        ),
        body: new Center(
          child: new FlatButton(
            child: new Text(
              'Show Flutter homepage',
              style: new TextStyle(
                fontSize: theme.textTheme.subhead.fontSize,
                color: theme.primaryColor,
              ),
            ),
            onPressed: () => _launchURL(context),
          ),
        ),
      ),
    );
  }

  void _launchURL(BuildContext context) async {
    try {
      await launch(
        'https://flutter.io/',
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
