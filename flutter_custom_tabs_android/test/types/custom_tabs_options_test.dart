import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

import '../messages.dart';

void main() {
  group('CustomTabsOptions', () {
    test('toMessage() returns empty message when option values are null', () {
      const options = CustomTabsOptions();
      final actual = options.toMessage();
      expect(actual.colorSchemes, isNull);
      expect(actual.urlBarHidingEnabled, isNull);
      expect(actual.shareState, isNull);
      expect(actual.showTitle, isNull);
      expect(actual.instantAppsEnabled, isNull);
      expect(actual.animations, isNull);
      expect(actual.closeButton, isNull);
      expect(actual.browser, isNull);
      expect(actual.partial, isNull);
    });

    test('toMessage() returns a message with complete options', () {
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
        partial: PartialCustomTabsConfiguration(
          initialHeight: 500,
          activityHeightResizeBehavior:
              CustomTabsActivityHeightResizeBehavior.adjustable,
          cornerRadius: 16,
        ),
      );

      final actual = options.toMessage();
      expect(actual.urlBarHidingEnabled, options.urlBarHidingEnabled);
      expect(actual.shareState, options.shareState!.rawValue);
      expect(actual.showTitle, options.showTitle);
      expect(actual.instantAppsEnabled, options.instantAppsEnabled);
      expect(actual.colorSchemes, isA<CustomTabsColorSchemesMessage>());
      expect(actual.animations, isA<CustomTabsAnimationsMessage>());
      expect(actual.closeButton, isA<CustomTabsCloseButtonMessage>());
      expect(actual.browser, isA<CustomTabsBrowserConfigurationMessage>());
      expect(actual.partial, isA<PartialCustomTabsConfigurationMessage>());

      final actualColorSchemes = actual.colorSchemes!;
      expect(
        actualColorSchemes.colorScheme,
        options.colorSchemes!.colorScheme!.rawValue,
      );
      final actualLightParams = actualColorSchemes.lightParams!;
      expect(actualLightParams.toolbarColor, '#ffffebaa');
      expect(actualLightParams.navigationBarColor, '#ffffebab');
      expect(actualLightParams.navigationBarDividerColor, '#ffffebac');
      final actualDarkParams = actualColorSchemes.darkParams!;
      expect(actualDarkParams.toolbarColor, '#ffffebba');
      expect(actualDarkParams.navigationBarColor, '#ffffebbb');
      expect(actualDarkParams.navigationBarDividerColor, '#ffffebbc');
      final actualDefaultParams = actualColorSchemes.defaultPrams!;
      expect(actualDefaultParams.toolbarColor, '#ffffebca');
      expect(actualDefaultParams.navigationBarColor, '#ffffebcb');
      expect(actualDefaultParams.navigationBarDividerColor, '#ffffebcc');

      final expectedAnimations = options.animations!;
      final actualAnimations = actual.animations!;
      expect(actualAnimations.startEnter, expectedAnimations.startEnter);
      expect(actualAnimations.startExit, expectedAnimations.startExit);
      expect(actualAnimations.endEnter, expectedAnimations.endEnter);
      expect(actualAnimations.endExit, expectedAnimations.endExit);

      final expectedCloseButton = options.closeButton!;
      final actualCloseButton = actual.closeButton!;
      expect(actualCloseButton.icon, expectedCloseButton.icon);
      expect(
        actualCloseButton.position,
        expectedCloseButton.position!.rawValue,
      );

      final expectedBrowser = options.browser!;
      final actualBrowser = actual.browser!;
      expect(
        actualBrowser.prefersDefaultBrowser,
        expectedBrowser.prefersDefaultBrowser,
      );
      expect(
        actualBrowser.fallbackCustomTabs,
        expectedBrowser.fallbackCustomTabs,
      );
      expect(actualBrowser.headers, options.browser!.headers);

      final expectedPartial = options.partial!;
      final actualPartial = actual.partial!;
      expect(actualPartial.initialHeight, expectedPartial.initialHeight);
      expect(
        actualPartial.activityHeightResizeBehavior,
        expectedPartial.activityHeightResizeBehavior.rawValue,
      );
      expect(actualPartial.cornerRadius, expectedPartial.cornerRadius);
    });
  });

  group('CustomTabsShareState', () {
    test('returns associated value', () {
      expect(CustomTabsShareState.browserDefault.rawValue, 0);
      expect(CustomTabsShareState.on.rawValue, 1);
      expect(CustomTabsShareState.off.rawValue, 2);
    });
  });
}
