import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PartialCustomTabsConfiguration', () {
    test('toMap() returns a map with complete options', () {
      const configuration = PartialCustomTabsConfiguration(
        initialHeight: 300,
        activityHeightResizeBehavior:
            CustomTabsActivityHeightResizeBehavior.adjustable,
        cornerRadius: 12,
      );
      expect(configuration.toMap(), <String, dynamic>{
        'initialHeightDp': 300,
        'activityHeightResizeBehavior': 1,
        'cornerRadiusDp': 12,
      });
    });

    test('toMap() returns expected a map with default values', () {
      const configuration = PartialCustomTabsConfiguration(
        initialHeight: 200,
      );
      expect(configuration.toMap(), <String, dynamic>{
        'initialHeightDp': 200,
        'activityHeightResizeBehavior': 0,
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
