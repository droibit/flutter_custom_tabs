import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';

/// Option class for customizing appearance of Safari View Controller.
/// **This option applies only on iOS platform.**
///
/// See also:
///
/// * [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
///
@immutable
class SafariViewControllerOption {
  const SafariViewControllerOption(
      {this.preferredBarTintColor,
      this.preferredControlTintColor,
      this.barCollapsingEnabled,
      this.entersReaderIfAvailable,
      this.dismissButtonStyle});

  /// The color to tint the background of the navigation bar and the toolbar.
  /// - Availability: iOS10.0+
  final Color? preferredBarTintColor;

  /// The color to tint the control buttons on the navigation bar and the toolbar.
  /// - Availability: iOS10.0+
  final Color? preferredControlTintColor;

  /// If enabled, collapses the toolbar when the user scrolls down the page.
  /// - Availability: iOS11.0+
  final bool? barCollapsingEnabled;

  /// A value that specifies whether Safari should enter Reader mode, if it is available.
  /// - Availability: iOS11.0+
  final bool? entersReaderIfAvailable;

  /// Dismiss button style on the navigation bar.
  /// - Availability: iOS11.0+
  final SafariViewControllerDismissButtonStyle? dismissButtonStyle;

  Map<String, dynamic> toMap() {
    final dest = <String, dynamic>{};

    if (preferredBarTintColor != null) {
      dest['preferredBarTintColor'] =
          '#${preferredBarTintColor!.value.toRadixString(16)}';
    }
    if (preferredControlTintColor != null) {
      dest['preferredControlTintColor'] =
          '#${preferredControlTintColor!.value.toRadixString(16)}';
    }
    if (barCollapsingEnabled != null) {
      dest['barCollapsingEnabled'] = barCollapsingEnabled;
    }
    if (entersReaderIfAvailable != null) {
      dest['entersReaderIfAvailable'] = entersReaderIfAvailable;
    }
    if (dismissButtonStyle != null) {
      dest['dismissButtonStyle'] = dismissButtonStyle!.rawValue;
    }
    return dest;
  }
}

/// Dismiss button style on the navigation bar of SafariViewController.
enum SafariViewControllerDismissButtonStyle { done, close, cancel }

extension RawValueCompatible on SafariViewControllerDismissButtonStyle {
  @visibleForTesting
  int get rawValue {
    switch (this) {
      case SafariViewControllerDismissButtonStyle.done:
        return 0;
      case SafariViewControllerDismissButtonStyle.close:
        return 1;
      case SafariViewControllerDismissButtonStyle.cancel:
        return 2;
    }
  }
}
