import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

/// The Configuration for providing comprehensive options
/// when launching [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) by specifying a URL.
///
/// See also:
/// - [SFSafariViewController.Configuration](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/configuration)
@immutable
class SafariViewControllerOptions {
  /// Creates a [SafariViewControllerOptions] instance with the specified options.
  const SafariViewControllerOptions({
    this.preferredBarTintColor,
    this.preferredControlTintColor,
    this.barCollapsingEnabled,
    this.entersReaderIfAvailable,
    this.dismissButtonStyle,
    this.modalPresentationStyle,
    this.pageSheetConfiguration,
  });

  /// Creates a [SafariViewControllerOptions] instance with page sheet configuration.
  ///
  /// Availability: **iOS15.0+**
  const SafariViewControllerOptions.pageSheet({
    required SheetPresentationControllerConfiguration configuration,
    Color? preferredBarTintColor,
    Color? preferredControlTintColor,
    bool? entersReaderIfAvailable,
    SafariViewControllerDismissButtonStyle? dismissButtonStyle,
  }) : this(
          preferredBarTintColor: preferredBarTintColor,
          preferredControlTintColor: preferredControlTintColor,
          entersReaderIfAvailable: entersReaderIfAvailable,
          dismissButtonStyle: dismissButtonStyle,
          modalPresentationStyle:
              ViewControllerModalPresentationStyle.pageSheet,
          pageSheetConfiguration: configuration,
        );

  /// The color to tint the background of the navigation bar and the toolbar.
  final Color? preferredBarTintColor;

  /// The color to tint the control buttons on the navigation bar and the toolbar.
  final Color? preferredControlTintColor;

  /// A Boolean value that enables the url bar to hide as the user scrolls down the page.
  final bool? barCollapsingEnabled;

  /// A Boolean value that specifies whether Safari should enter Reader mode, if it is available.
  final bool? entersReaderIfAvailable;

  /// Dismiss button style on the navigation bar.
  final SafariViewControllerDismissButtonStyle? dismissButtonStyle;

  /// The presentation style for modal view controllers.
  final ViewControllerModalPresentationStyle? modalPresentationStyle;

  /// The page sheet configuration.
  final SheetPresentationControllerConfiguration? pageSheetConfiguration;

  /// Converts the [SafariViewControllerOptions] instance into a [Map] instance for serialization.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (preferredBarTintColor != null)
        'preferredBarTintColor':
            '#${preferredBarTintColor!.value.toRadixString(16)}',
      if (preferredControlTintColor != null)
        'preferredControlTintColor':
            '#${preferredControlTintColor!.value.toRadixString(16)}',
      if (barCollapsingEnabled != null)
        'barCollapsingEnabled': barCollapsingEnabled,
      if (entersReaderIfAvailable != null)
        'entersReaderIfAvailable': entersReaderIfAvailable,
      if (modalPresentationStyle != null)
        'modalPresentationStyle': modalPresentationStyle!.rawValue,
      if (dismissButtonStyle != null)
        'dismissButtonStyle': dismissButtonStyle!.rawValue,
      if (pageSheetConfiguration != null)
        'pageSheet': pageSheetConfiguration!.toMap(),
    };
  }
}

/// Dismiss button style on the navigation bar of [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller).
///
/// See also:
///
/// - [SFSafariViewController.DismissButtonStyle](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/dismissbuttonstyle)
///
enum SafariViewControllerDismissButtonStyle {
  done(0),
  close(1),
  cancel(2);

  @internal
  const SafariViewControllerDismissButtonStyle(this.rawValue);

  @internal
  final int rawValue;
}

/// A view presentation style in which the presented view covers the screen.
///
/// See also:
///
/// - [UIModalPresentationStyle](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle)
///
enum ViewControllerModalPresentationStyle {
  /// The default presentation style chosen by the system.
  ///
  /// - Availability: **iOS13.0+**
  automatic(-2),

  /// A presentation style that indicates no adaptations should be made.
  none(-1),

  /// A presentation style in which the presented view covers the screen.
  fullScreen(0),

  /// A presentation style that partially covers the underlying content.
  pageSheet(1),

  /// A presentation style that displays the content centered in the screen.
  formSheet(2),

  /// A view presentation style in which the presented view covers the screen.
  overFullScreen(5);

  @internal
  const ViewControllerModalPresentationStyle(this.rawValue);

  @internal
  final int rawValue;
}

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
