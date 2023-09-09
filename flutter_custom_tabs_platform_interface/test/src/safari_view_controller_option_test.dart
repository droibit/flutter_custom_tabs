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
      modalPresentationStyle: ViewControllerModalPresentationStyle.automatic,
    );

    expect(option.toMap(), <String, dynamic>{
      'preferredBarTintColor': '#ffffebee',
      'preferredControlTintColor': '#ffffffff',
      'barCollapsingEnabled': true,
      'entersReaderIfAvailable': false,
      'dismissButtonStyle': 1,
      'modalPresentationStyle': -2,
    });
  });

  test('DismissButtonStyle.rawValue return associated value', () {
    expect(SafariViewControllerDismissButtonStyle.done.rawValue, 0);
    expect(SafariViewControllerDismissButtonStyle.close.rawValue, 1);
    expect(SafariViewControllerDismissButtonStyle.cancel.rawValue, 2);
  });

  test('ViewControllerModalPresentationStyle.rawValue return associated value',
      () {
    expect(ViewControllerModalPresentationStyle.automatic.rawValue, -2);
    expect(ViewControllerModalPresentationStyle.none.rawValue, -1);
    expect(ViewControllerModalPresentationStyle.fullScreen.rawValue, 0);
    expect(ViewControllerModalPresentationStyle.pageSheet.rawValue, 1);
    expect(ViewControllerModalPresentationStyle.formSheet.rawValue, 2);
    expect(ViewControllerModalPresentationStyle.overFullScreen.rawValue, 5);
  });
}
