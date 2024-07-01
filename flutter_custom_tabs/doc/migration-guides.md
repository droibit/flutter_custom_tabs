# Migration Guides

## Migrate `flutter_custom_tabs` from v1.x to v2.0.0

The first major update of `flutter_custom_tabs`, v2.0.0, includes a variety of new features and improvements, as well as some breaking changes.

### Breaking Changes

#### API Change: `launch` to `launchUrl`

The `launch` method has been renamed to `launchUrl` for better clarity and consistency. Additionally, there are changes in the naming and types of some parameters:

```diff
-CustomTabsOption? customTabsOption,
+CustomTabsOptions? customTabsOptions,
-SafariViewControllerOption? safariVCOption,
+safariViewControllerOptions? safariVCOptions,
```

New signature:
<table>
<tr>
<td>Before</td><td>After</td>
</tr>
<tr>
<td>

```dart
Future<void> launch(
  String urlString, {
  CustomTabsOption? customTabsOption,
  SafariViewControllerOption? safariVCOption,
}) async;
```

</td>
<td>

```dart
Future<void> launchUrl(
  Uri url, {
  bool prefersDeepLink,
  CustomTabsOptions? customTabsOptions,
  SafariViewControllerOptions? safariVCOptions,
}) async;
```

</td>
</tr>
</table>

Related changes:

- The method `closeAllIfPossible` has been renamed to `closeCustomTabs`.

#### API Changes in `CustomTabsOptions`

The `CustomTabsOptions` class has undergone several changes:

- The customization of various colors, including the toolbar color, has been moved to the `CustomTabsColorSchemes` class.

<table>
<tr>
<td>Before</td><td>After</td>
</tr>
<tr>
<td>

```dart
/// Custom tab toolbar color.
Color? toolbarColor;
```

</td>
<td>

```dart
/// The visualization configuration.
CustomTabsColorSchemes? colorSchemes;
```

</td>
</tr>
</table>

To migrate, use the following equivalent options:
<table>
<tr>
<td>Before</td><td>After</td>
</tr>
<tr>
<td>

```dart
CustomTabsOption(
  toolbarColor: Colors.blue,
)
```

</td>
<td>

```dart
CustomTabsOptions(
  colorSchemes: CustomTabsColorSchemes.defaults(
      toolbarColor: Colors.blue,
      // and newly added the system navigation colors.
      // navigationBarColor: any color
      // navigationBarDividerColor any color
  ),
)
```

</td>
</tr>
</table>

- The method of specifying the share state has changed from `enableDefaultShare` to `shareState`:

| Before | After |
| --- | --- |
| `enableDefaultShare: true` | `shareState: CustomTabsShareState.on` |
| `enableDefaultShare: false` | `shareState: CustomTabsShareState.off` |

- The method of specifying the close button has been changed from `closeButtonPosition` to the enhanced `closeButton`.

To migrate, use the following equivalent options:
<table>
<tr>
<td>Before</td><td>After</td>
</tr>
<tr>
<td>

```dart
CustomTabsOption(
  closeButtonPosition: CustomTabsCloseButtonPosition.end,
)
```

</td>
<td>

```dart
CustomTabsOptions(
  closeButton: CustomTabsCloseButton(
    position: CustomTabsCloseButtonPosition.end,
    // and newly added the button icon.
    // icon: CustomTabsCloseButtonIcons.back,
    // or
    // icon: "DRAWABLE_RESOURCE_ID_IN_YOUR_ANDROID_PROJECT",
  ),
)
```

</td>
</tr>
</table>

The following options for customizing the behavior of Custom Tabs as a browser have been consolidated into `CustomTabsBrowserConfiguration`:

- `headers` property
- `extraCustomTabs` property

The `extraCustomTabs` property has been renamed to `fallbackCustomTabs`.

To migrate, use the following equivalent options:
<table>
<tr>
<td>Before</td><td>After</td>
</tr>
<tr>
<td>

```dart
CustomTabsOption(
  extraCustomTabs: [
    'org.mozilla.firefox',
    'com.microsoft.emmx',    
  ],
  headers: {'key': 'value'},
)
```

</td>
<td>

```dart
CustomTabsOptions(
  browser: CustomTabsBrowserConfiguration(
    fallbackCustomTabs: [
      'org.mozilla.firefox',
      'com.microsoft.emmx',    
    ],
    headers: {'key': 'value'},
  ),
)
```

</td>
</tr>
</table>

Remaining name changes:
| Change Type | Before | After |
| --- | --- | --- |
| Property | `CustomTabsOption.showPageTitle` | `CustomTabsOptions.showTitle` |
| Property | `CustomTabsOption.enableInstantApps` | `CustomTabsOptions.instantAppsEnabled` |
| Class | `CustomTabsAnimation` | `CustomTabsAnimations` |
| Class | `CustomTabsSystemAnimation` | `CustomTabsSystemAnimations` |
| Property | `CustomTabsOption.animation` | `CustomTabsOptions.animations` |

#### API Changes in `SafariViewControllerOptions`

- The property `statusBarBrightness` has been deleted.

#### Lightweight `flutter_custom_tabs`

`flutter_custom_tabs` provides a rich set of customization options for Custom Tabs, but sometimes a minimal appearance customization is enough.
The newly introduced `LaunchOptions` provides unified and simple options for Android/iOS.

Start by importing the library file:

```diff
-import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
+import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart';
```

Finally, use `LaunchOptions` to launch a URL.  
(The following URL launch results in the same outcome):
<table>
<tr>
<td>Before</td><td>After</td>
</tr>
<tr>
<td>

```dart
final theme = ...;
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
```

</td>
<td>

```dart
final theme = ...;
await launchUrl(
  Uri.parse('https://flutter.dev'),
  options: LaunchOptions(
    barColor: theme.colorScheme.surface,
    onBarColor: theme.colorScheme.onSurface,
    barFixingEnabled: false,
  ),
);
```

</td>
</tr>
</table>

## Migrate `flutter_custom_tabs` to v1.0.0

flutter_custom_tabs v1.0.0 is the first major release and has been updated to include several breaking changes.

- Migrate to federated plugins
- Improved customization on iOS
- Web support

### API Changes

- `launch` function now accepts two options.
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

- The built-in animation for CustomTabs `CustomTabsAnimation` is now `CustomTabsSystemAnimation`
  - This clarifies the use of OS-supplied animations via plug-ins.

```diff
customTabsOption: CustomTabsOption(
-    animation: CustomTabsAnimation.slideIn(),
+    animation: CustomTabsSystemAnimation.slideIn(),
)
```
