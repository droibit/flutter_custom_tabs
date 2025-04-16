package com.github.droibit.flutter.plugins.customtabs.core.options

import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_ADJUSTABLE
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_FIXED
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_SIDE_SHEET_DECORATION_TYPE_DEFAULT
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_SIDE_SHEET_POSITION_END
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_SIDE_SHEET_ROUNDED_CORNERS_POSITION_TOP
import com.google.common.truth.Truth.assertThat
import com.google.testing.junit.testparameterinjector.TestParameter
import com.google.testing.junit.testparameterinjector.TestParameterInjector
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(TestParameterInjector::class)
class PartialCustomTabsConfigurationBuilderTest {
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
  fun setInitialHeight_parameterized(
    @TestParameter("0.7", "100", "null") input: Double?,
  ) {
    val config = PartialCustomTabsConfiguration.Builder()
      .setInitialHeight(input)
      .build()

    assertThat(config.initialHeight).isEqualTo(input)
  }

  @Test
  fun setActivityHeightResizeBehavior_parameterized(
    @TestParameter("0", "null") input: Int?,
  ) {
    val config = PartialCustomTabsConfiguration.Builder()
      .setActivityHeightResizeBehavior(input)
      .build()

    assertThat(config.activityHeightResizeBehavior).isEqualTo(input)
  }

  @Test
  fun setInitialWidth_parameterized(
    @TestParameter("0.6", "200", "null") input: Double?,
  ) {
    val config = PartialCustomTabsConfiguration.Builder()
      .setInitialWidth(input)
      .build()

    assertThat(config.initialWidth).isEqualTo(input)
  }

  @Test
  fun setActivitySideSheetBreakpoint_parameterized(
    @TestParameter("0.75", "300", "null") input: Double?,
  ) {
    val config = PartialCustomTabsConfiguration.Builder()
      .setActivitySideSheetBreakpoint(input)
      .build()

    assertThat(config.activitySideSheetBreakpoint).isEqualTo(input)
  }

  @Test
  fun setActivitySideSheetMaximizationEnabled_parameterized(
    @TestParameter("true", "false", "null") input: Boolean?,
  ) {
    val config = PartialCustomTabsConfiguration.Builder()
      .setActivitySideSheetMaximizationEnabled(input)
      .build()

    assertThat(config.activitySideSheetMaximizationEnabled).isEqualTo(input)
  }

  @Test
  fun setActivitySideSheetPosition_parameterized(
    @TestParameter("2", "null") input: Int?,
  ) {
    val config = PartialCustomTabsConfiguration.Builder()
      .setActivitySideSheetPosition(input)
      .build()

    assertThat(config.activitySideSheetPosition).isEqualTo(input)
  }

  @Test
  fun setActivitySideSheetDecorationType_parameterized(
    @TestParameter("0", "null") input: Int?,
  ) {
    val config = PartialCustomTabsConfiguration.Builder()
      .setActivitySideSheetDecorationType(input)
      .build()

    assertThat(config.activitySideSheetDecorationType).isEqualTo(input)
  }

  @Test
  fun setActivitySideSheetRoundedCornersPosition_parameterized(
    @TestParameter("2", "null") input: Int?,
  ) {
    val config = PartialCustomTabsConfiguration.Builder()
      .setActivitySideSheetRoundedCornersPosition(input)
      .build()

    assertThat(config.activitySideSheetRoundedCornersPosition).isEqualTo(input)
  }

  @Test
  fun setCornerRadius_parameterized(
    @TestParameter("16", "null") input: Int?,
  ) {
    val config = PartialCustomTabsConfiguration.Builder()
      .setCornerRadius(input)
      .build()

    assertThat(config.cornerRadius).isEqualTo(input)
  }

  @Test
  fun setBackgroundInteractionEnabled_parameterized(
    @TestParameter("true", "false", "null") input: Boolean?,
  ) {
    val config = PartialCustomTabsConfiguration.Builder()
      .setBackgroundInteractionEnabled(input)
      .build()

    assertThat(config.backgroundInteractionEnabled).isEqualTo(input)
  }
}