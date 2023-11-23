import 'package:meta/meta.dart';

/// The enter and exit animations for the custom tab.
///
/// Specify the Resource ID according to the specifications for the Android platform.
/// - For resources within the Android app, use the resource name.
///   - e.g. `slide_up`
/// - For other cases, provide the complete Resource ID with the type 'anim'.
///   - e.g. `android:anim/fade_in`
///
/// See also:
/// - [View animation](https://developer.android.com/guide/topics/resources/animation-resource.html#View)
/// - [getIdentifier](https://developer.android.com/reference/android/content/res/Resources.html#getIdentifier(java.lang.String,%20java.lang.String,%20java.lang.String))
@immutable
class CustomTabsAnimations {
  const CustomTabsAnimations({
    this.startEnter,
    this.startExit,
    this.endEnter,
    this.endExit,
  });

  /// Resource ID of the start "enter" animation for the custom tab.
  final String? startEnter;

  /// Resource ID of the start "exit" animation for the application.
  final String? startExit;

  /// Resource ID of the exit "enter" animation for the application.
  final String? endEnter;

  /// Resource ID of the exit "exit" animation for the custom tab.
  final String? endExit;

  @internal
  Map<String, String> toMap() {
    final dest = <String, String>{};
    if (startEnter != null && startExit != null) {
      dest['startEnter'] = startEnter!;
      dest['startExit'] = startExit!;
    }
    if (endEnter != null && endExit != null) {
      dest['endEnter'] = endEnter!;
      dest['endExit'] = endExit!;
    }
    return dest;
  }
}

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
