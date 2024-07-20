import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_android/src/messages/messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTabsAnimations', () {
    test('toMessage() returns empty message when animation values are null',
        () {
      const animations = CustomTabsAnimations();
      final actual = animations.toMessage();
      expect(actual, isEmpty);
    });

    test('toMessage() returns a message with complete options', () {
      const animations = CustomTabsAnimations(
        startEnter: 'slide_up',
        startExit: 'android:anim/fade_out',
        endEnter: 'android:anim/fade_in',
        endExit: 'slide_down',
      );
      final actual = animations.toMessage();
      expect(actual, <String, String>{
        'startEnter': animations.startEnter!,
        'startExit': animations.startExit!,
        'endEnter': animations.endEnter!,
        'endExit': animations.endExit!,
      });
    });
  });

  group('CustomTabsSystemAnimations', () {
    test('slideIn: creates the built-in slide in animation', () {
      final actual = CustomTabsSystemAnimations.slideIn().toMessage();
      expect(
        actual,
        <String, String>{
          'startEnter': 'android:anim/slide_in_right',
          'startExit': 'android:anim/slide_out_left',
          'endEnter': 'android:anim/slide_in_left',
          'endExit': 'android:anim/slide_out_right',
        },
      );
    });

    test('fade: creates the built-in fade animation', () {
      final actual = CustomTabsSystemAnimations.fade().toMessage();
      expect(actual, <String, String>{
        'startEnter': 'android:anim/fade_in',
        'startExit': 'android:anim/fade_out',
        'endEnter': 'android:anim/fade_in',
        'endExit': 'android:anim/fade_out',
      });
    });
  });
}
