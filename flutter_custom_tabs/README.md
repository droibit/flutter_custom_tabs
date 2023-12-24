# flutter_custom_tabs
[![pub package](https://img.shields.io/pub/v/flutter_custom_tabs.svg)](https://pub.dartlang.org/packages/flutter_custom_tabs)

A Flutter plugin for mobile apps to launch a URL in Custom Tabs.  
The plugin allows you to add the browser experience that Custom Tabs provides to your mobile apps.

In version 2.0, the plugin expands the support for launching a URL in mobile apps:
- Launch a URL in an external browser.
- Launch a deep link URL.

|             | Android | iOS   |  Web  |
|-------------|---------|-------|-------|
| **Support** | SDK 19+ | 11.0+ | Any   |
| Implementation | [Custom Tabs](https://developer.chrome.com/docs/android/custom-tabs/) | [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) | [url_launcher](https://pub.dev/packages/url_launcher) |

## Getting Started
Add `flutter_custom_tabs` to the dependencies of your `pubspec.yaml`.

``` yaml
dependencies:
  flutter_custom_tabs: ^2.0.0-beta
```

> [!IMPORTANT]  
> v2.0.0 includes breaking changes from v1.x. Please refer to the [migration guide](https://github.com/droibit/flutter_custom_tabs/blob/flutter_custom_tabs_2.0/flutter_custom_tabs/doc/migration-guides.md) when updating the plugin.

### Requirements for Android
- Android Gradle Plugin v7.4.0 and above.
- Kotlin v1.7.0 and above.

```groovy
// your-project/android/build.gradle
buildscript {
    ext.kotlin_version = '1.7.0' // and above if explicitly depending on Kotlin.

    dependencies {
        classpath 'com.android.tools.build:gradle:7.4.0' // and above.
    }
}
```

## Usage
You can launch a web URL similar to `url_launcher` and specify options to customize appearance and behavior.

| Android | iOS |
| --- | --- |
| ![android](https://i.imgur.com/lgPWvLS.gif) | ![iOS](https://i.imgur.com/LhsCUzb.gif) |

### Basic Usage

``` dart
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void _launchURL(BuildContext context) async {
  final theme = Theme.of(context);
  try {
    await launchUrl(
      Uri.parse('https://flutter.dev'),      
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        closeButton: CustomTabsCloseButton(
          icon: CustomTabsCloseButtonIcons.back,
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
    // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
    debugPrint(e.toString());
  }
}
```

See the example app for more complex examples.

### Usage of the lightweight version

This package supports a wide range of Custom Tabs customizations,   
but we have experimentally introduced a lightweight URL launch for users who don't need as much in v2.0.0.

> [!NOTE]  
> On Android, **the lightweight version** prefers launching the default browser that supports Custom Tabs over Chrome.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart';

void _launchURL(BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse('https://flutter.dev'),
        options: LaunchOptions(
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
```

## Custom Tabs Customization

| Option | Android (`CustomTabsOptions`) | iOS (`SafariViewControllerOptions`) | `LaunchOptions` |
| --- | :---: | :---: | :---: |
| Change background color of app/bottom bar | ✅ | ✅ | ✅ |
| Change color of controls on app/bottom bar | -<br>(Automatically adjusted by Custom Tabs) | ✅ | ✅ |
| Change background color of system navigation bar | ✅ | - | ✅ |
| Change color of system navigation divider | ✅ | - | ✅ |
| Hide(Collapse) the app bar by scrolling | ✅ | ✅ | ✅ |
| Add sharing action for web pages | ✅ | - | ✅<br>(always added on Android) |
| Change visibility of web page title | ✅ | - | ✅<br>(always shown on Android) |
| Change the availability of Reader mode | - | ✅ | Not provided |
| Change appearance of close button | ✅<br>(Icon, position) | ✅<br>(Predefined button styles) | Not provided |
| Change the availability of [Instant Apps](https://developer.android.com/topic/instant-apps/index.html) | ✅ | - | Not provided | 
| Change animation style | ✅ | ✅<br>(Predefined modal presentation styles) | Not provided | 
| Prefer the default browser over Chrome | ✅ | - | Not provided |
| Pass HTTP headers | ✅ | - | Not provided | 
| Show as a bottom sheet | ✅ | ✅ | Not provided | 

Support status in `flutter_custom_tabs`:
- ✅: Supported.
- `-`: Option not provided by Custom Tabs implementation.

## Advanced Usage

### Deep Linking
Supports launching a deep link URL.  
(If a native app that responds to the deep link URL is installed, it will directly launch it. otherwise, it will launch a custom tab.)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
// or import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart';

Future<void> _launchDeepLinkURL(BuildContext context) async {
  final theme = Theme.of(context);
  await launchUrl(
    Uri.parse('https://www.google.com/maps/@35.6908883,139.7865242,13z'),
    prefersDeepLink: true,
    customTabsOptions: CustomTabsOptions(
      colorSchemes: CustomTabsColorSchemes.defaults(
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

## Launch in an external browser
By default, if no mobile platform-specific options are specified, a URL will be launched in an external browser.

> [!TIP]  
> Android: `CustomTabsOptions.externalBrowser` supports HTTP request headers.

```dart
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

Future<void> _launchInExternalBrowser() async {
  await launchUrl(Uri.parse('https://flutter.dev'));
}
```

### Show as a bottom sheet
You can launch a URL in Custom Tabs as a bottom sheet.

Requirements:
- Android: Chrome v107 and above or [other browsers](https://developer.chrome.com/docs/android/custom-tabs/browser-support/#setinitialactivityheightpx)
- iOS: 15.0+ 

```dart
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

Future<void> _launchURLInBottomSheet(BuildContext context) async {
  final theme = Theme.of(context);
  final mediaQuery = MediaQuery.of(context);    
  await launchUrl(
    Uri.parse('https://flutter.dev'),
    customTabsOptions: CustomTabsOptions.partial(
      configuration: PartialCustomTabsConfiguration(
        initialHeight: mediaQuery.size.height * 0.7,
      ),
      colorSchemes: CustomTabsColorSchemes.defaults(
        toolbarColor: theme.colorScheme.surface,
      ),
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
      ),
      preferredBarTintColor: theme.colorScheme.surface,
      preferredControlTintColor: theme.colorScheme.onSurface,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
    ),
  );
}
```

### Prefer the default browser over Chrome
On Android, the plugin defaults to launching Chrome, which supports all Custom Tabs features.   
You can prioritize launching the default browser on the device that supports Custom Tabs over Chrome.

> [!NOTE]  
> Some browsers may not support the options specified in CustomTabsOptions.
> - See: [Custom Tabs Browser Support](https://developer.chrome.com/docs/android/custom-tabs/browser-support/).

```dart
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

Future<void> _launchURLInDefaultBrowserOnAndroid() async {  
  await launchUrl(
    Uri.parse('https://flutter.dev'),
    customTabsOptions: CustomTabsOptions(
      browser: const CustomTabsBrowserConfiguration(
        prefersDefaultBrowser: true,
      ),
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
