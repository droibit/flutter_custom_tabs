# flutter_custom_tabs
[![pub package](https://img.shields.io/pub/v/flutter_custom_tabs.svg)](https://pub.dartlang.org/packages/flutter_custom_tabs)

A Flutter plugin to use [Chrome Custom Tabs](https://developer.chrome.com/multidevice/android/customtabs).  

![screenshot](https://i.imgur.com/lgPWvLS.gif)

Custom Tabs is supported only Chrome for Android. For this reason, the interface is same, but behavior is following:

* **Android**  
 If Chrome is installed, open web URL in custom tab that you have customized some of look & feel. If it is not installed, open in other browser.
* **iOS**  
 Open SFSafariViewController using [url_launcher](https://pub.dartlang.org/packages/url_launcher), and all options at launch are **ignored**.

## Getting Started

Add `flutter_custom_tabs` to the dependencies of your `pubspec.yaml`.

``` yaml
dependencies:
  flutter_custom_tabs: ^0.7.0
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
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: TextButton(
            child: const Text('Show Flutter homepage'),
            onPressed: () => _launchURL(context),
          ),
        ),
      ),
    );
  }

  void _launchURL(BuildContext context) async {
    try {
      await launch(
        'https://flutter.dev',
        option: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsAnimation.slideIn()
          // or user defined animation.
          animation: const CustomTabsAnimation(
            startEnter: 'slide_up',
            startExit: 'android:anim/fade_out',
            endEnter: 'android:anim/fade_in',
            endExit: 'slide_down',
          ),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],        
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
```
## License

    Copyright (C) 2015 The Android Open Source Project
    Copyright (C) 2018 Shinya Kumagai

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
