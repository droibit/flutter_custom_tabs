import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CustomTabsOptions', () {
    test('toMap() returns empty map when option values are null', () {
      const options = CustomTabsOptions();
      expect(options.toMap(), <String, dynamic>{});
    });

    test('toMap() returns a map with complete options', () {
      const options = CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes(
          colorScheme: CustomTabsColorScheme.system,
          lightParams: CustomTabsColorSchemeParams(
            toolbarColor: Color(0xFFFFEBAA),
            navigationBarColor: Color(0xFFFFEBAB),
            navigationBarDividerColor: Color(0xFFFFEBAC),
          ),
          darkParams: CustomTabsColorSchemeParams(
            toolbarColor: Color(0xFFFFEBBA),
            navigationBarColor: Color(0xFFFFEBBB),
            navigationBarDividerColor: Color(0xFFFFEBBC),
          ),
          defaultPrams: CustomTabsColorSchemeParams(
            toolbarColor: Color(0xFFFFEBCA),
            navigationBarColor: Color(0xFFFFEBCB),
            navigationBarDividerColor: Color(0xFFFFEBCC),
          ),
        ),
        urlBarHidingEnabled: true,
        shareState: CustomTabsShareState.off,
        showTitle: true,
        instantAppsEnabled: false,
        closeButton: CustomTabsCloseButton(
          icon: "icon",
          position: CustomTabsCloseButtonPosition.end,
        ),
        animations: CustomTabsAnimations(
          startEnter: '_startEnter',
          startExit: '_startExit',
          endEnter: '_endEnter',
          endExit: '_endExit',
        ),
        browser: CustomTabsBrowserConfiguration(
          prefersDefaultBrowser: false,
          fallbackCustomTabs: [
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
          headers: {'key': 'value'},
        ),
        partialConfiguration: PartialCustomTabsConfiguration(
          initialHeight: 500,
          activityHeightResizeBehavior:
              CustomTabsActivityHeightResizeBehavior.adjustable,
          cornerRadius: 16,
        ),
      );

      expect(options.toMap(), <String, dynamic>{
        'colorSchemes': <String, dynamic>{
          'colorScheme': 0,
          'lightColorSchemeParams': <String, String>{
            'toolbarColor': '#ffffebaa',
            'navigationBarColor': '#ffffebab',
            'navigationBarDividerColor': '#ffffebac',
          },
          'darkColorSchemeParams': <String, String>{
            'toolbarColor': '#ffffebba',
            'navigationBarColor': '#ffffebbb',
            'navigationBarDividerColor': '#ffffebbc',
          },
          'defaultColorSchemeParams': {
            'toolbarColor': '#ffffebca',
            'navigationBarColor': '#ffffebcb',
            'navigationBarDividerColor': '#ffffebcc',
          },
        },
        'urlBarHidingEnabled': true,
        'shareState': 2,
        'showTitle': true,
        'instantAppsEnabled': false,
        'closeButtonIcon': "icon",
        'closeButtonPosition': 2,
        'animations': <String, String>{
          'startEnter': '_startEnter',
          'startExit': '_startExit',
          'endEnter': '_endEnter',
          'endExit': '_endExit',
        },
        'browser': {
          'prefersDefaultBrowser': false,
          'fallbackCustomTabs': [
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
          'headers': {'key': 'value'},
        },
        'partial': <String, dynamic>{
          'initialHeightDp': 500,
          'activityHeightResizeBehavior': 1,
          'cornerRadiusDp': 16,
        },
      });
    });
  });

  group('CustomTabsAnimations', () {
    test('CustomTabsAnimations toMap() returns a map with complete options',
        () {
      const animations = CustomTabsAnimations(
        startEnter: 'slide_up',
        startExit: 'android:anim/fade_out',
        endEnter: 'android:anim/fade_in',
        endExit: 'slide_down',
      );

      expect(animations.toMap(), <String, String>{
        'startEnter': 'slide_up',
        'startExit': 'android:anim/fade_out',
        'endEnter': 'android:anim/fade_in',
        'endExit': 'slide_down',
      });
    });

    test(
        'CustomTabsAnimations toMap() returns empty map when animation values are null',
        () {
      const animations = CustomTabsAnimations();
      expect(animations.toMap(), <String, String>{});
    });
  });

  group('CustomTabsBottomSheetConfiguration', () {
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

  group('CustomTabsBrowserConfiguration', () {
    test('toMap() returns a map with complete options', () {
      const configuration = CustomTabsBrowserConfiguration(
        prefersDefaultBrowser: true,
        fallbackCustomTabs: [
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
        headers: {'key': 'value'},
      );
      expect(configuration.toMap(), <String, dynamic>{
        'prefersDefaultBrowser': true,
        'fallbackCustomTabs': [
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
        'headers': {'key': 'value'},
      });
    });

    test('toMap() returns empty map when option values are null', () {
      const configuration = CustomTabsBrowserConfiguration();
      expect(configuration.toMap(), <String, dynamic>{});
    });
  });

  test('CustomTabsColorScheme returns associated value', () {
    expect(CustomTabsColorScheme.system.rawValue, 0);
    expect(CustomTabsColorScheme.light.rawValue, 1);
    expect(CustomTabsColorScheme.dark.rawValue, 2);
  });

  test('CustomTabsCloseButtonPosition returns associated value', () {
    expect(CustomTabsCloseButtonPosition.start.rawValue, 1);
    expect(CustomTabsCloseButtonPosition.end.rawValue, 2);
  });

  test('CustomTabsShareState returns associated value', () {
    expect(CustomTabsShareState.browserDefault.rawValue, 0);
    expect(CustomTabsShareState.on.rawValue, 1);
    expect(CustomTabsShareState.off.rawValue, 2);
  });

  test('CustomTabsActivityHeightResizeBehavior returns associated value', () {
    expect(CustomTabsActivityHeightResizeBehavior.defaultBehavior.rawValue, 0);
    expect(CustomTabsActivityHeightResizeBehavior.adjustable.rawValue, 1);
    expect(CustomTabsActivityHeightResizeBehavior.fixed.rawValue, 2);
  });
}
