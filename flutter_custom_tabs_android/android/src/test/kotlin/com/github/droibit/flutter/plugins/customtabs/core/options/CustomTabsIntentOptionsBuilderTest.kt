package com.github.droibit.flutter.plugins.customtabs.core.options

import androidx.browser.customtabs.CustomTabsIntent
import com.google.common.truth.Truth.assertThat
import org.junit.Test

class CustomTabsIntentOptionsBuilderTest {
    @Test
    fun build_withAllIndividualParameters() {
        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setColorScheme(CustomTabsIntent.COLOR_SCHEME_SYSTEM)
            .build()
        val closeButton = CustomTabsCloseButton.Builder()
            .setIcon("ic_back")
            .build()
        val animations = CustomTabsAnimations.Builder()
            .setStartEnter("enter")
            .setStartExit("exit")
            .build()
        val browser = BrowserConfiguration.Builder()
            .setPrefersDefaultBrowser(false)
            .build()
        val partial = PartialCustomTabsConfiguration.Builder()
            .setCornerRadius(8)
            .build()

        val intentOptions = CustomTabsIntentOptions.Builder()
            .setColorSchemes(colorSchemes)
            .setUrlBarHidingEnabled(true)
            .setShareState(CustomTabsIntent.SHARE_STATE_ON)
            .setShowTitle(false)
            .setInstantAppsEnabled(true)
            .setCloseButton(closeButton)
            .setAnimations(animations)
            .setBrowser(browser)
            .setPartial(partial)
            .build()

        assertThat(intentOptions.colorSchemes).isSameInstanceAs(colorSchemes)
        assertThat(intentOptions.urlBarHidingEnabled).isTrue()
        assertThat(intentOptions.shareState).isEqualTo(CustomTabsIntent.SHARE_STATE_ON)
        assertThat(intentOptions.showTitle).isFalse()
        assertThat(intentOptions.instantAppsEnabled).isTrue()
        assertThat(intentOptions.closeButton).isSameInstanceAs(closeButton)
        assertThat(intentOptions.animations).isSameInstanceAs(animations)
        assertThat(intentOptions.browser).isSameInstanceAs(browser)
        assertThat(intentOptions.partial).isSameInstanceAs(partial)
    }

    @Test
    fun build_withoutSettingAnyOptions() {
        val intentOptions = CustomTabsIntentOptions.Builder().build()

        assertThat(intentOptions.colorSchemes).isNull()
        assertThat(intentOptions.urlBarHidingEnabled).isNull()
        assertThat(intentOptions.shareState).isNull()
        assertThat(intentOptions.showTitle).isNull()
        assertThat(intentOptions.instantAppsEnabled).isNull()
        assertThat(intentOptions.closeButton).isNull()
        assertThat(intentOptions.animations).isNull()
        assertThat(intentOptions.browser).isNull()
        assertThat(intentOptions.partial).isNull()
    }

    @Test
    fun setOptions_withAllOptions() {
        val options = mapOf(
            "colorSchemes" to mapOf(
                "colorScheme" to CustomTabsIntent.COLOR_SCHEME_DARK.toLong(),
            ),
            "urlBarHidingEnabled" to true,
            "shareState" to CustomTabsIntent.SHARE_STATE_ON.toLong(),
            "showTitle" to true,
            "instantAppsEnabled" to false,
            "bookmarksButtonEnabled" to true,
            "downloadButtonEnabled" to false,
            "shareIdentityEnabled" to true,
            "closeButton" to mapOf(
                "icon" to "ic_arrow_back",
            ),
            "animations" to mapOf(
                "startEnter" to "enter_anim",
                "startExit" to "exit_anim",
            ),
            "browser" to mapOf(
                "prefersDefaultBrowser" to true,
            ),
            "partial" to mapOf(
                "initialHeight" to 0.7,
            )
        )

        val intentOptions = CustomTabsIntentOptions.Builder()
            .setOptions(options)
            .build()

        assertThat(intentOptions.colorSchemes).isNotNull()
        assertThat(intentOptions.colorSchemes?.colorScheme).isEqualTo(CustomTabsIntent.COLOR_SCHEME_DARK)
        assertThat(intentOptions.urlBarHidingEnabled).isTrue()
        assertThat(intentOptions.shareState).isEqualTo(CustomTabsIntent.SHARE_STATE_ON)
        assertThat(intentOptions.showTitle).isTrue()
        assertThat(intentOptions.instantAppsEnabled).isFalse()
        assertThat(intentOptions.bookmarksButtonEnabled).isTrue()
        assertThat(intentOptions.downloadButtonEnabled).isFalse()
        assertThat(intentOptions.shareIdentityEnabled).isTrue()
        assertThat(intentOptions.closeButton?.icon).isEqualTo("ic_arrow_back")
        assertThat(intentOptions.animations?.startEnter).isEqualTo("enter_anim")
        assertThat(intentOptions.animations?.startExit).isEqualTo("exit_anim")
        assertThat(intentOptions.browser?.prefersDefaultBrowser).isTrue()
        assertThat(intentOptions.partial?.initialHeight).isEqualTo(0.7)
    }

    @Test
    fun setOptions_withNullOptions() {
        val intentOptions = CustomTabsIntentOptions.Builder()
            .setOptions(null)
            .build()

        assertThat(intentOptions.colorSchemes).isNull()
        assertThat(intentOptions.urlBarHidingEnabled).isNull()
        assertThat(intentOptions.shareState).isNull()
        assertThat(intentOptions.showTitle).isNull()
        assertThat(intentOptions.instantAppsEnabled).isNull()
        assertThat(intentOptions.closeButton).isNull()
        assertThat(intentOptions.animations).isNull()
        assertThat(intentOptions.browser).isNull()
        assertThat(intentOptions.partial).isNull()
    }

    @Test
    fun setColorSchemes_withValidValue() {
        val colorSchemes = CustomTabsColorSchemes.Builder()
            .setColorScheme(CustomTabsIntent.COLOR_SCHEME_LIGHT)
            .build()

        val intentOptions = CustomTabsIntentOptions.Builder()
            .setColorSchemes(colorSchemes)
            .build()

        assertThat(intentOptions.colorSchemes).isSameInstanceAs(colorSchemes)
    }

    @Test
    fun setUrlBarHidingEnabled_withValidValue() {
        val intentOptions = CustomTabsIntentOptions.Builder()
            .setUrlBarHidingEnabled(true)
            .build()

        assertThat(intentOptions.urlBarHidingEnabled).isTrue()
    }

    @Test
    fun setShareState_withValidValue() {
        val intentOptions = CustomTabsIntentOptions.Builder()
            .setShareState(CustomTabsIntent.SHARE_STATE_DEFAULT)
            .build()

        assertThat(intentOptions.shareState).isEqualTo(CustomTabsIntent.SHARE_STATE_DEFAULT)
    }

    @Test
    fun setShowTitle_withValidValue() {
        val intentOptions = CustomTabsIntentOptions.Builder()
            .setShowTitle(true)
            .build()

        assertThat(intentOptions.showTitle).isTrue()
    }

    @Test
    fun setInstantAppsEnabled_withValidValue() {
        val intentOptions = CustomTabsIntentOptions.Builder()
            .setInstantAppsEnabled(false)
            .build()

        assertThat(intentOptions.instantAppsEnabled).isFalse()
    }

    @Test
    fun setCloseButton_withValidValue() {
        val closeButton = CustomTabsCloseButton.Builder()
            .setIcon("ic_close")
            .build()

        val intentOptions = CustomTabsIntentOptions.Builder()
            .setCloseButton(closeButton)
            .build()

        assertThat(intentOptions.closeButton).isSameInstanceAs(closeButton)
    }

    @Test
    fun setAnimations_withValidValue() {
        val animations = CustomTabsAnimations.Builder()
            .setStartEnter("enter_anim")
            .build()

        val intentOptions = CustomTabsIntentOptions.Builder()
            .setAnimations(animations)
            .build()

        assertThat(intentOptions.animations).isSameInstanceAs(animations)
    }

    @Test
    fun setBrowser_withValidValue() {
        val browser = BrowserConfiguration.Builder()
            .setPrefersDefaultBrowser(true)
            .build()

        val intentOptions = CustomTabsIntentOptions.Builder()
            .setBrowser(browser)
            .build()

        assertThat(intentOptions.browser).isSameInstanceAs(browser)
    }

    @Test
    fun setPartial_withValidValue() {
        val partial = PartialCustomTabsConfiguration.Builder()
            .setInitialHeight(0.5)
            .build()

        val intentOptions = CustomTabsIntentOptions.Builder()
            .setPartial(partial)
            .build()

        assertThat(intentOptions.partial).isSameInstanceAs(partial)
    }
}