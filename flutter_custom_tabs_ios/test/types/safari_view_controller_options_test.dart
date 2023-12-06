import 'package:flutter/painting.dart';
import 'package:flutter_custom_tabs_ios/flutter_custom_tabs_ios.dart';
import 'package:flutter_custom_tabs_ios/src/messages/messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SafariViewControllerOptions', () {
    test('toMessage() returns empty message when option values are null', () {
      const options = SafariViewControllerOptions();
      final actual = options.toMessage();
      expect(actual.preferredBarTintColor, isNull);
      expect(actual.preferredControlTintColor, isNull);
      expect(actual.barCollapsingEnabled, isNull);
      expect(actual.entersReaderIfAvailable, isNull);
      expect(actual.dismissButtonStyle, isNull);
      expect(actual.modalPresentationStyle, isNull);
      expect(actual.pageSheet, isNull);
    });

    test('toMessage() returns a message with complete options', () {
      const options = SafariViewControllerOptions(
        preferredBarTintColor: Color(0xFFFFEBEE),
        preferredControlTintColor: Color(0xFFFFFFFF),
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationStyle: ViewControllerModalPresentationStyle.pageSheet,
        pageSheet: SheetPresentationControllerConfiguration(
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

      final actual = options.toMessage();
      expect(actual.preferredBarTintColor, '#ffffebee');
      expect(actual.preferredControlTintColor, '#ffffffff');
      expect(actual.barCollapsingEnabled, options.barCollapsingEnabled);
      expect(actual.entersReaderIfAvailable, options.entersReaderIfAvailable);
      expect(actual.dismissButtonStyle, options.dismissButtonStyle!.rawValue);
      expect(
        actual.modalPresentationStyle,
        options.modalPresentationStyle!.rawValue,
      );
      expect(
        actual.pageSheet,
        isA<SheetPresentationControllerConfigurationMessage>(),
      );

      final expectedPageSheet = options.pageSheet!;
      final actualPageSheet = actual.pageSheet!;
      expect(
        actualPageSheet.detents,
        containsAll([expectedPageSheet.detents.first.rawValue]),
      );
      expect(
        actualPageSheet.largestUndimmedDetentIdentifier,
        expectedPageSheet.largestUndimmedDetentIdentifier!.rawValue,
      );
      expect(
        actualPageSheet.prefersScrollingExpandsWhenScrolledToEdge,
        expectedPageSheet.prefersScrollingExpandsWhenScrolledToEdge,
      );
      expect(
        actualPageSheet.prefersGrabberVisible,
        expectedPageSheet.prefersGrabberVisible,
      );
      expect(
        actualPageSheet.prefersEdgeAttachedInCompactHeight,
        expectedPageSheet.prefersEdgeAttachedInCompactHeight,
      );
      expect(
        actualPageSheet.preferredCornerRadius,
        expectedPageSheet.preferredCornerRadius,
      );
    });
  });

  group('DismissButtonStyle', () {
    test('rawValue returns associated value', () {
      expect(SafariViewControllerDismissButtonStyle.done.rawValue, 0);
      expect(SafariViewControllerDismissButtonStyle.close.rawValue, 1);
      expect(SafariViewControllerDismissButtonStyle.cancel.rawValue, 2);
    });
  });

  group('ViewControllerModalPresentationStyle', () {
    test('rawValue returns associated value', () {
      expect(ViewControllerModalPresentationStyle.automatic.rawValue, -2);
      expect(ViewControllerModalPresentationStyle.none.rawValue, -1);
      expect(ViewControllerModalPresentationStyle.fullScreen.rawValue, 0);
      expect(ViewControllerModalPresentationStyle.pageSheet.rawValue, 1);
      expect(ViewControllerModalPresentationStyle.formSheet.rawValue, 2);
      expect(ViewControllerModalPresentationStyle.overFullScreen.rawValue, 5);
    });
  });
}
