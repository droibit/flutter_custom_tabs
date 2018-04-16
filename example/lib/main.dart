import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void main() => runApp(new MyApp());

const String _urlFlutter = 'https://flutter.io/';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new MaterialApp(
      title: 'Flutter Custom Tabs Example',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.orange,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Flutter Custom Tabs Example'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlatButton(
                child: new Text(
                  'https://flutter.io/',
                  style: new TextStyle(
                    fontSize: theme.textTheme.subhead.fontSize,
                    color: theme.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () async {
                  try {
                    await launch(
                      _urlFlutter,
                      option: new CustomTabsOption(
                        toolbarColor: theme.primaryColor,
                        enableDefaultShare: true,
                        enableUrlBarHiding: true,
                        showPageTitle: true,
                      ),
                    );
                  } catch (e) {
                    // An exception is thrown if browser app is not installed on Android device.
                    debugPrint(e.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
