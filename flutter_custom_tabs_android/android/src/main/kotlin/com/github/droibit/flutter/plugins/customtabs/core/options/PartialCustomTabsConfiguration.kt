package com.github.droibit.flutter.plugins.customtabs.core.options

import androidx.annotation.Dimension
import androidx.browser.customtabs.CustomTabsIntent.ActivityHeightResizeBehavior
import androidx.browser.customtabs.CustomTabsIntent.ActivitySideSheetDecorationType
import androidx.browser.customtabs.CustomTabsIntent.ActivitySideSheetPosition
import androidx.browser.customtabs.CustomTabsIntent.ActivitySideSheetRoundedCornersPosition

class PartialCustomTabsConfiguration internal constructor(
  @Dimension(unit = Dimension.DP) val initialHeight: Double?,
  @ActivityHeightResizeBehavior val activityHeightResizeBehavior: Int?,
  @Dimension(unit = Dimension.DP) val initialWidth: Double?,
  @Dimension(unit = Dimension.DP) val activitySideSheetBreakpoint: Double?,
  val activitySideSheetMaximizationEnabled: Boolean?,
  @ActivitySideSheetPosition val activitySideSheetPosition: Int?,
  @ActivitySideSheetDecorationType val activitySideSheetDecorationType: Int?,
  @ActivitySideSheetRoundedCornersPosition val activitySideSheetRoundedCornersPosition: Int?,
  @Dimension(unit = Dimension.DP) val cornerRadius: Int?,
  val backgroundInteractionEnabled: Boolean?,
) {
  class Builder {
    private var initialHeight: Double? = null
    private var activityHeightResizeBehavior: Int? = null
    private var initialWidth: Double? = null
    private var activitySideSheetBreakpoint: Double? = null
    private var activitySideSheetMaximizationEnabled: Boolean? = null
    private var activitySideSheetPosition: Int? = null
    private var activitySideSheetDecorationType: Int? = null
    private var activitySideSheetRoundedCornersPosition: Int? = null
    private var cornerRadius: Int? = null
    private var backgroundInteractionEnabled: Boolean? = null

    fun setOptions(options: Map<String, Any>?): Builder {
      if (options == null) {
        return this
      }

      initialHeight = options[KEY_INITIAL_HEIGHT] as Double?
      activityHeightResizeBehavior =
        (options[KEY_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR] as Long?)?.toInt()
      activityHeightResizeBehavior =
        (options[KEY_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR] as Long?)?.toInt()
      initialWidth = options[KEY_INITIAL_WIDTH] as Double?
      activitySideSheetBreakpoint = options[KEY_ACTIVITY_SIDE_SHEET_BREAKPOINT] as Double?
      activitySideSheetMaximizationEnabled =
        options[KEY_ACTIVITY_SIDE_SHEET_MAXIMIZATION_ENABLED] as Boolean?
      activitySideSheetPosition =
        (options[KEY_ACTIVITY_SIDE_SHEET_POSITION] as Long?)?.toInt()
      activitySideSheetDecorationType =
        (options[KEY_ACTIVITY_SIDE_SHEET_DECORATION_TYPE] as Long?)?.toInt()
      activitySideSheetRoundedCornersPosition =
        (options[KEY_ACTIVITY_SIDE_SHEET_ROUNDED_CORNERS_POSITION] as Long?)?.toInt()
      backgroundInteractionEnabled = options[KEY_BACKGROUND_INTERACTION_ENABLED] as Boolean?
      cornerRadius = (options[KEY_CORNER_RADIUS] as Long?)?.toInt()
      return this
    }

    fun setInitialHeight(@Dimension(unit = Dimension.DP) initialHeight: Double?): Builder {
      this.initialHeight = initialHeight
      return this
    }

    fun setActivityHeightResizeBehavior(
      @ActivityHeightResizeBehavior activityHeightResizeBehavior: Int?
    ): Builder {
      this.activityHeightResizeBehavior = activityHeightResizeBehavior
      return this
    }

    fun setInitialWidth(@Dimension(unit = Dimension.DP) initialWidth: Double?): Builder {
      this.initialWidth = initialWidth
      return this
    }

    fun setActivitySideSheetBreakpoint(
      @Dimension(unit = Dimension.DP) activitySideSheetBreakpoint: Double?
    ): Builder {
      this.activitySideSheetBreakpoint = activitySideSheetBreakpoint
      return this
    }

    fun setActivitySideSheetMaximizationEnabled(activitySideSheetMaximizationEnabled: Boolean?): Builder {
      this.activitySideSheetMaximizationEnabled = activitySideSheetMaximizationEnabled
      return this
    }

    fun setActivitySideSheetPosition(
      @ActivitySideSheetPosition activitySideSheetPosition: Int?
    ): Builder {
      this.activitySideSheetPosition = activitySideSheetPosition
      return this
    }

    fun setActivitySideSheetDecorationType(
      @ActivitySideSheetDecorationType activitySideSheetDecorationType: Int?
    ): Builder {
      this.activitySideSheetDecorationType = activitySideSheetDecorationType
      return this
    }

    fun setCornerRadius(@Dimension(unit = Dimension.DP) cornerRadius: Int?): Builder {
      this.cornerRadius = cornerRadius
      return this
    }

    fun setActivitySideSheetRoundedCornersPosition(
      @ActivitySideSheetRoundedCornersPosition activitySideSheetRoundedCornersPosition: Int?
    ): Builder {
      this.activitySideSheetRoundedCornersPosition = activitySideSheetRoundedCornersPosition
      return this
    }

    fun setBackgroundInteractionEnabled(backgroundInteractionEnabled: Boolean?): Builder {
      this.backgroundInteractionEnabled = backgroundInteractionEnabled
      return this
    }

    fun build() = PartialCustomTabsConfiguration(
      initialHeight = initialHeight,
      activityHeightResizeBehavior = activityHeightResizeBehavior,
      initialWidth = initialWidth,
      activitySideSheetBreakpoint = activitySideSheetBreakpoint,
      activitySideSheetMaximizationEnabled = activitySideSheetMaximizationEnabled,
      activitySideSheetPosition = activitySideSheetPosition,
      activitySideSheetDecorationType = activitySideSheetDecorationType,
      activitySideSheetRoundedCornersPosition = activitySideSheetRoundedCornersPosition,
      cornerRadius = cornerRadius,
      backgroundInteractionEnabled = backgroundInteractionEnabled,
    )

    private companion object {
      private const val KEY_INITIAL_HEIGHT = "initialHeight"
      private const val KEY_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR = "activityHeightResizeBehavior"
      private const val KEY_INITIAL_WIDTH = "initialWidth"
      private const val KEY_ACTIVITY_SIDE_SHEET_BREAKPOINT = "activitySideSheetBreakpoint"
      private const val KEY_ACTIVITY_SIDE_SHEET_MAXIMIZATION_ENABLED =
        "activitySideSheetMaximizationEnabled"
      private const val KEY_ACTIVITY_SIDE_SHEET_POSITION = "activitySideSheetPosition"
      private const val KEY_ACTIVITY_SIDE_SHEET_DECORATION_TYPE =
        "activitySideSheetDecorationType"
      private const val KEY_ACTIVITY_SIDE_SHEET_ROUNDED_CORNERS_POSITION =
        "activitySideSheetRoundedCornersPosition"
      private const val KEY_CORNER_RADIUS = "cornerRadius"
      private const val KEY_BACKGROUND_INTERACTION_ENABLED = "backgroundInteractionEnabled"
    }
  }
}
