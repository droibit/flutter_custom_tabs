import 'package:flutter/painting.dart';

import 'types/types.dart';
import 'messages.g.dart';

extension SafariViewControllerOptionsConverter on SafariViewControllerOptions {
  SafariViewControllerOptionsMessage toMessage() {
    return SafariViewControllerOptionsMessage(
      preferredBarTintColor: preferredBarTintColor?.toHexString(),
      preferredControlTintColor: preferredControlTintColor?.toHexString(),
      barCollapsingEnabled: barCollapsingEnabled,
      entersReaderIfAvailable: entersReaderIfAvailable,
      dismissButtonStyle: dismissButtonStyle?.rawValue,
      modalPresentationStyle: modalPresentationStyle?.rawValue,
      pageSheet: pageSheet?.toMessage(),
    );
  }
}

extension SheetPresentationControllerConfigurationConverter
    on SheetPresentationControllerConfiguration {
  SheetPresentationControllerConfigurationMessage toMessage() {
    return SheetPresentationControllerConfigurationMessage(
      detents: detents.map((e) => e.rawValue).toList(),
      largestUndimmedDetentIdentifier:
          largestUndimmedDetentIdentifier?.rawValue,
      prefersScrollingExpandsWhenScrolledToEdge:
          prefersScrollingExpandsWhenScrolledToEdge,
      prefersGrabberVisible: prefersGrabberVisible,
      prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
      preferredCornerRadius: preferredCornerRadius,
    );
  }
}

extension _StringConveter on Color {
  String toHexString() {
    return '#${value.toRadixString(16)}';
  }
}
