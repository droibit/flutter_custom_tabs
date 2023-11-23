import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SafariViewControllerOptions', () {
    test('toMap() returns empty map when option values are null', () {
      const options = SafariViewControllerOptions();
      expect(options.toMap(), <String, dynamic>{});
    });

    test('toMap() returns a map with complete options', () {
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
  });

  test('DismissButtonStyle returns associated value', () {
    expect(SafariViewControllerDismissButtonStyle.done.rawValue, 0);
    expect(SafariViewControllerDismissButtonStyle.close.rawValue, 1);
    expect(SafariViewControllerDismissButtonStyle.cancel.rawValue, 2);
  });

  test('ViewControllerModalPresentationStyle returns associated value', () {
    expect(ViewControllerModalPresentationStyle.automatic.rawValue, -2);
    expect(ViewControllerModalPresentationStyle.none.rawValue, -1);
    expect(ViewControllerModalPresentationStyle.fullScreen.rawValue, 0);
    expect(ViewControllerModalPresentationStyle.pageSheet.rawValue, 1);
    expect(ViewControllerModalPresentationStyle.formSheet.rawValue, 2);
    expect(ViewControllerModalPresentationStyle.overFullScreen.rawValue, 5);
  });
}
