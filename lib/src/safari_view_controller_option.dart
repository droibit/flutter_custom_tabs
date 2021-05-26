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
  SafariViewControllerOption({
    this.preferredBarTintColor,
    this.preferredControlTintColor,
    this.barCollapsingEnabled,
    this.entersReaderIfAvailable,
  });

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
    return dest;
  }
}
