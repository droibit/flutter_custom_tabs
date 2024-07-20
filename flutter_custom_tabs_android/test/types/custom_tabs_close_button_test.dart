import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_android/src/messages/messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTabsCloseButton', () {
    test('toMessage() returns empty message when option values are null', () {
      const button = CustomTabsCloseButton();
      final actual = button.toMessage();
      expect(actual, isEmpty);
    });

    test('toMessage() returns a message with complete options', () {
      const button = CustomTabsCloseButton(
        icon: 'close_icon',
        position: CustomTabsCloseButtonPosition.start,
      );
      final actual = button.toMessage();
      expect(actual, <String, Object?>{
        'icon': button.icon,
        'position': button.position!.rawValue,
      });
    });
  });

  group('CustomTabsCloseButtonPosition', () {
    test('returns associated value', () {
      expect(CustomTabsCloseButtonPosition.start.rawValue, 1);
      expect(CustomTabsCloseButtonPosition.end.rawValue, 2);
    });
  });

  group('CustomTabsCloseButtonIcons', () {
    test('back: gets the resource ID of build-in back arrow button icon', () {
      expect(CustomTabsCloseButtonIcons.back, 'fct_ic_arrow_back');
    });
  });
}
