import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_android/src/messages/messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PartialCustomTabsConfiguration', () {
    test('toMessage() returns expected message with default values', () {
      const configuration = PartialCustomTabsConfiguration(
        initialHeight: 200,
      );
      final actual = configuration.toMessage();
      expect(actual, <String, Object>{
        'initialHeight': configuration.initialHeight,
        'activityHeightResizeBehavior':
            configuration.activityHeightResizeBehavior.rawValue,
      });
    });

    test('toMessage() returns a message with complete options', () {
      const configuration = PartialCustomTabsConfiguration(
        initialHeight: 300,
        activityHeightResizeBehavior:
            CustomTabsActivityHeightResizeBehavior.adjustable,
        cornerRadius: 15,
      );

      final actual = configuration.toMessage();

      expect(actual, <String, Object?>{
        'initialHeight': configuration.initialHeight,
        'activityHeightResizeBehavior':
            configuration.activityHeightResizeBehavior.rawValue,
        'cornerRadius': configuration.cornerRadius,
      });
    });
  });

  group('CustomTabsActivityHeightResizeBehavior', () {
    test('returns associated value', () {
      expect(
          CustomTabsActivityHeightResizeBehavior.defaultBehavior.rawValue, 0);
      expect(CustomTabsActivityHeightResizeBehavior.adjustable.rawValue, 1);
      expect(CustomTabsActivityHeightResizeBehavior.fixed.rawValue, 2);
    });
  });
}
