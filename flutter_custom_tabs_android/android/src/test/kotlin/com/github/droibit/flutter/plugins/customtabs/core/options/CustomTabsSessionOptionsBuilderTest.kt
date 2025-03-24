package com.github.droibit.flutter.plugins.customtabs.core.options

import com.google.common.truth.Truth.assertThat
import org.junit.Test

class CustomTabsSessionOptionsBuilderTest {
    @Test
    fun setOptions_withAllOptions() {
        val options = mapOf(
            "prefersDefaultBrowser" to true,
            "fallbackCustomTabs" to listOf(
                "com.example.browser1",
                "com.example.browser2",
            )
        )

        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setOptions(options)
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isTrue()
        assertThat(sessionOptions.fallbackCustomTabPackages).containsExactly(
            "com.example.browser1",
            "com.example.browser2",
        )
    }

    @Test
    fun setOptions_withPartialOptions() {
        val options = mapOf(
            "prefersDefaultBrowser" to true
        )

        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setOptions(options)
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isTrue()
        assertThat(sessionOptions.fallbackCustomTabPackages).isNull()
    }

    @Test
    fun setOptions_withEmptyMap() {
        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setOptions(emptyMap())
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isNull()
        assertThat(sessionOptions.fallbackCustomTabPackages).isNull()
    }

    @Test
    fun setOptions_withNull() {
        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setOptions(null)
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isNull()
        assertThat(sessionOptions.fallbackCustomTabPackages).isNull()
    }

    @Test
    fun setPrefersDefaultBrowser_withTrue() {
        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setPrefersDefaultBrowser(true)
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isTrue()
        assertThat(sessionOptions.fallbackCustomTabPackages).isNull()
    }

    @Test
    fun setPrefersDefaultBrowser_withFalse() {
        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setPrefersDefaultBrowser(false)
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isFalse()
        assertThat(sessionOptions.fallbackCustomTabPackages).isNull()
    }

    @Test
    fun setPrefersDefaultBrowser_withNull() {
        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setPrefersDefaultBrowser(null)
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isNull()
        assertThat(sessionOptions.fallbackCustomTabPackages).isNull()
    }

    @Test
    fun setFallbackCustomTabs_withMultiplePackages() {
        val packages = setOf("com.example.browser1", "com.example.browser2")

        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setFallbackCustomTabs(packages)
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isNull()
        assertThat(sessionOptions.fallbackCustomTabPackages).containsExactlyElementsIn(packages)
    }

    @Test
    fun setFallbackCustomTabs_withEmptySet() {
        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setFallbackCustomTabs(emptySet())
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isNull()
        assertThat(sessionOptions.fallbackCustomTabPackages).isEmpty()
    }

    @Test
    fun setFallbackCustomTabs_withNull() {
        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setFallbackCustomTabs(null)
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isNull()
        assertThat(sessionOptions.fallbackCustomTabPackages).isNull()
    }

    @Test
    fun build_withoutSettingAnyOptions() {
        val sessionOptions = CustomTabsSessionOptions.Builder().build()

        assertThat(sessionOptions.prefersDefaultBrowser).isNull()
        assertThat(sessionOptions.fallbackCustomTabPackages).isNull()
    }

    @Test
    fun build_withChainedMethods() {
        val sessionOptions = CustomTabsSessionOptions.Builder()
            .setPrefersDefaultBrowser(true)
            .setFallbackCustomTabs(setOf("com.example.browser"))
            .build()

        assertThat(sessionOptions.prefersDefaultBrowser).isTrue()
        assertThat(sessionOptions.fallbackCustomTabPackages).containsExactly("com.example.browser")
    }
}