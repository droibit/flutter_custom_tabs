## 2.2.0-dev.1

- Implements `warmup`, `mayLaunch`, and `invalidate` methods in `CustomTabsPluginIOS` for performance optimization.
- Updates minimum supported SDK version to Flutter 3.16.0/Dart 3.2.
- Updates minimum required `flutter_custom_tabs_platform_interface` version to 2.2.0-dev.1.
- Updates minimum required `pigeon` version to 21.1.0.

## 2.1.0

- Updates minimum supported SDK version to Flutter 3.10/Dart 3.
- Updates minimum required `flutter_custom_tabs_platform_interface` version to 2.1.0.
- Updates minimum required `pigeon` version to 17.0.0.
- Adds privacy manifest.
- Updates the CocoaPods dependency to version 1.15.2.
- Refactor `SFSafariViewController` dismissal handling.

## 2.0.0

- Fixes the LICENSE file.

## 2.0.0-beta.1

- Supports launching a URL in an external browser ([#157](https://github.com/droibit/flutter_custom_tabs/pull/157)).
- Adopts the [Pigeon](https://pub.dev/packages/pigeon) code generation tool.
- Moves `SafariViewControllerOptions` from `flutter_custom_tabs_platform_interface` package ([#151](https://github.com/droibit/flutter_custom_tabs/pull/151)).
- Adds unit tests for iOS platform ([#162](https://github.com/droibit/flutter_custom_tabs/pull/162)).
- Properly callback URL launch results ([#164](https://github.com/droibit/flutter_custom_tabs/pull/164)).

## 2.0.0-beta

- Initial release of the `flutter_custom_tabs` iOS implementation.
