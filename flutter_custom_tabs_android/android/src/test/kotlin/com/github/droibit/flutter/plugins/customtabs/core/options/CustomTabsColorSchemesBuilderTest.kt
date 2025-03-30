package com.github.droibit.flutter.plugins.customtabs.core.options

import android.graphics.Color
import androidx.browser.customtabs.CustomTabColorSchemeParams
import androidx.browser.customtabs.CustomTabsIntent
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.google.common.truth.Truth.assertThat
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.annotation.Config

@RunWith(AndroidJUnit4::class)
@Config(manifest = Config.NONE)
class CustomTabsColorSchemesBuilderTest {
    @Test
    fun setOptions_withAllOptions() {
        val options = mapOf(
            "colorScheme" to CustomTabsIntent.COLOR_SCHEME_DARK.toLong(),
            "lightParams" to mapOf(
                "toolbarColor" to "#FFFFFF",
                "navigationBarColor" to "#AAAAAA",
                "navigationBarDividerColor" to "#BBBBBB",
            ),
            "darkParams" to mapOf(
                "toolbarColor" to "#000000",
                "navigationBarColor" to "#333333",
                "navigationBarDividerColor" to "#444444",
            ),
            "defaultParams" to mapOf(
                "toolbarColor" to "#CCCCCC",
                "navigationBarColor" to "#DDDDDD",
                "navigationBarDividerColor" to "#EEEEEE",
            )
        )

        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setOptions(options)
            .build()

        assertThat(colorSchemes.colorScheme).isEqualTo(CustomTabsIntent.COLOR_SCHEME_DARK)
        assertParamsEqual(
            colorSchemes.lightParams!!,
            Color.parseColor("#FFFFFF"),
            Color.parseColor("#AAAAAA"),
            Color.parseColor("#BBBBBB"),
        )
        assertParamsEqual(
            colorSchemes.darkParams!!,
            Color.parseColor("#000000"),
            Color.parseColor("#333333"),
            Color.parseColor("#444444"),
        )
        assertParamsEqual(
            colorSchemes.defaultPrams!!,
            Color.parseColor("#CCCCCC"),
            Color.parseColor("#DDDDDD"),
            Color.parseColor("#EEEEEE"),
        )
    }

    @Test
    fun setOptions_withPartialOptions() {
        val options = mapOf(
            "colorScheme" to CustomTabsIntent.COLOR_SCHEME_LIGHT.toLong(),
            "darkParams" to mapOf(
                "toolbarColor" to "#000000",
            )
        )

        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setOptions(options)
            .build()

        assertThat(colorSchemes.colorScheme).isEqualTo(CustomTabsIntent.COLOR_SCHEME_LIGHT)
        assertThat(colorSchemes.lightParams).isNull()
        assertParamsEqual(colorSchemes.darkParams!!, Color.parseColor("#000000"), 0, 0)
        assertThat(colorSchemes.defaultPrams).isNull()
    }

    @Test
    fun setOptions_withPartialColorSchemeParams() {
        val options = mapOf(
            "lightParams" to mapOf(
                "toolbarColor" to "#FFFFFF",
            ),
            "darkParams" to mapOf(
                "navigationBarColor" to "#333333",
            ),
            "defaultParams" to mapOf(
                "navigationBarDividerColor" to "#EEEEEE",
            )
        )

        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setOptions(options)
            .build()

        assertParamsEqual(colorSchemes.lightParams!!, Color.parseColor("#FFFFFF"), 0, 0)
        assertParamsEqual(colorSchemes.darkParams!!, 0, Color.parseColor("#333333"), 0)
        assertParamsEqual(colorSchemes.defaultPrams!!, 0, 0, Color.parseColor("#EEEEEE"))
    }

    @Test
    fun setOptions_withEmptyMap() {
        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setOptions(emptyMap())
            .build()

        assertThat(colorSchemes.colorScheme).isNull()
        assertThat(colorSchemes.lightParams).isNull()
        assertThat(colorSchemes.darkParams).isNull()
        assertThat(colorSchemes.defaultPrams).isNull()
    }

    @Test
    fun setOptions_withNull() {
        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setOptions(null)
            .build()

        assertThat(colorSchemes.colorScheme).isNull()
        assertThat(colorSchemes.lightParams).isNull()
        assertThat(colorSchemes.darkParams).isNull()
        assertThat(colorSchemes.defaultPrams).isNull()
    }

    @Test
    fun setColorScheme_withValidValue() {
        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setColorScheme(CustomTabsIntent.COLOR_SCHEME_SYSTEM)
            .build()

        assertThat(colorSchemes.colorScheme).isEqualTo(CustomTabsIntent.COLOR_SCHEME_SYSTEM)
        assertThat(colorSchemes.lightParams).isNull()
        assertThat(colorSchemes.darkParams).isNull()
        assertThat(colorSchemes.defaultPrams).isNull()
    }

    @Test
    fun setColorScheme_withNull() {
        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setColorScheme(null)
            .build()

        assertThat(colorSchemes.colorScheme).isNull()
    }

    @Test
    fun setLightParams_withValidParams() {
        val params = CustomTabColorSchemeParams.Builder()
            .setToolbarColor(Color.WHITE)
            .build()

        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setLightParams(params)
            .build()

        assertThat(colorSchemes.lightParams).isSameInstanceAs(params)
    }

    @Test
    fun setLightParams_withNull() {
        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setLightParams(null)
            .build()

        assertThat(colorSchemes.lightParams).isNull()
    }

    @Test
    fun setDarkParams_withValidParams() {
        val params = CustomTabColorSchemeParams.Builder()
            .setNavigationBarColor(Color.BLACK)
            .build()

        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setDarkParams(params)
            .build()

        assertThat(colorSchemes.darkParams).isSameInstanceAs(params)
    }

    @Test
    fun setDarkParams_withNull() {
        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setDarkParams(null)
            .build()

        assertThat(colorSchemes.darkParams).isNull()
    }

    @Test
    fun setDefaultParams_withValidParams() {
        val params = CustomTabColorSchemeParams.Builder()
            .setNavigationBarDividerColor(Color.GRAY)
            .build()

        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setDefaultParams(params)
            .build()

        assertThat(colorSchemes.defaultPrams).isSameInstanceAs(params)
    }

    @Test
    fun setDefaultParams_withNull() {
        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setDefaultParams(null)
            .build()

        assertThat(colorSchemes.defaultPrams).isNull()
    }

    @Test
    fun build_withChainedMethods() {
        val lightParams = CustomTabColorSchemeParams.Builder().setToolbarColor(Color.WHITE).build()
        val darkParams = CustomTabColorSchemeParams.Builder().setToolbarColor(Color.BLACK).build()
        val defaultParams = CustomTabColorSchemeParams.Builder().setToolbarColor(Color.GRAY).build()

        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setColorScheme(CustomTabsIntent.COLOR_SCHEME_DARK)
            .setLightParams(lightParams)
            .setDarkParams(darkParams)
            .setDefaultParams(defaultParams)
            .build()

        assertThat(colorSchemes.colorScheme).isEqualTo(CustomTabsIntent.COLOR_SCHEME_DARK)
        assertThat(colorSchemes.lightParams).isSameInstanceAs(lightParams)
        assertThat(colorSchemes.darkParams).isSameInstanceAs(darkParams)
        assertThat(colorSchemes.defaultPrams).isSameInstanceAs(defaultParams)
    }

    @Test
    fun build_withoutSettingAnyOptions() {
        val colorSchemes = CustomTabsColorSchemes.Builder().build()

        assertThat(colorSchemes.colorScheme).isNull()
        assertThat(colorSchemes.lightParams).isNull()
        assertThat(colorSchemes.darkParams).isNull()
        assertThat(colorSchemes.defaultPrams).isNull()
    }

    private fun assertParamsEqual(
        params: CustomTabColorSchemeParams,
        toolbarColor: Int,
        navigationBarColor: Int,
        navigationBarDividerColor: Int
    ) {
        if (toolbarColor != 0) {
            assertThat(params.toolbarColor).isEqualTo(toolbarColor)
        }
        if (navigationBarColor != 0) {
            assertThat(params.navigationBarColor).isEqualTo(navigationBarColor)
        }
        if (navigationBarDividerColor != 0) {
            assertThat(params.navigationBarDividerColor).isEqualTo(navigationBarDividerColor)
        }
    }
}