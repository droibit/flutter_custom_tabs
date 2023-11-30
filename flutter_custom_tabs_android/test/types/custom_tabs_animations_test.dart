import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

import '../messages.dart';

void main() {
  group('CustomTabsAnimations', () {
    test('toMessage() returns empty message when animation values are null',
        () {
      const animations = CustomTabsAnimations();
      final actual = animations.toMessage();
      expect(actual.startEnter, isNull);
      expect(actual.startExit, isNull);
      expect(actual.endEnter, isNull);
      expect(actual.endExit, isNull);
    });

    test('toMessage() returns a message with complete options', () {
      const animations = CustomTabsAnimations(
        startEnter: 'slide_up',
        startExit: 'android:anim/fade_out',
        endEnter: 'android:anim/fade_in',
        endExit: 'slide_down',
      );
      final actual = animations.toMessage();
      expect(actual.startEnter, actual.startEnter);
      expect(actual.startExit, animations.startExit);
      expect(actual.endEnter, animations.endEnter);
      expect(actual.endExit, animations.endExit);
    });
  });

  group('CustomTabsSystemAnimations', () {
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
  });
}
