# flutter_custom_tabs
[![Build Status](https://travis-ci.org/droibit/flutter_custom_tabs.svg?branch=master)](https://travis-ci.org/droibit/flutter_custom_tabs)

A Flutter plugin to use [Chrome Custom Tabs](https://developer.chrome.com/multidevice/android/customtabs).  

Custom Tabs is supported only Chrome for Android. For this reason, the interface is same, but behavior is following:

* **Android**  
 If Chrome is installed, open web URL in custom tab that you have customized some of look & feel. If it is not installed, open in other browser.
* **iOS**  
 Open SFSafariViewController using [url_launcher](https://pub.dartlang.org/packages/url_launcher), and all options at launch are **ignored**.

## Getting Started

Add `flutter_custom_tabs` to the dependencies of your `pubspec.yaml`.

``` yaml
dependencies:
  flutter_custom_tabs: ^0.1.0
```

### Usage

Open the web URL like `url_launcher`.

#### Example

``` dart
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        body: new Center(
          child: new FlatButton(
            child: new Text('Show Flutter homepage'),
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
```
