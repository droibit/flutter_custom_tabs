package com.github.droibit.flutter.plugins.customtabs.core.options

import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_ADJUSTABLE
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_DEFAULT
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_FIXED
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_SIDE_SHEET_DECORATION_TYPE_DEFAULT
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_SIDE_SHEET_POSITION_END
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_SIDE_SHEET_ROUNDED_CORNERS_POSITION_TOP
import com.google.common.truth.Truth.assertThat
import org.junit.Test

class PartialCustomTabsConfigurationBuilderTest {
    @Test
    fun setOptions_withAllOptions() {
        val options = mapOf(
            "initialHeight" to 0.8,
            "activityHeightResizeBehavior" to ACTIVITY_HEIGHT_FIXED.toLong(),
            "initialWidth" to 0.5,
            "activitySideSheetBreakpoint" to 0.7,
            "activitySideSheetMaximizationEnabled" to true,
            "activitySideSheetPosition" to ACTIVITY_SIDE_SHEET_POSITION_END.toLong(),
            "activitySideSheetDecorationType" to ACTIVITY_SIDE_SHEET_DECORATION_TYPE_DEFAULT.toLong(),
            "activitySideSheetRoundedCornersPosition" to ACTIVITY_SIDE_SHEET_ROUNDED_CORNERS_POSITION_TOP.toLong(),
            "cornerRadius" to 8.toLong(),
            "backgroundInteractionEnabled" to false
        )

        val config = PartialCustomTabsConfiguration.Builder()
            .setOptions(options)
            .build()

        assertThat(config.initialHeight).isEqualTo(0.8)
        assertThat(config.activityHeightResizeBehavior).isEqualTo(ACTIVITY_HEIGHT_FIXED)
        assertThat(config.initialWidth).isEqualTo(0.5)
        assertThat(config.activitySideSheetBreakpoint).isEqualTo(0.7)
        assertThat(config.activitySideSheetMaximizationEnabled).isTrue()
        assertThat(config.activitySideSheetPosition).isEqualTo(ACTIVITY_SIDE_SHEET_POSITION_END)
        assertThat(config.activitySideSheetDecorationType).isEqualTo(
            ACTIVITY_SIDE_SHEET_DECORATION_TYPE_DEFAULT
        )
        assertThat(config.activitySideSheetRoundedCornersPosition).isEqualTo(
            ACTIVITY_SIDE_SHEET_ROUNDED_CORNERS_POSITION_TOP
        )
        assertThat(config.cornerRadius).isEqualTo(8)
        assertThat(config.backgroundInteractionEnabled).isFalse()
    }

    @Test
    fun setOptions_withPartialOptions() {
        val options = mapOf(
            "initialHeight" to 0.5,
            "cornerRadius" to 16.toLong(),
            "backgroundInteractionEnabled" to true
        )
        val config = PartialCustomTabsConfiguration.Builder()
            .setOptions(options)
            .build()

        assertThat(config.initialHeight).isEqualTo(0.5)
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.initialWidth).isNull()
        assertThat(config.activitySideSheetBreakpoint).isNull()
        assertThat(config.activitySideSheetMaximizationEnabled).isNull()
        assertThat(config.activitySideSheetPosition).isNull()
        assertThat(config.cornerRadius).isEqualTo(16)
        assertThat(config.backgroundInteractionEnabled).isTrue()
    }

    @Test
    fun setOptions_withEmptyMap() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setOptions(emptyMap())
            .build()

        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.initialWidth).isNull()
        assertThat(config.activitySideSheetBreakpoint).isNull()
        assertThat(config.activitySideSheetMaximizationEnabled).isNull()
        assertThat(config.activitySideSheetPosition).isNull()
        assertThat(config.cornerRadius).isNull()
        assertThat(config.backgroundInteractionEnabled).isNull()
    }

    @Test
    fun setOptions_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setOptions(null)
            .build()

        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.initialWidth).isNull()
        assertThat(config.activitySideSheetBreakpoint).isNull()
        assertThat(config.activitySideSheetMaximizationEnabled).isNull()
        assertThat(config.activitySideSheetPosition).isNull()
        assertThat(config.cornerRadius).isNull()
        assertThat(config.backgroundInteractionEnabled).isNull()
    }

    @Test
    fun setInitialHeight_withValidValue() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setInitialHeight(0.7)
            .build()

        assertThat(config.initialHeight).isEqualTo(0.7)
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.cornerRadius).isNull()
    }

    @Test
    fun setInitialHeight_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setInitialHeight(null)
            .build()

        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.cornerRadius).isNull()
    }

    @Test
    fun setActivityHeightResizeBehavior_withValidValue() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivityHeightResizeBehavior(ACTIVITY_HEIGHT_DEFAULT)
            .build()

        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isEqualTo(ACTIVITY_HEIGHT_DEFAULT)
        assertThat(config.cornerRadius).isNull()
    }

    @Test
    fun setActivityHeightResizeBehavior_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivityHeightResizeBehavior(null)
            .build()

        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.cornerRadius).isNull()
    }

    @Test
    fun setInitialWidth_withValidValue() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setInitialWidth(0.6)
            .build()

        assertThat(config.initialWidth).isEqualTo(0.6)
        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isNull()
    }

    @Test
    fun setInitialWidth_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setInitialWidth(null)
            .build()

        assertThat(config.initialWidth).isNull()
    }

    @Test
    fun setActivitySideSheetBreakpoint_withValidValue() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivitySideSheetBreakpoint(0.75)
            .build()

        assertThat(config.activitySideSheetBreakpoint).isEqualTo(0.75)
    }

    @Test
    fun setActivitySideSheetBreakpoint_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivitySideSheetBreakpoint(null)
            .build()

        assertThat(config.activitySideSheetBreakpoint).isNull()
    }

    @Test
    fun setActivitySideSheetMaximizationEnabled_withValidValue() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivitySideSheetMaximizationEnabled(true)
            .build()

        assertThat(config.activitySideSheetMaximizationEnabled).isTrue()
    }

    @Test
    fun setActivitySideSheetMaximizationEnabled_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivitySideSheetMaximizationEnabled(null)
            .build()

        assertThat(config.activitySideSheetMaximizationEnabled).isNull()
    }

    @Test
    fun setActivitySideSheetPosition_withValidValue() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivitySideSheetPosition(ACTIVITY_SIDE_SHEET_POSITION_END)
            .build()

        assertThat(config.activitySideSheetPosition).isEqualTo(ACTIVITY_SIDE_SHEET_POSITION_END)
    }

    @Test
    fun setActivitySideSheetPosition_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivitySideSheetPosition(null)
            .build()

        assertThat(config.activitySideSheetPosition).isNull()
    }

    @Test
    fun setActivitySideSheetDecorationType_withValidValue() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivitySideSheetDecorationType(ACTIVITY_SIDE_SHEET_DECORATION_TYPE_DEFAULT)
            .build()

        assertThat(config.activitySideSheetDecorationType).isEqualTo(
            ACTIVITY_SIDE_SHEET_DECORATION_TYPE_DEFAULT
        )
    }

    @Test
    fun setActivitySideSheetDecorationType_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivitySideSheetDecorationType(null)
            .build()

        assertThat(config.activitySideSheetDecorationType).isNull()
    }

    @Test
    fun setActivitySideSheetRoundedCornersPosition_withValidValue() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivitySideSheetRoundedCornersPosition(
                ACTIVITY_SIDE_SHEET_ROUNDED_CORNERS_POSITION_TOP
            )
            .build()

        assertThat(config.activitySideSheetRoundedCornersPosition).isEqualTo(
            ACTIVITY_SIDE_SHEET_ROUNDED_CORNERS_POSITION_TOP
        )
    }

    @Test
    fun setActivitySideSheetRoundedCornersPosition_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setActivitySideSheetRoundedCornersPosition(null)
            .build()

        assertThat(config.activitySideSheetRoundedCornersPosition).isNull()
    }

    @Test
    fun setCornerRadius_withValidValue() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setCornerRadius(24)
            .build()

        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.cornerRadius).isEqualTo(24)
    }

    @Test
    fun setCornerRadius_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setCornerRadius(null)
            .build()

        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.cornerRadius).isNull()
    }

    @Test
    fun setBackgroundInteractionEnabled_withValidValue() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setBackgroundInteractionEnabled(true)
            .build()

        assertThat(config.backgroundInteractionEnabled).isTrue()
    }

    @Test
    fun setBackgroundInteractionEnabled_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setBackgroundInteractionEnabled(null)
            .build()

        assertThat(config.backgroundInteractionEnabled).isNull()
    }

    @Test
    fun build_withChainedMethods() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setInitialHeight(0.6)
            .setActivityHeightResizeBehavior(ACTIVITY_HEIGHT_ADJUSTABLE)
            .setInitialWidth(0.5)
            .setActivitySideSheetBreakpoint(0.8)
            .setActivitySideSheetMaximizationEnabled(true)
            .setActivitySideSheetPosition(ACTIVITY_SIDE_SHEET_POSITION_END)
            .setActivitySideSheetDecorationType(ACTIVITY_SIDE_SHEET_DECORATION_TYPE_DEFAULT)
            .setActivitySideSheetRoundedCornersPosition(
                ACTIVITY_SIDE_SHEET_ROUNDED_CORNERS_POSITION_TOP
            )
            .setCornerRadius(12)
            .setBackgroundInteractionEnabled(false)
            .build()

        assertThat(config.initialHeight).isEqualTo(0.6)
        assertThat(config.activityHeightResizeBehavior).isEqualTo(ACTIVITY_HEIGHT_ADJUSTABLE)
        assertThat(config.initialWidth).isEqualTo(0.5)
        assertThat(config.activitySideSheetBreakpoint).isEqualTo(0.8)
        assertThat(config.activitySideSheetMaximizationEnabled).isTrue()
        assertThat(config.activitySideSheetPosition).isEqualTo(ACTIVITY_SIDE_SHEET_POSITION_END)
        assertThat(config.activitySideSheetDecorationType).isEqualTo(
            ACTIVITY_SIDE_SHEET_DECORATION_TYPE_DEFAULT
        )
        assertThat(config.activitySideSheetRoundedCornersPosition).isEqualTo(
            ACTIVITY_SIDE_SHEET_ROUNDED_CORNERS_POSITION_TOP
        )
        assertThat(config.cornerRadius).isEqualTo(12)
        assertThat(config.backgroundInteractionEnabled).isFalse()
    }

    @Test
    fun build_withoutSettingAnyOptions() {
        val config = PartialCustomTabsConfiguration.Builder().build()

        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.initialWidth).isNull()
        assertThat(config.activitySideSheetBreakpoint).isNull()
        assertThat(config.activitySideSheetMaximizationEnabled).isNull()
        assertThat(config.activitySideSheetPosition).isNull()
        assertThat(config.cornerRadius).isNull()
        assertThat(config.backgroundInteractionEnabled).isNull()
    }
}