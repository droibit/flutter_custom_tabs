## 2.2.0-dev.2

- Adds new launchers for other Android plugins' Android implementations([#205](https://github.com/droibit/flutter_custom_tabs/pull/205)).
  - Introduces `PartialCustomTabsLauncher`.
  - Introduces `ExternalBrowserLauncher`.
  - Refactors `IntentFactory` to `CustomTabsIntentFactory`.
- Updates `PartialCustomTabsConfiguration` to allow nullable `activityHeightResizeBehavior`([#206](https://github.com/droibit/flutter_custom_tabs/pull/206), [#205](https://github.com/droibit/flutter_custom_tabs/pull/205)).

## 2.2.0-dev.1

- Enhances the plugin reusability and reduce pigeon dependency([#198](https://github.com/droibit/flutter_custom_tabs/pull/198)).

## 2.1.0

- Updates minimum supported SDK version to Flutter 3.10/Dart 3 ([#189](https://github.com/droibit/flutter_custom_tabs/pull/189)).
- Updates minimum required `flutter_custom_tabs_platform_interface` version to 2.1.0.
- Updates minimum required `pigeon` version to 17.0.0 ([#189](https://github.com/droibit/flutter_custom_tabs/pull/189)).
- Removes the `dynamic_color` package from the example to improve maintainability ([#192](https://github.com/droibit/flutter_custom_tabs/pull/192)).
- Update navigationBarColor in `CustomTabsOptions` to use surface instead of deprecated background ([#193](https://github.com/droibit/flutter_custom_tabs/pull/193)).

## 2.0.0+1

- Fixes the LICENSE file.

## 2.0.0

- No changes except for version bump.

## 2.0.0-beta.2

- Supports launching a URL in an external browser ([#157](https://github.com/droibit/flutter_custom_tabs/pull/157)).
- Adopts the [Pigeon](https://pub.dev/packages/pigeon) code generation tool.
- Moves `CustomTabsOptions` from `flutter_custom_tabs_platform_interface` package ([#151](https://github.com/droibit/flutter_custom_tabs/pull/151)).
- Updates CustomTabsLauncher to [v2.0.0-rc01](https://github.com/droibit/CustomTabsLauncher/releases/tag/2.0.0-rc01)([#160](https://github.com/droibit/flutter_custom_tabs/pull/160)).
- Adds unit tests for android platform ([#162](https://github.com/droibit/flutter_custom_tabs/pull/162)).

## 2.0.0-beta.1

- Adds support for prioritizing the default browser over Chrome on Android([#145](https://github.com/droibit/flutter_custom_tabs/pull/145)).
- Updates CustomTabsLauncher to [v2.0.0-beta03](https://github.com/droibit/CustomTabsLauncher/releases/tag/2.0.0-beta03)([#145](https://github.com/droibit/flutter_custom_tabs/pull/145)).
- Suppress deprecated warnings in android implementation([#146](https://github.com/droibit/flutter_custom_tabs/pull/146)).

## 2.0.0-beta+1

- Updates `CustomTabsLauncher` to v2.0.0-beta02 to resolve version conflict of `androidx.browser`([#136](https://github.com/droibit/flutter_custom_tabs/issues/136)).

## 2.0.0-beta

- Initial release of the `flutter_custom_tabs` Android implementation.
