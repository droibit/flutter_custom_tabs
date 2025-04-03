import 'package:meta/meta.dart';

/// Configuration for Partial Custom Tabs, which allows Custom Tabs to launch in a reduced size view.
///
/// On devices in portrait mode (starting with Chrome 107), partial Custom Tabs can launch
/// as a bottom sheet with adjustable height. Users can expand to full-screen by dragging
/// the toolbar handle up or restore initial height by dragging down.
///
/// On large screens or devices in landscape mode (starting with Chrome 120), partial Custom Tabs
/// can display as a side sheet with configurable width, allowing simultaneous interaction with
/// the underlying app.
///
/// ### See Also
/// - [Partial Custom Tabs](https://developer.chrome.com/docs/android/custom-tabs/guide-partial-custom-tabs/)
@immutable
class PartialCustomTabsConfiguration {
  /// Creates a [PartialCustomTabsConfiguration] instance with the specified options.
  const PartialCustomTabsConfiguration({
    this.initialHeight,
    this.activityHeightResizeBehavior,
    this.initialWidth,
    this.activitySideSheetBreakpoint,
    this.activitySideSheetMaximizationEnabled,
    this.activitySideSheetPosition,
    this.activitySideSheetDecorationType,
    this.activitySideSheetRoundedCornersPosition,
    this.cornerRadius,
    this.backgroundInteractionEnabled,
  });

  /// Creates a [PartialCustomTabsConfiguration] instance optimized for bottom sheet display.
  ///
  /// This constructor configures options specific to bottom sheet presentation,
  /// setting all side sheet properties to null.
  const PartialCustomTabsConfiguration.bottomSheet({
    required this.initialHeight,
    this.activityHeightResizeBehavior,
    this.cornerRadius,
    this.backgroundInteractionEnabled,
  })  : initialWidth = null,
        activitySideSheetBreakpoint = null,
        activitySideSheetMaximizationEnabled = null,
        activitySideSheetPosition = null,
        activitySideSheetDecorationType = null,
        activitySideSheetRoundedCornersPosition = null;

  /// Creates a [PartialCustomTabsConfiguration] instance optimized for side sheet display.
  ///
  /// This constructor configures options specific to side sheet presentation,
  /// setting all bottom sheet properties to null.
  const PartialCustomTabsConfiguration.sideSheet({
    required this.initialWidth,
    this.activitySideSheetBreakpoint,
    this.activitySideSheetMaximizationEnabled,
    this.activitySideSheetPosition,
    this.activitySideSheetDecorationType,
    this.activitySideSheetRoundedCornersPosition,
    this.cornerRadius,
    this.backgroundInteractionEnabled,
  })  : initialHeight = null,
        activityHeightResizeBehavior = null;

  /// Creates a [PartialCustomTabsConfiguration] instance with both bottom and side sheet support.
  const PartialCustomTabsConfiguration.adaptiveSheet({
    required this.initialHeight,
    required this.initialWidth,
    this.activityHeightResizeBehavior,
    this.activitySideSheetBreakpoint,
    this.activitySideSheetMaximizationEnabled,
    this.activitySideSheetPosition,
    this.activitySideSheetDecorationType,
    this.activitySideSheetRoundedCornersPosition,
    this.cornerRadius,
    this.backgroundInteractionEnabled,
  });

  /// The Custom Tab Activity's initial height in logical pixels(dp).
  ///
  /// This value will be clamped between 50% and 100% of screen height. Bottom sheet does
  /// not take effect in landscape mode or in multi-window mode.
  ///
  /// *The minimum partial Custom Tab height is 50% of the screen height.
  final double? initialHeight;

  /// The Custom Tab Activity's desired resize behavior.
  final CustomTabsActivityHeightResizeBehavior? activityHeightResizeBehavior;

  /// The Custom Tab Activity's initial width in logical pixels(dp).
  ///
  /// When set, the Custom Tab can behave as a side sheet on larger screens:
  /// - On compact screens (<600dp): Side sheet won't be displayed
  /// - On medium screens (≥600dp and <840dp): Width between 50%-100% of window width
  /// - On expanded screens (≥840dp): Width between 33%-100% of window width
  ///
  /// Works with [activitySideSheetBreakpoint] to determine side sheet behavior.
  ///
  /// See also:
  /// - [Android Size Classes](https://developer.android.com/guide/topics/large-screens/support-different-screen-sizes#window_size_classes)
  final double? initialWidth;

  /// The Custom Tab Activity's transition breakpoint in logical pixels(dp).
  ///
  /// If screen width > breakpoint: Custom Tab displays as side sheet
  /// If screen width <= breakpoint: Custom Tab displays as bottom sheet
  ///
  /// If not specified, default is 840dp. Values below 600dp are treated as 600dp.
  /// Values between 600dp and 840dp create a responsive behavior based on screen size.
  final double? activitySideSheetBreakpoint;

  /// A Boolean value that determines whether to enable the maximization button on the side sheet Custom Tab toolbar.
  final bool? activitySideSheetMaximizationEnabled;

  /// A value that specifies the position of the side sheet.
  final CustomTabsActivitySideSheetPosition? activitySideSheetPosition;

  /// A value that allows you to set how you want to distinguish the Partial Custom Tab side sheet from the rest of the display.
  final CustomTabsActivitySideSheetDecorationType?
      activitySideSheetDecorationType;

  /// A value that allows you to choose which side sheet corners should be rounded, if any at all.
  final CustomTabsActivitySideSheetRoundedCornersPosition?
      activitySideSheetRoundedCornersPosition;

  /// The toolbar's top corner radius in logical pixels(dp).
  ///
  /// *The maximum corner radius is 16dp(lp).
  final int? cornerRadius;

  /// A Boolean value that determines whether to enable interactions with the background app when a Partial Custom Tab is launched.
  final bool? backgroundInteractionEnabled;
}

/// Desired height behavior for the Partial Custom Tab.
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

/// Specifies the position of the Partial Custom Tab side sheet on the screen.
enum CustomTabsActivitySideSheetPosition {
  /// Applies the default position for the Custom Tab Activity when it behaves as a side sheet.
  defaultPosition(0),

  /// Position the side sheet on the start side of the screen.
  start(1),

  /// Position the side sheet on the end side of the screen.
  end(2);

  @internal
  const CustomTabsActivitySideSheetPosition(this.rawValue);

  @internal
  final int rawValue;
}

/// Defines the visual decoration style for Partial Custom Tabs when displayed as a side sheet.
///
/// This enum allows you to specify how the side sheet should be visually distinguished
/// from the rest of the screen.
enum CustomTabsActivitySideSheetDecorationType {
  /// Side sheet's default decoration type.
  defaultDecoration(0),

  /// Side sheet with no decorations - the activity is not bordered by any shadow or divider line.
  none(1),

  /// TSide sheet with shadow decoration - the activity is bordered by a shadow effect.
  shadow(2),

  /// Side sheet with a divider line - the activity is bordered by a thin opaque line.
  divider(3);

  @internal
  const CustomTabsActivitySideSheetDecorationType(this.rawValue);

  @internal
  final int rawValue;
}

/// Specifies which corners of the Partial Custom Tab side sheet should be rounded.
///
/// This enum allows you to choose which side sheet corners should be rounded, if any at all.
enum CustomTabsActivitySideSheetRoundedCornersPosition {
  /// Side sheet's default rounded corner configuration.
  defaultPosition(0),

  /// Side sheet with no rounded corners.
  none(1),

  /// Side sheet with the inner top corner rounded (if positioned on the right of the screen, this will be the top left corner)
  top(2);

  @internal
  const CustomTabsActivitySideSheetRoundedCornersPosition(this.rawValue);

  @internal
  final int rawValue;
}
