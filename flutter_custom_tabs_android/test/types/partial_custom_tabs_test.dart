import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

import '../messages.dart';

void main() {
  group('PartialCustomTabsConfiguration', () {
    test('toMessage() returns expected message with default values', () {
      const configuration = PartialCustomTabsConfiguration(
        initialHeight: 200,
      );
      final actual = configuration.toMessage();
      expect(actual.initialHeight, configuration.initialHeight);
      expect(
        actual.activityHeightResizeBehavior,
        configuration.activityHeightResizeBehavior.rawValue,
      );
      expect(actual.cornerRadius, isNull);
    });

    test('toMessage() returns a message with complete options', () {
      const configuration = PartialCustomTabsConfiguration(
        initialHeight: 300,
        activityHeightResizeBehavior:
            CustomTabsActivityHeightResizeBehavior.adjustable,
        cornerRadius: 12,
      );
      final actual = configuration.toMessage();
      expect(actual.initialHeight, configuration.initialHeight);
      expect(
        actual.activityHeightResizeBehavior,
        configuration.activityHeightResizeBehavior.rawValue,
      );
      expect(actual.cornerRadius, configuration.cornerRadius);
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
