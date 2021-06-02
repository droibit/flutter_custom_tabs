import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('toMap() with empty option', () {
    const option = SafariViewControllerOption();
    expect(option.toMap(), <String, dynamic>{});
  });

  test('toMap() with full option', () {
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

  test('DismissButtonStyle.rawValue return associated value', () {
    expect(SafariViewControllerDismissButtonStyle.done.rawValue, 0);
    expect(SafariViewControllerDismissButtonStyle.close.rawValue, 1);
    expect(SafariViewControllerDismissButtonStyle.cancel.rawValue, 2);
  });
}
