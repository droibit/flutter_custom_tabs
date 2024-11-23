import 'package:meta/meta.dart';

/// The configuration for [Partial Custom Tabs](https://developer.chrome.com/docs/android/custom-tabs/guide-partial-custom-tabs/).
@immutable
class PartialCustomTabsConfiguration {
  const PartialCustomTabsConfiguration({
    required this.initialHeight,
    this.activityHeightResizeBehavior,
    this.cornerRadius,
  });

  /// The Custom Tab Activity's initial height.
  ///
  /// *The minimum partial Custom Tab height is 50% of the screen height.
  final double initialHeight;

  /// The Custom Tab Activity's desired resize behavior.
  final CustomTabsActivityHeightResizeBehavior? activityHeightResizeBehavior;

  /// The toolbar's top corner radius.
  ///
  /// *The maximum corner radius is 16dp(lp).
  final int? cornerRadius;
}

/// Desired height behavior for the Custom Tab.
enum CustomTabsActivityHeightResizeBehavior {
  /// Applies the default height resize behavior for the Custom Tab Activity when it behaves as a bottom sheet.
  defaultBehavior(0),

  /// The Custom Tab Activity, when it behaves as a bottom sheet, can have its height manually resized by the user.
  adjustable(1),

  /// The Custom Tab Activity, when it behaves as a bottom sheet, cannot have its height manually resized by the user.
  fixed(2);

  @internal
  const CustomTabsActivityHeightResizeBehavior(this.rawValue);

  @internal
  final int rawValue;
}
