import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTabsCloseButton', () {
    test('toMap() returns a map with complete options', () {
      const button = CustomTabsCloseButton();
      expect(button.toMap(), <String, dynamic>{});
    });

    test('toMap() returns a map with complete options', () {
      const button = CustomTabsCloseButton(
        icon: 'close_icon',
        position: CustomTabsCloseButtonPosition.start,
      );
      expect(button.toMap(), <String, dynamic>{
        'icon': 'close_icon',
        'position': 1,
      });
    });
  });

  group('CustomTabsCloseButtonPosition', () {
    test('returns associated value', () {
      expect(CustomTabsCloseButtonPosition.start.rawValue, 1);
      expect(CustomTabsCloseButtonPosition.end.rawValue, 2);
    });
  });

  group('CustomTabsCloseButtonIcon', () {
    test('back: gets the resource ID of build-in back arrow button icon', () {
      expect(CustomTabsCloseButtonIcon.back, 'fct_ic_arrow_back');
    });
  });
}
