import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

/// Build in enter and exit animations for Custom Tabs.
class CustomTabsSystemAnimation {
  /// Create a built-in slide in animation.
  static CustomTabsAnimation slideIn() {
    _slideIn ??= const CustomTabsAnimation(
      startEnter: 'android:anim/slide_in_right',
      startExit: 'android:anim/slide_out_left',
      endEnter: 'android:anim/slide_in_left',
      endExit: 'android:anim/slide_out_right',
    );
    return _slideIn!;
  }

  /// Create a built-in fade animation.
  static CustomTabsAnimation fade() {
    _fade ??= const CustomTabsAnimation(
      startEnter: 'android:anim/fade_in',
      startExit: 'android:anim/fade_out',
      endEnter: 'android:anim/fade_in',
      endExit: 'android:anim/fade_out',
    );
    return _fade!;
  }

  static CustomTabsAnimation? _slideIn;

  static CustomTabsAnimation? _fade;
}
