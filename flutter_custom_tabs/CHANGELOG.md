## 1.1.0

- Added a manual close feature for SFSafariViewController on iOS([#67](https://github.com/droibit/flutter_custom_tabs/pull/67)).
- Update dependency CustomTabLauncher to [v1.7.0](https://github.com/droibit/CustomTabsLauncher/releases/tag/1.7.0)([#74](https://github.com/droibit/flutter_custom_tabs/pull/74)).
- Update Android Gradle Plugin to v7.4.0([#75](https://github.com/droibit/flutter_custom_tabs/pull/75)).
- Update the minimum supported OS to iOS11([#75](https://github.com/droibit/flutter_custom_tabs/pull/75)).

## 1.0.4

- Update to Android CustomTabsLauncher 1.0.6([#62](https://github.com/droibit/flutter_custom_tabs/pull/62)).

## 1.0.3,

- Migrate from deprecated gradle getGenerateBuildConfig to buildFeatures([#49](https://github.com/droibit/flutter_custom_tabs/pull/49)).
- Avoiding app crashes caused by URLs containing whitespaces([#50](https://github.com/droibit/flutter_custom_tabs/issues/50), [#52](https://github.com/droibit/flutter_custom_tabs/pull/52)).

## 1.0.2

- Fix NullPointerException when calling launch without setting the value of enableUrlBarHiding([#47](https://github.com/droibit/flutter_custom_tabs/pull/47)).

## 1.0.1

- Fix links in the document on pub.dev.

## 1.0.0

**NOTE:**  
The first major release include some breaking changes, see the [migration guide](https://github.com/droibit/flutter_custom_tabs/blob/1.0.0/flutter_custom_tabs/doc/migration-guides.md#migrate-flutter_custom_tabs-to-v100) for details.

- Migrate to federated plugins([#41](https://github.com/droibit/flutter_custom_tabs/pull/41)).
- Web support([#42](https://github.com/droibit/flutter_custom_tabs/pull/42)).
- Improved customization on iOS([#39](https://github.com/droibit/flutter_custom_tabs/pull/39), [#43](https://github.com/droibit/flutter_custom_tabs/pull/43)).

## 0.7.0

- Migrated to Null Safety([#36](https://github.com/droibit/flutter_custom_tabs/pull/36)).
- Bug Fix : shows black screen while launching in release mode([#37](https://github.com/droibit/flutter_custom_tabs/pull/36)).
- Support Android11.
- Update the dependent `url_launcher` to v6.0.3.

## 0.6.0

- Added HTTP headers option([#13](https://github.com/droibit/flutter_custom_tabs/pull/13))

## 0.5.0

**NOTE:**  
This package only support CustomTabs for **androidx** from v0.5.0.  
If you migrate existing project to androidx see the [official docs](https://developer.android.com/jetpack/androidx/migrate).

- AndroidX support([#11](https://github.com/droibit/flutter_custom_tabs/pull/11))

## 0.4.0

- Fix: Only works with Chrome([#2](https://github.com/droibit/flutter_custom_tabs/issues/2)).

## 0.3.0

- Migrate to dart 2.0 release([#1](https://github.com/droibit/flutter_custom_tabs/pull/1)).

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
