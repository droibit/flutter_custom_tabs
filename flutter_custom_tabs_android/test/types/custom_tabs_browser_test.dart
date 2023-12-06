import 'package:flutter_custom_tabs_android/flutter_custom_tabs_android.dart';
import 'package:flutter_custom_tabs_android/src/messages/messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toMessage() returns empty message when option values are null', () {
    const configuration = CustomTabsBrowserConfiguration();
    final actual = configuration.toMessage();
    expect(actual.prefersDefaultBrowser, isNull);
    expect(actual.fallbackCustomTabs, isNull);
    expect(actual.headers, isNull);
    expect(actual.prefersExternalBrowser, isFalse);
  });

  test('toMessage() returns a message with complete options', () {
    const configuration = CustomTabsBrowserConfiguration(
      prefersDefaultBrowser: true,
      fallbackCustomTabs: [
        'org.mozilla.firefox',
        'com.microsoft.emmx',
      ],
      headers: {'key': 'value'},
    );
    final actual = configuration.toMessage();
    expect(actual.prefersDefaultBrowser, configuration.prefersDefaultBrowser);
    expect(actual.fallbackCustomTabs, configuration.fallbackCustomTabs);
    expect(actual.headers, configuration.headers);
    expect(actual.prefersExternalBrowser, isFalse);
  });

  test('toMessage() returns a message with external browser options', () {
    const configuration = CustomTabsBrowserConfiguration.externalBrowser(
      headers: {'key': 'value'},
    );
    final actual = configuration.toMessage();
    expect(actual.prefersDefaultBrowser, isNull);
    expect(actual.fallbackCustomTabs, isNull);
    expect(actual.headers, configuration.headers);
    expect(actual.prefersExternalBrowser, isTrue);
  });
}
