import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';

/// Build-in enter and exit animations for Custom Tabs.
class CustomTabsSystemAnimations {
  /// Creates a built-in slide in animation.
  static CustomTabsAnimations slideIn() {
    _slideIn ??= const CustomTabsAnimations(
      startEnter: 'android:anim/slide_in_right',
      startExit: 'android:anim/slide_out_left',
      endEnter: 'android:anim/slide_in_left',
      endExit: 'android:anim/slide_out_right',
    );
    return _slideIn!;
  }

  /// Creates a built-in fade animation.
  static CustomTabsAnimations fade() {
    _fade ??= const CustomTabsAnimations(
      startEnter: 'android:anim/fade_in',
      startExit: 'android:anim/fade_out',
      endEnter: 'android:anim/fade_in',
      endExit: 'android:anim/fade_out',
    );
    return _fade!;
  }

  static CustomTabsAnimations? _slideIn;

  static CustomTabsAnimations? _fade;
}
