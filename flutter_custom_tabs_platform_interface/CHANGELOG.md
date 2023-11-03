## 2.0.0-beta

- Launching deep link URL is now supported.
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

- Add interface to manually close a custom tab([#67](https://github.com/droibit/flutter_custom_tabs/pull/67)).

## 1.0.1

- Add an option(`statusBarBrightness`) to specify the brightness of the application status bar for iOS.

## 1.0.0

- Initial release.
