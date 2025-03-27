## 2.2.0

- Updates minimum required `flutter_custom_tabs_android/ios/web` version to 2.2.0.
- Updates Android Gradle setup to use the new Flutter Gradle plugin integration.
- Adds iOS requirements to README.

## 2.2.0-dev.1

- Addes `warmupCustomTabs`, `mayLaunchUrl(s)`, and `invalidateSession` functions for performance optimization.
- Updates minimum supported SDK version to Flutter 3.16.0/Dart 3.2.
- Updates minimum required `flutter_custom_tabs_ios/web` version to 2.2.0-dev.1.
- Updates minimum required `flutter_custom_tabs_android` version to 2.2.0-dev.3.

## 2.1.0

- Updates minimum supported SDK version to Flutter 3.10/Dart 3.
- Updates minimum required `flutter_custom_tabs_android/ios/web` version to 2.1.0.
- Updates navigationBarColor in `CustomTabsOptions` to use surface instead of deprecated background.
- Adds instructions for manually closing Custom Tabs to the README .

## 2.0.0+1

- Updates README.md with stable version dependency.

## 2.0.0

Highlights of changes from v1.x:

- Refactors the signature for launching a URL in Custom Tabs.
- Refactors the signature for manually closing Custom Tabs.
- Supports the launch of a deep link URL.
- Supports the launch of Custom Tabs as a bottom sheet.
- Supports launching a URL in an external browser.
- Introduces a lightweight version of URL launching.
- Updates the minimum supported SDK version to Flutter 3.0.0/Dart 2.17.

**NOTE:**  
Version 2.0.0 includes many breaking changes from version 1.x. For more information, please refer to the [migration guide](https://github.com/droibit/flutter_custom_tabs/blob/main/flutter_custom_tabs/doc/migration-guides.md#migrate-flutter_custom_tabs-from-v1x-to-v200).

## 2.0.0-beta.2

- Supports launching a URL in an external browser.
- Makes `LaunchOptions` class immutable.
- Renames `appBarFixed` property to `barFixingEnabled` in `LaunchOptions` class.
- Renames `CustomTabsCloseButtonIcon` class to `CustomTabsCloseButtonIcons`.
- Makes `SystemNavigationBarParams` class constructor a constant constructor.
- Fixes a bug where the share action is not added when using the lightweight version on Android.
- The lightweight version of `flutter_custom_tabs` prioritizes launching the default browser that supports Custom Tabs over Chrome.
- Updates the `flutter_custom_tabs_platform_interface` package to version 2.0.0-beta.2.
- Updates the `flutter_custom_tabs_platform_android` package to version 2.0.0-beta.2.
- Updates the `flutter_custom_tabs_platform_ios` package to version 2.0.0-beta.1.
- Updates the `flutter_custom_tabs_platform_web` package to version 2.0.0-beta.1.

For details on the changes, please refer to the [migration guide](https://github.com/droibit/flutter_custom_tabs/blob/main/flutter_custom_tabs/doc/migration-guides.md#migrate-flutter_custom_tabs-from-v1x-to-v200).

## 2.0.0-beta.1

- Adds support for prioritizing the default browser over Chrome on Androids.
- Updates the `flutter_custom_tabs_platform_interface` package to version 2.0.0-beta.1.
- Updates the `flutter_custom_tabs_platform_android` package to version 2.0.0-beta.1.
- Updates CocoaPods version to 1.14.2 in example app.

For details on the changes, please refer to the [migration guide](https://github.com/droibit/flutter_custom_tabs/blob/main/flutter_custom_tabs/doc/migration-guides.md#migrate-flutter_custom_tabs-from-v1x-to-v200).

## 2.0.0-beta

- Refactors the signature for launching a URL in Custom Tabs.
- Refactors the signature for manually closing Custom Tabs.
- Introduces a lightweight version of URL launching as an experimental feature.
- Supports the launch of a deep link URL.
- Supports the launch of Custom Tabs as a bottom sheet.
- Updates the `flutter_custom_tabs_platform_interface` package to version 2.0.0-beta.
- Updates the `flutter_custom_tabs_web` plugin package to version 2.0.0-beta+1.
- Migrates Android platform-specific implementations to the `flutter_custom_tabs_android` package plugin.
- Migrates iOS platform-specific implementations to the `flutter_custom_tabs_ios` package plugin.
- Updates the minimum supported SDK version to Flutter 3.0.0/Dart 2.17.

For details on the changes, please refer to the [migration guide](https://github.com/droibit/flutter_custom_tabs/blob/main/flutter_custom_tabs/doc/migration-guides.md).

## 1.2.1

- Fix the build error when depending on v1.2.0 plugin in some iOS projects.

## 1.2.0

- Supports presentation style customization for SFSafariViewController.
- Make `closeAllIfPossible` work on Android 6.0 and above.
- Update dependency CustomTabLauncher to [v1.7.1](https://github.com/droibit/CustomTabsLauncher/releases/tag/1.7.1).
- Depends on CocoaPods v1.12.1.
- Corrects the URLs in the README.

## 1.1.1

- Fixed a bug that handled results multiple times when opening a URL on Android.

## 1.1.0

- Added a manual close feature for SFSafariViewController on iOS.
- Update dependency CustomTabLauncher to [v1.7.0](https://github.com/droibit/CustomTabsLauncher/releases/tag/1.7.0).
- Update Android Gradle Plugin to v7.4.0.
- Update the minimum supported OS to iOS11.

## 1.0.4

- Update to Android CustomTabsLauncher 1.0.6.

## 1.0.3

- Migrate from deprecated gradle getGenerateBuildConfig to buildFeatures.
- Avoiding app crashes caused by URLs containing whitespaces.

## 1.0.2

- Fix NullPointerException when calling launch without setting the value of enableUrlBarHiding.

## 1.0.1

- Fix links in the document on pub.dev.

## 1.0.0

**NOTE:**  
The first major release include some breaking changes, see the [migration guide](https://github.com/droibit/flutter_custom_tabs/blob/1.0.0/flutter_custom_tabs/doc/migration-guides.md#migrate-flutter_custom_tabs-to-v100) for details.

- Migrate to federated plugins.
- Improved customization on iOS.

## 0.7.0

- Migrated to Null Safety.
- Bug Fix : shows black screen while launching in release mode.
- Support Android11.
- Update the dependent `url_launcher` to v6.0.3.

## 0.6.0

- Added HTTP headers option.

## 0.5.0

**NOTE:**  
This package only support CustomTabs for **androidx** from v0.5.0.  
If you migrate existing project to androidx see the [official docs](https://developer.android.com/jetpack/androidx/migrate).

- AndroidX support.

## 0.4.0

- Fix: Only works with Chrome.

## 0.3.0

- Migrate to dart 2.0 release.

## 0.2.0

- Support custom transition.
- Support enabling of Instant apps.

## 0.1.0

Initial release of plugin supports following customization options:

- Custom tab toolbar color.
- Hides the toolbar when the user scrolls down the page.
- Adds default sharing menu.
- Show web page title in tool bar.

ref. [CustomTabsIntent.Builder](https://developer.android.com/reference/android/support/customtabs/CustomTabsIntent.Builder.html)
