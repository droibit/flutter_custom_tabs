# flutter_custom_tabs
[![pub package](https://img.shields.io/pub/v/flutter_custom_tabs.svg)](https://pub.dartlang.org/packages/flutter_custom_tabs)

A Flutter plugin for mobile apps to launch URLs in Custom Tabs.

|             | Android | iOS   |  Web  |
|-------------|---------|-------|-------|
| **Support** | SDK 19+ | 11.0+ | Any   |
| Implementation | [Custom Tabs](https://developer.chrome.com/docs/android/custom-tabs/) | [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) | [url_launcher](https://pub.dev/packages/url_launcher) |

## Getting Started
Add `flutter_custom_tabs` to the dependencies of your `pubspec.yaml`.

``` yaml
dependencies:
  flutter_custom_tabs: ^1.2.1
```

### Requirements for Android
- Android Gradle Plugin v7.4.0 and above.
- Kotlin v1.7.0 and above.

```diff
// your-project/android/build.gradle
buildscript {
    ext.kotlin_version = '1.7.0' // and above if explicitly depending on Kotlin.

    dependencies {
        classpath 'com.android.tools.build:gradle:7.4.0' // and above.
    }
}
```

## Basic Usage
You can launch web URLs similar to `url_launcher` and specify options to customize appearance and behavior.

| Android | iOS |
| --- | --- |
| ![android](https://i.imgur.com/lgPWvLS.gif) | ![iOS](https://i.imgur.com/LhsCUzb.gif) |

### Example

``` dart
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: const Text('Show flutter.dev'),
            onPressed: () => _launchURL(context),
          ),
        ),
      ),
    );
  }

  void _launchURL(BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await launchUrlString(
        'https://flutter.dev',
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.theme(
            toolbarColor: theme.colorScheme.surface,
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
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,        
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
```

See the example app for more complex examples.

## Advanced Usage

### Deep Linking
Supports launching deep link URLs.  
(If a native app that responds to the deep link URL is installed, it will directly launch it. otherwise, it will launch a custom tab.)

```dart
Future<void> _launchDeepLinkURL(BuildContext context) async {
  final theme = Theme.of(context);
  await launchUrlString(
    'https://www.google.com/maps/@35.6908883,139.7865242,13z',
    prefersDeepLink: true,
    customTabsOptions: CustomTabsOptions(
      colorSchemes: CustomTabsColorSchemes.theme(
        toolbarColor: theme.colorScheme.surface,
      ),
    ),
    safariVCOptions: SafariViewControllerOptions(
      preferredBarTintColor: theme.colorScheme.surface,
      preferredControlTintColor: theme.colorScheme.onSurface,
    ),
  );
}
```

### Launches as a bottom sheet
You can launch URLs in Custom Tabs as a bottom sheet.

Requirements:
- Android: Chrome v107 and above or [other browsers](https://developer.chrome.com/docs/android/custom-tabs/browser-support/#setinitialactivityheightpx)
- iOS: 15.0+ 

```dart
  Future<void> _launchURLInBottomSheet(BuildContext context) async {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);    
    await launchUrlString(
      'https://flutter.dev',
      customTabsOptions: CustomTabsOptions.partial(
        configuration: PartialCustomTabsConfiguration(
          initialHeight: mediaQuery.size.height * 0.7,
        ),
        colorSchemes: CustomTabsColorSchemes.theme(
          toolbarColor: theme.colorScheme.surface,
        ),
      ),
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
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
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
