import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_android/src/messages/messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PartialCustomTabsConfiguration', () {
    test('toMessage() returns expected message with minimum values', () {
      const configuration = PartialCustomTabsConfiguration(
        initialHeight: 200,
      );
      final actual = configuration.toMessage();
      expect(actual, <String, Object>{
        'initialHeight': configuration.initialHeight,
      });
    });

    test('toMessage() returns a message with complete options', () {
      const configuration = PartialCustomTabsConfiguration(
        initialHeight: 300,
        activityHeightResizeBehavior:
            CustomTabsActivityHeightResizeBehavior.adjustable,
        cornerRadius: 15,
        initialWidth: 500,
        activitySideSheetBreakpoint: 700,
        activitySideSheetMaximizationEnabled: true,
        activitySideSheetPosition: CustomTabsActivitySideSheetPosition.start,
        activitySideSheetDecorationType:
            CustomTabsActivitySideSheetDecorationType.shadow,
        activitySideSheetRoundedCornersPosition:
            CustomTabsActivitySideSheetRoundedCornersPosition.top,
        backgroundInteractionEnabled: true,
      );

      final actual = configuration.toMessage();

      expect(actual, <String, Object>{
        'initialHeight': configuration.initialHeight,
        'activityHeightResizeBehavior':
            configuration.activityHeightResizeBehavior!.rawValue,
        'cornerRadius': configuration.cornerRadius!,
        'initialWidth': configuration.initialWidth!,
        'activitySideSheetBreakpoint':
            configuration.activitySideSheetBreakpoint!,
        'activitySideSheetMaximizationEnabled':
            configuration.activitySideSheetMaximizationEnabled!,
        'activitySideSheetPosition':
            configuration.activitySideSheetPosition!.rawValue,
        'activitySideSheetDecorationType':
            configuration.activitySideSheetDecorationType!.rawValue,
        'activitySideSheetRoundedCornersPosition':
            configuration.activitySideSheetRoundedCornersPosition!.rawValue,
        'backgroundInteractionEnabled':
            configuration.backgroundInteractionEnabled!,
      });
    });
  });

  group('CustomTabsActivityHeightResizeBehavior', () {
    test('returns associated value', () {
      expect(
        CustomTabsActivityHeightResizeBehavior.defaultBehavior.rawValue,
        0,
      );
      expect(CustomTabsActivityHeightResizeBehavior.adjustable.rawValue, 1);
      expect(CustomTabsActivityHeightResizeBehavior.fixed.rawValue, 2);
    });
  });

  group('CustomTabsActivitySideSheetPosition', () {
    test('returns associated value', () {
      expect(CustomTabsActivitySideSheetPosition.defaultPosition.rawValue, 0);
      expect(CustomTabsActivitySideSheetPosition.start.rawValue, 1);
      expect(CustomTabsActivitySideSheetPosition.end.rawValue, 2);
    });
  });

  group('CustomTabsActivitySideSheetDecorationType', () {
    test('returns associated value', () {
      expect(
        CustomTabsActivitySideSheetDecorationType.defaultDecoration.rawValue,
        0,
      );
      expect(CustomTabsActivitySideSheetDecorationType.none.rawValue, 1);
      expect(CustomTabsActivitySideSheetDecorationType.shadow.rawValue, 2);
      expect(CustomTabsActivitySideSheetDecorationType.divider.rawValue, 3);
    });
  });

  group('CustomTabsActivitySideSheetRoundedCornersPosition', () {
    test('returns associated value', () {
      expect(
        CustomTabsActivitySideSheetRoundedCornersPosition
            .defaultPosition.rawValue,
        0,
      );
      expect(
        CustomTabsActivitySideSheetRoundedCornersPosition.none.rawValue,
        1,
      );
      expect(
        CustomTabsActivitySideSheetRoundedCornersPosition.top.rawValue,
        2,
      );
    });
  });
}
