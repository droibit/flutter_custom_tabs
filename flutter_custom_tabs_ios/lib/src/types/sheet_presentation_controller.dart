import 'package:meta/meta.dart';

/// The configuration to show [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) as a page sheet.
///
/// - Availability: **iOS15.0+**
///
/// See also:
///
/// - [UISheetPresentationController](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller)
@immutable
class SheetPresentationControllerConfiguration {
  const SheetPresentationControllerConfiguration({
    required this.detents,
    this.largestUndimmedDetentIdentifier,
    this.prefersScrollingExpandsWhenScrolledToEdge,
    this.prefersGrabberVisible,
    this.prefersEdgeAttachedInCompactHeight,
    this.preferredCornerRadius,
  });

  /// The set of heights where a sheet can rest.
  final Set<SheetPresentationControllerDetent> detents;

  /// The largest detent that doesn’t dim the view underneath the sheet.
  final SheetPresentationControllerDetent? largestUndimmedDetentIdentifier;

  /// A Boolean value that determines whether scrolling expands the sheet to a larger detent.
  final bool? prefersScrollingExpandsWhenScrolledToEdge;

  /// A Boolean value that determines whether the sheet shows a grabber at the top.
  final bool? prefersGrabberVisible;

  /// A Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class.
  final bool? prefersEdgeAttachedInCompactHeight;

  /// The corner radius that the sheet attempts to present with.
  final double? preferredCornerRadius;

  @internal
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'detents': detents.map((e) => e.rawValue).toList(),
      if (largestUndimmedDetentIdentifier != null)
        'largestUndimmedDetentIdentifier':
            largestUndimmedDetentIdentifier!.rawValue,
      if (prefersScrollingExpandsWhenScrolledToEdge != null)
        'prefersScrollingExpandsWhenScrolledToEdge':
            prefersScrollingExpandsWhenScrolledToEdge,
      if (prefersGrabberVisible != null)
        'prefersGrabberVisible': prefersGrabberVisible,
      if (prefersEdgeAttachedInCompactHeight != null)
        'prefersEdgeAttachedInCompactHeight':
            prefersEdgeAttachedInCompactHeight,
      if (preferredCornerRadius != null)
        'preferredCornerRadius': preferredCornerRadius,
    };
  }
}

/// An object that represents a height where a sheet naturally rests.
enum SheetPresentationControllerDetent {
  /// A system detent for a sheet at full height.
  large("large"),

  /// A system detent for a sheet that’s approximately half the height of the screen, and is inactive in compact height.
  medium("medium");

  @internal
  const SheetPresentationControllerDetent(this.rawValue);

  @internal
  final String rawValue;
}
