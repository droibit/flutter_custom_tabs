import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('toMap() empty option', () {
    const option = SafariViewControllerOption();
    expect(option.toMap(), <String, dynamic>{});
  });

  test('toMap() has full option', () {
    const option = SafariViewControllerOption(
      preferredBarTintColor: Color(0xFFFFEBEE),
      preferredControlTintColor: Color(0xFFFFFFFF),
      barCollapsingEnabled: true,
      entersReaderIfAvailable: false,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
    );

    expect(option.toMap(), <String, dynamic>{
      'preferredBarTintColor': '#ffffebee',
      'preferredControlTintColor': '#ffffffff',
      'barCollapsingEnabled': true,
      'entersReaderIfAvailable': false,
      'dismissButtonStyle': 1
    });
  });

  test('DismissButtonStyle.rawValue', () {
    expect(SafariViewControllerDismissButtonStyle.done.rawValue, 0);
    expect(SafariViewControllerDismissButtonStyle.close.rawValue, 1);
    expect(SafariViewControllerDismissButtonStyle.cancel.rawValue, 2);
  });
}
