import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('slideIn: creates the built-in slide in animation', () {
    expect(
      CustomTabsSystemAnimations.slideIn(),
      const CustomTabsAnimations(
        startEnter: 'android:anim/slide_in_right',
        startExit: 'android:anim/slide_out_left',
        endEnter: 'android:anim/slide_in_left',
        endExit: 'android:anim/slide_out_right',
      ),
    );
  });

  test('fade: creates the built-in fade animation', () {
    expect(
      CustomTabsSystemAnimations.fade(),
      const CustomTabsAnimations(
        startEnter: 'android:anim/fade_in',
        startExit: 'android:anim/fade_out',
        endEnter: 'android:anim/fade_in',
        endExit: 'android:anim/fade_out',
      ),
    );
  });
}
