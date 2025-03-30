package com.github.droibit.flutter.plugins.customtabs.core.options

import androidx.browser.customtabs.CustomTabsIntent
import com.google.common.truth.Truth.assertThat
import org.junit.Test

class CustomTabsCloseButtonBuilderTest {
    @Test
    fun setOptions_withAllOptions() {
        val options = mapOf(
            "icon" to "ic_arrow_back",
            "position" to CustomTabsIntent.CLOSE_BUTTON_POSITION_START.toLong(),
        )

        val closeButton = CustomTabsCloseButton.Builder()
            .setOptions(options)
            .build()

        assertThat(closeButton.icon).isEqualTo("ic_arrow_back")
        assertThat(closeButton.position).isEqualTo(CustomTabsIntent.CLOSE_BUTTON_POSITION_START)
    }

    @Test
    fun setOptions_withPartialOptions() {
        val options = mapOf(
            "icon" to "ic_arrow_back"
        )

        val closeButton = CustomTabsCloseButton.Builder()
            .setOptions(options)
            .build()

        assertThat(closeButton.icon).isEqualTo("ic_arrow_back")
        assertThat(closeButton.position).isNull()
    }

    @Test
    fun setOptions_withEmptyMap() {
        val closeButton = CustomTabsCloseButton.Builder()
            .setOptions(emptyMap())
            .build()

        assertThat(closeButton.icon).isNull()
        assertThat(closeButton.position).isNull()
    }

    @Test
    fun setOptions_withNull() {
        val closeButton = CustomTabsCloseButton.Builder()
            .setOptions(null)
            .build()

        assertThat(closeButton.icon).isNull()
        assertThat(closeButton.position).isNull()
    }

    @Test
    fun setIcon_withValidValue() {
        val closeButton = CustomTabsCloseButton.Builder()
            .setIcon("ic_arrow_back")
            .build()

        assertThat(closeButton.icon).isEqualTo("ic_arrow_back")
        assertThat(closeButton.position).isNull()
    }

    @Test
    fun setIcon_withNull() {
        val closeButton = CustomTabsCloseButton.Builder()
            .setIcon(null)
            .build()

        assertThat(closeButton.icon).isNull()
        assertThat(closeButton.position).isNull()
    }

    @Test
    fun setPosition_withValidValue() {
        val closeButton = CustomTabsCloseButton.Builder()
            .setPosition(CustomTabsIntent.CLOSE_BUTTON_POSITION_START)
            .build()

        assertThat(closeButton.icon).isNull()
        assertThat(closeButton.position).isEqualTo(CustomTabsIntent.CLOSE_BUTTON_POSITION_START)
    }

    @Test
    fun setPosition_withNull() {
        val closeButton = CustomTabsCloseButton.Builder()
            .setPosition(null)
            .build()

        assertThat(closeButton.icon).isNull()
        assertThat(closeButton.position).isNull()
    }

    @Test
    fun build_withChainedMethods() {
        val closeButton = CustomTabsCloseButton.Builder()
            .setIcon("ic_arrow_back")
            .setPosition(CustomTabsIntent.CLOSE_BUTTON_POSITION_START)
            .build()

        assertThat(closeButton.icon).isEqualTo("ic_arrow_back")
        assertThat(closeButton.position).isEqualTo(CustomTabsIntent.CLOSE_BUTTON_POSITION_START)
    }

    @Test
    fun build_withoutSettingAnyOptions() {
        val closeButton = CustomTabsCloseButton.Builder().build()

        assertThat(closeButton.icon).isNull()
        assertThat(closeButton.position).isNull()
    }
}