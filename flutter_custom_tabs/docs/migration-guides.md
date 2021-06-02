# Migration Guides

## `flutter_custom_tabs` from v0.x to v1.0.0

flutter_custom_tabs v1.0.0 is the first major release and has been updated to include several breaking changes.
- Migrate to federated plugins
- Improved customization on iOS

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

          