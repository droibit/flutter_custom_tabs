import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_android/src/messages/messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PartialCustomTabsConfiguration', () {
    test('bottomSheet() sets correct properties', () {
      const initialHeight = 300.0;
      const cornerRadius = 15;
      const resizeBehavior = CustomTabsActivityHeightResizeBehavior.adjustable;
      const backgroundInteraction = true;

      const configuration = PartialCustomTabsConfiguration.bottomSheet(
        initialHeight: initialHeight,
        activityHeightResizeBehavior: resizeBehavior,
        cornerRadius: cornerRadius,
        backgroundInteractionEnabled: backgroundInteraction,
      );

      expect(configuration.initialHeight, initialHeight);
      expect(configuration.activityHeightResizeBehavior, resizeBehavior);
      expect(configuration.cornerRadius, cornerRadius);
      expect(configuration.backgroundInteractionEnabled, backgroundInteraction);
      expect(configuration.initialWidth, isNull);
      expect(configuration.activitySideSheetBreakpoint, isNull);
      expect(configuration.activitySideSheetMaximizationEnabled, isNull);
      expect(configuration.activitySideSheetPosition, isNull);
      expect(configuration.activitySideSheetDecorationType, isNull);
      expect(configuration.activitySideSheetRoundedCornersPosition, isNull);
    });

    test('sideSheet() sets correct properties', () {
      const initialWidth = 500.0;
      const cornerRadius = 15;
      const breakpoint = 700.0;
      const maximizationEnabled = true;
      const position = CustomTabsActivitySideSheetPosition.start;
      const decorationType = CustomTabsActivitySideSheetDecorationType.shadow;
      const cornersPosition =
          CustomTabsActivitySideSheetRoundedCornersPosition.top;
      const backgroundInteraction = true;

      const configuration = PartialCustomTabsConfiguration.sideSheet(
        initialWidth: initialWidth,
        activitySideSheetBreakpoint: breakpoint,
        activitySideSheetMaximizationEnabled: maximizationEnabled,
        activitySideSheetPosition: position,
        activitySideSheetDecorationType: decorationType,
        activitySideSheetRoundedCornersPosition: cornersPosition,
        cornerRadius: cornerRadius,
        backgroundInteractionEnabled: backgroundInteraction,
      );

      expect(configuration.initialWidth, initialWidth);
      expect(configuration.activitySideSheetBreakpoint, breakpoint);
      expect(
        configuration.activitySideSheetMaximizationEnabled,
        maximizationEnabled,
      );
      expect(configuration.activitySideSheetPosition, position);
      expect(configuration.activitySideSheetDecorationType, decorationType);
      expect(
        configuration.activitySideSheetRoundedCornersPosition,
        cornersPosition,
      );
      expect(configuration.cornerRadius, cornerRadius);
      expect(configuration.backgroundInteractionEnabled, backgroundInteraction);
      expect(configuration.initialHeight, isNull);
      expect(configuration.activityHeightResizeBehavior, isNull);
    });

    test('adaptiveSheet() sets correct properties', () {
      const initialHeight = 300.0;
      const initialWidth = 500.0;
      const resizeBehavior = CustomTabsActivityHeightResizeBehavior.adjustable;
      const cornerRadius = 15;
      const breakpoint = 700.0;
      const maximizationEnabled = true;
      const position = CustomTabsActivitySideSheetPosition.start;
      const decorationType = CustomTabsActivitySideSheetDecorationType.shadow;
      const cornersPosition =
          CustomTabsActivitySideSheetRoundedCornersPosition.top;
      const backgroundInteraction = true;

      const configuration = PartialCustomTabsConfiguration.adaptiveSheet(
        initialHeight: initialHeight,
        initialWidth: initialWidth,
        activityHeightResizeBehavior: resizeBehavior,
        activitySideSheetBreakpoint: breakpoint,
        activitySideSheetMaximizationEnabled: maximizationEnabled,
        activitySideSheetPosition: position,
        activitySideSheetDecorationType: decorationType,
        activitySideSheetRoundedCornersPosition: cornersPosition,
        cornerRadius: cornerRadius,
        backgroundInteractionEnabled: backgroundInteraction,
      );

      expect(configuration.initialHeight, initialHeight);
      expect(configuration.initialWidth, initialWidth);
      expect(configuration.activityHeightResizeBehavior, resizeBehavior);
      expect(configuration.activitySideSheetBreakpoint, breakpoint);
      expect(
        configuration.activitySideSheetMaximizationEnabled,
        maximizationEnabled,
      );
      expect(configuration.activitySideSheetPosition, position);
      expect(configuration.activitySideSheetDecorationType, decorationType);
      expect(
        configuration.activitySideSheetRoundedCornersPosition,
        cornersPosition,
      );
      expect(configuration.cornerRadius, cornerRadius);
      expect(configuration.backgroundInteractionEnabled, backgroundInteraction);
    });

    test('toMessage() returns expected message with minimum values', () {
      const configuration = PartialCustomTabsConfiguration();
      final actual = configuration.toMessage();
      expect(actual, isEmpty);
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
        'initialHeight': configuration.initialHeight!,
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
