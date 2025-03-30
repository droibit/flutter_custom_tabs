package com.github.droibit.flutter.plugins.customtabs.core.options

import androidx.browser.customtabs.CustomTabsIntent
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_ADJUSTABLE
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_DEFAULT
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_FIXED
import com.google.common.truth.Truth.assertThat
import org.junit.Test

class PartialCustomTabsConfigurationBuilderTest {
    @Test
    fun setOptions_withAllOptions() {
        val options = mapOf(
            "initialHeight" to 0.8,
            "activityHeightResizeBehavior" to ACTIVITY_HEIGHT_FIXED.toLong(),
            "cornerRadius" to 8.toLong(),
        )

        val config = PartialCustomTabsConfiguration.Builder()
            .setOptions(options)
            .build()

        assertThat(config.initialHeight).isEqualTo(0.8)
        assertThat(config.activityHeightResizeBehavior).isEqualTo(ACTIVITY_HEIGHT_FIXED)
        assertThat(config.cornerRadius).isEqualTo(8)
    }

    @Test
    fun setOptions_withPartialOptions() {
        val options = mapOf(
            "initialHeight" to 0.5,
            "cornerRadius" to 16.toLong()
        )

        val config = PartialCustomTabsConfiguration.Builder()
            .setOptions(options)
            .build()

        assertThat(config.initialHeight).isEqualTo(0.5)
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.cornerRadius).isEqualTo(16)
    }

    @Test
    fun setOptions_withEmptyMap() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setOptions(emptyMap())
            .build()

        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.cornerRadius).isNull()
    }

    @Test
    fun setOptions_withNull() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setOptions(null)
            .build()

        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.cornerRadius).isNull()
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
    fun build_withChainedMethods() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setInitialHeight(0.6)
            .setActivityHeightResizeBehavior(ACTIVITY_HEIGHT_ADJUSTABLE)
            .setCornerRadius(12)
            .build()

        assertThat(config.initialHeight).isEqualTo(0.6)
        assertThat(config.activityHeightResizeBehavior).isEqualTo(ACTIVITY_HEIGHT_ADJUSTABLE)
        assertThat(config.cornerRadius).isEqualTo(12)
    }

    @Test
    fun build_withoutSettingAnyOptions() {
        val config = PartialCustomTabsConfiguration.Builder().build()

        assertThat(config.initialHeight).isNull()
        assertThat(config.activityHeightResizeBehavior).isNull()
        assertThat(config.cornerRadius).isNull()
    }

    @Test
    fun setOptions_overridesExistingValues() {
        val config = PartialCustomTabsConfiguration.Builder()
            .setInitialHeight(0.3)
            .setActivityHeightResizeBehavior(ACTIVITY_HEIGHT_ADJUSTABLE)
            .setCornerRadius(4)
            .setOptions(
                mapOf(
                    "initialHeight" to 0.9,
                    "activityHeightResizeBehavior" to ACTIVITY_HEIGHT_FIXED.toLong(),
                    "cornerRadius" to 8.toLong(),
                )
            )
            .build()

        assertThat(config.initialHeight).isEqualTo(0.9)
        assertThat(config.activityHeightResizeBehavior).isEqualTo(ACTIVITY_HEIGHT_FIXED)
        assertThat(config.cornerRadius).isEqualTo(8)
    }
}