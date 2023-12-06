import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  swiftOut: 'ios/Classes/messages.g.swift',
  dartOut: 'lib/src/messages/messages.g.dart',
))
@HostApi()
abstract class CustomTabsApi {
  @async
  @SwiftFunction('launchURL(_:prefersDeepLink:options:)')
  void launch(
    String urlString, {
    required bool prefersDeepLink,
    SafariViewControllerOptionsMessage? options,
  });

  void closeAllIfPossible();
}

class SafariViewControllerOptionsMessage {
  const SafariViewControllerOptionsMessage({
    this.preferredBarTintColor,
    this.preferredControlTintColor,
    this.barCollapsingEnabled,
    this.entersReaderIfAvailable,
    this.dismissButtonStyle,
    this.modalPresentationStyle,
    this.pageSheet,
  });

  final String? preferredBarTintColor;
  final String? preferredControlTintColor;
  final bool? barCollapsingEnabled;
  final bool? entersReaderIfAvailable;
  final int? dismissButtonStyle;
  final int? modalPresentationStyle;
  final SheetPresentationControllerConfigurationMessage? pageSheet;
}

class SheetPresentationControllerConfigurationMessage {
  const SheetPresentationControllerConfigurationMessage({
    required this.detents,
    this.largestUndimmedDetentIdentifier,
    this.prefersScrollingExpandsWhenScrolledToEdge,
    this.prefersGrabberVisible,
    this.prefersEdgeAttachedInCompactHeight,
    this.preferredCornerRadius,
  });

  final List<String?> detents;
  final String? largestUndimmedDetentIdentifier;
  final bool? prefersScrollingExpandsWhenScrolledToEdge;
  final bool? prefersGrabberVisible;
  final bool? prefersEdgeAttachedInCompactHeight;
  final double? preferredCornerRadius;
}
