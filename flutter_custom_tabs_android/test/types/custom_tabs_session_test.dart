import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_android/src/messages/messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toMessage() returns empty message when option values are null', () {
    const options = CustomTabsSessionOptions();
    final actual = options.toMessage();
    expect(actual, isEmpty);
  });

  test('toMessage() returns a message with complete options', () {
    const options = CustomTabsSessionOptions(
      prefersDefaultBrowser: true,
      fallbackCustomTabs: [
        'org.mozilla.firefox',
        'com.microsoft.emmx',
      ],
    );
    final actual = options.toMessage();
    expect(actual, <String, Object>{
      'prefersDefaultBrowser': options.prefersDefaultBrowser!,
      'fallbackCustomTabs': options.fallbackCustomTabs!,
    });
  });
}
