## 2.3.1

Adds .editorconfig to for consistent code style.

## 2.3.0

- Adds new options to `CustomTabsOptions`:
  - `bookmarksButtonEnabled`: Controls whether the bookmarks button is shown in the overflow menu.
  - `downloadButtonEnabled`: Controls whether the download button is shown in the overflow menu.
  - `shareIdentityEnabled`: Enables app-specific history, grouping links opened from the app in Chrome's history.
- Adds new options to `PartialCustomTabsConfiguration`:
  - Supports side sheet format for partial Custom Tabs on larger screens.
  - `backgroundInteractionEnabled`: Controls whether interactions with the background app are enabled when a Partial Custom Tab is launched.
- Updates minimum supported SDK version to Flutter 3.19.0/Dart 3.3.
- Updates minimum required `flutter_custom_tabs_platform_interface` version to 2.2.0.
- Updates minimum required `pigeon` version to 22.7.0.

## 2.2.0

- Fixes a bug where default browser preference wasn't properly applied during Custom Tabs warm-up.
- Adds temporary comments to suppress `Color.value` deprecation warnings.
- Improves logging and move TAG constant to appropriate class.
- Adds unit tests for Custom Tabs options classes.
- Updates Android Gradle setup to use the new Flutter Gradle plugin integration.
- Updates CustomTabsLauncher to [v3.0.0](https://github.com/droibit/CustomTabsLauncher/releases/tag/3.0.0) and remove JitPack repository.
- Updates minimum required `flutter_custom_tabs_platform_interface` version to 2.2.0.

## 2.2.0-dev.4

- Kotlinize the android implementation.

## 2.2.0-dev.3

- Implements `warmup`, `mayLaunch`, and `invalidate` methods in `CustomTabsPluginAndroid` for performance optimization.
- Updates minimum supported SDK version to Flutter 3.16.0/Dart 3.2.
- Updates minimum required `flutter_custom_tabs_platform_interface` version to 2.2.0-dev.1.
- Updates minimum required `pigeon` version to 21.1.0.
- Updates minimum required `androidx.browser` version to 1.8.0.
- Updates minimum required `CustomTabsLauncher` to v3.0.0-beta01.

## 2.2.0-dev.2

- Adds new launchers for other Android plugins' Android implementations.
  - Introduces `PartialCustomTabsLauncher`.
  - Introduces `ExternalBrowserLauncher`.
  - Refactors `IntentFactory` to `CustomTabsIntentFactory`.
- Updates `PartialCustomTabsConfiguration` to allow nullable `activityHeightResizeBehavior`.

## 2.2.0-dev.1

- Enhances the plugin reusability and reduce pigeon dependency.

## 2.1.0

- Updates minimum supported SDK version to Flutter 3.10/Dart 3.
- Updates minimum required `flutter_custom_tabs_platform_interface` version to 2.1.0.
- Updates minimum required `pigeon` version to 17.0.0.
- Removes the `dynamic_color` package from the example to improve maintainability.
- Update navigationBarColor in `CustomTabsOptions` to use surface instead of deprecated background.

## 2.0.0+1

- Fixes the LICENSE file.

## 2.0.0

- No changes except for version bump.

## 2.0.0-beta.2

- Supports launching a URL in an external browser.
- Adopts the [Pigeon](https://pub.dev/packages/pigeon) code generation tool.
- Moves `CustomTabsOptions` from `flutter_custom_tabs_platform_interface` package.
- Updates CustomTabsLauncher to [v2.0.0-rc01](https://github.com/droibit/CustomTabsLauncher/releases/tag/2.0.0-rc01).
- Adds unit tests for android platform.

## 2.0.0-beta.1

- Adds support for prioritizing the default browser over Chrome on Android.
- Updates CustomTabsLauncher to [v2.0.0-beta03](https://github.com/droibit/CustomTabsLauncher/releases/tag/2.0.0-beta03).
- Suppress deprecated warnings in android implementation.

## 2.0.0-beta+1

- Updates `CustomTabsLauncher` to v2.0.0-beta02 to resolve version conflict of `androidx.browser`.

## 2.0.0-beta

- Initial release of the `flutter_custom_tabs` Android implementation.
