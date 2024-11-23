## 2.1.0

- Updates minimum supported SDK version to Flutter 3.10/Dart 3 ([#189](https://github.com/droibit/flutter_custom_tabs/pull/189)).

## 2.0.0

- No changes except for version bump.

## 2.0.0-beta.2

- Adds `PlatformOptions` as a base option for platform packages ([#150](https://github.com/droibit/flutter_custom_tabs/pull/150)).
- Moves `CustomTabsOptions` to `flutter_custom_tabs_android` package plugin ([#151](https://github.com/droibit/flutter_custom_tabs/pull/151)).
- Moves `SafariViewControllerOptions` to `flutter_custom_tabs_ios` package plugin ([#151](https://github.com/droibit/flutter_custom_tabs/pull/151)).

## 2.0.0-beta.1

- Refactors Custom Tabs browser configurations to `CustomTabsBrowserConfiguration` ([#145](https://github.com/droibit/flutter_custom_tabs/pull/145)).
- Adds an option to `CustomTabsBrowserConfiguration` to prioritize the default browser that supports Custom Tabs over Chrome ([#145](https://github.com/droibit/flutter_custom_tabs/pull/145)).

## 2.0.0-beta

- Supports the launch of a deep link URL.
- Renames the `CustomTabsOption` class to `CustomTabsOptions`.
- Updates `CustomTabsOptions` to improve compatibility with Custom Tabs (`androidx.browser`) v1.5.0.
  - Some options have been renamed.
  - Changes the method of specifying colors to `CustomTabsColorSchemes`.
  - Changes the method of specifying share state to `CustomTabsShareState`.
  - Changes the method of specifying the close button to `CustomTabsCloseButton`.
- Adds options for Partial Custom Tabs to `CustomTabsOptions`.
- Renames the `CustomTabsAnimation` class to `CustomTabsAnimations`.
- Renames the `SafariViewControllerOption` class to `SafariViewControllerOptions`.
- Removes the `statusBarBrightness` property from `SafariViewControllerOptions`.
- Updates the minimum supported SDK version to Flutter 3.0.0.

## 1.2.0

- Added `modalPresentationStyle` to `SafariViewControllerOption` to customize the presentation style([#85](https://github.com/droibit/flutter_custom_tabs/pull/85)).

## 1.1.0

- Add interface to manually close a Custom Tab([#67](https://github.com/droibit/flutter_custom_tabs/pull/67)).

## 1.0.1

- Add an option(`statusBarBrightness`) to specify the brightness of the application status bar for iOS.

## 1.0.0

- Initial release.
