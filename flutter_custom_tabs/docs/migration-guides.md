# Migration Guides

## Migrate `flutter_custom_tabs` from v1.x to v2.0.0
The first major update of `flutter_custom_tabs`, v2.0.0, includes a variety of new features and improvements, as well as some breaking changes.

### Breaking Changes

#### API Change: `launch` to `launchUrl`
The `launch` method has been renamed to `launchUrl` for better clarity and consistency. Additionally, there are changes in the naming and types of some parameters:
- `CustomTabsOption` class has been renamed to `CustomTabsOptions`.
- The argument name `customTabsOption` has been renamed to `customTabsOptions`.
- `SafariViewControllerOption` class has been renamed to SafariViewControllerOptions.
- The argument name `safariVCOption` has been renamed to `safariVCOptions`.

```dart
// Before:
Future<void> launch(
  String urlString, {
  CustomTabsOption? customTabsOption,
  SafariViewControllerOption? safariVCOption,
}) async;

// After:
Future<void> launchUrl(
  Uri url, {
  CustomTabsOptions? customTabsOptions,
  SafariViewControllerOptions? safariVCOptions,
}) async;
```

#### API Changes in `CustomTabsOptions`

The `CustomTabsOptions` class has undergone several changes:
- The customization of various colors, including the toolbar color, has been moved to the `CustomTabsColorSchemes` class. The new structure is as follows:

```dart
// Before:
class CustomTabsOption {
  /// Custom tab toolbar color.
  final Color? toolbarColor;
  // ...  
}

// After:
class CustomTabsOptions {
  /// The visualization configuration.
  final CustomTabsColorSchemes? colorSchemes;
  // ...
}
```

To migrate, use the following equivalent options for customizing the toolbar color:
```dart
// Before
CustomTabsOption(
  toolbarColor: Colors.blue,
)

// After
CustomTabsOptions(
  colorSchemes: CustomTabsColorSchemes.defaults(
      toolbarColor: Colors.blue,
  ),
)
```

- The method for setting the share state has changed from `enableDefaultShare` to `shareState`:


```dart
// Before:
CustomTabsOption(
  enableDefaultShare: true,
  // or
  enableDefaultShare: false,
)

// After:
CustomTabsOptions(
  shareState: CustomTabsShareState.on,
  // or
  shareState: CustomTabsShareState.off,
)
```

- The property `showPageTitle` has been renamed to `showTitle`.
- The property `enableInstantApps` has been renamed to `instantAppsEnabled`.
- The `CustomTabsAnimation` class has been renamed to `CustomTabsAnimations`, and the property name has been changed from `animation` to `animations`.
- The `CustomTabsSystemAnimation` class has been renamed to `CustomTabsSystemAnimations`.

#### Lightweight `flutter_custom_tabs`

> **Note**
> This is an experimental feature in the pre-release phase of v2.0.0.

`flutter_custom_tabs` provides a rich set of customization options for Custom Tabs, but sometimes a minimal appearance customization is enough.  
The newly introduced `LaunchOptions` provides unified and simple options for Android/iOS.

Start by importing the library file:
```diff
-import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
+import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart';
```

Finally, use `LaunchOptions` to launch a URL.  
(The following URL launch results in the same outcome):

```dart
final theme = ...;
// Before:
await launch(
  'https://flutter.dev',
  customTabsOptions: CustomTabsOptions(
    toolbarColor: theme.colorScheme.surface,
    enableDefaultShare: true,
    enableUrlBarHiding: true,
    showTitle: true,
  ),                    
  safariVCOptions: SafariViewControllerOptions(
    preferredBarTintColor: theme.colorScheme.surface,
    preferredControlTintColor: theme.colorScheme.onSurface,
    barCollapsingEnabled: true,
  ),
);

// After:
await launchUrl(
  Uri.parse('https://flutter.dev'),
  options: LaunchOptions(
    barColor: theme.colorScheme.surface,
    onBarColor: theme.colorScheme.onSurface,
    appBarFixed: false,
  ),
);
```

## Migrate `flutter_custom_tabs` to v1.0.0

flutter_custom_tabs v1.0.0 is the first major release and has been updated to include several breaking changes.
- Migrate to federated plugins
- Improved customization on iOS
- Web support

### API Changes
* `launch` function now accepts two options.
  - `customTabsOption`: for Android(optional)
  - `safariVCOption`: for iOS(optional)

```diff
await launch(
    'https://flutter.dev',
-    option
+    customTabsOption: CustomTabsOption(),
+    safariVCOption: SafariViewControllerOption(),
);
```  

* The built-in animation for CustomTabs `CustomTabsAnimation` is now `CustomTabsSystemAnimation`
  - This clarifies the use of OS-supplied animations via plug-ins.

```diff
customTabsOption: CustomTabsOption(
-    animation: CustomTabsAnimation.slideIn(),
+    animation: CustomTabsSystemAnimation.slideIn(),
)
```
