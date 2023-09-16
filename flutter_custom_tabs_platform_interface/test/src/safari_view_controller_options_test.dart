import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_platform_interface/flutter_custom_tabs_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('toMap() with empty options', () {
    const options = SafariViewControllerOptions();
    expect(options.toMap(), <String, dynamic>{});
  });

  test('toMap() with full options', () {
    const options = SafariViewControllerOptions(
      preferredBarTintColor: Color(0xFFFFEBEE),
      preferredControlTintColor: Color(0xFFFFFFFF),
      barCollapsingEnabled: true,
      entersReaderIfAvailable: false,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      modalPresentationStyle: ViewControllerModalPresentationStyle.pageSheet,
      pageSheetConfiguration: SheetPresentationControllerConfiguration(
        detents: {
          SheetPresentationControllerDetent.large,
          SheetPresentationControllerDetent.medium,
        },
        largestUndimmedDetentIdentifier:
            SheetPresentationControllerDetent.medium,
        prefersScrollingExpandsWhenScrolledToEdge: true,
        prefersGrabberVisible: false,
        prefersEdgeAttachedInCompactHeight: true,
        preferredCornerRadius: 16,
      ),
    );

    expect(options.toMap(), <String, dynamic>{
      'preferredBarTintColor': '#ffffebee',
      'preferredControlTintColor': '#ffffffff',
      'barCollapsingEnabled': true,
      'entersReaderIfAvailable': false,
      'dismissButtonStyle': 1,
      'modalPresentationStyle': 1,
      'pageSheet': <String, dynamic>{
        'detents': ['large', 'medium'],
        'largestUndimmedDetentIdentifier': 'medium',
        'prefersScrollingExpandsWhenScrolledToEdge': true,
        'prefersGrabberVisible': false,
        'prefersEdgeAttachedInCompactHeight': true,
        'preferredCornerRadius': 16,
      },
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

  test('SheetPresentationControllerDetent.rawValue return associated value',
      () {
    expect(SheetPresentationControllerDetent.large.rawValue, 'large');
    expect(SheetPresentationControllerDetent.medium.rawValue, 'medium');
  });
}
