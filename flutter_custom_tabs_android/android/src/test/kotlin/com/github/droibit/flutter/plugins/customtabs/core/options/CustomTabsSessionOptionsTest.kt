package com.github.droibit.flutter.plugins.customtabs.core.options

import android.content.Context
import com.droibit.android.customtabs.launcher.CustomTabsPackageProvider
import com.google.common.truth.Truth.assertThat
import io.mockk.every
import io.mockk.mockk
import org.junit.Test

class CustomTabsSessionOptionsTest {
    @Test
    fun constructor_withPrefersDefaultBrowserAndFallbackPackages() {
        val prefersDefaultBrowser = true
        val fallbackPackages = setOf("com.example.browser1", "com.example.browser2")
        val sessionOptions = CustomTabsSessionOptions(prefersDefaultBrowser, fallbackPackages)

        assertThat(sessionOptions.prefersDefaultBrowser).isEqualTo(prefersDefaultBrowser)
        assertThat(sessionOptions.fallbackCustomTabPackages).isEqualTo(fallbackPackages)
    }

    @Test
    fun constructor_withNullParameters() {
        val sessionOptions = CustomTabsSessionOptions(null, null)

        assertThat(sessionOptions.prefersDefaultBrowser).isNull()
        assertThat(sessionOptions.fallbackCustomTabPackages).isNull()
    }

    @Test
    fun prefersDefaultBrowser_delegatesToBrowserConfiguration() {
        val prefersDefaultBrowser = true
        val sessionOptions = CustomTabsSessionOptions(prefersDefaultBrowser, null)

        assertThat(sessionOptions.prefersDefaultBrowser).isEqualTo(prefersDefaultBrowser)
    }

    @Test
    fun fallbackCustomTabPackages_delegatesToBrowserConfiguration() {
        val fallbackPackages = setOf("com.example.browser1", "com.example.browser2")
        val sessionOptions = CustomTabsSessionOptions(null, fallbackPackages)

        assertThat(sessionOptions.fallbackCustomTabPackages).isEqualTo(fallbackPackages)
    }

    @Test
    fun getAdditionalCustomTabs_delegatesToBrowserConfiguration() {
        val additionalCustomTabs = mockk<CustomTabsPackageProvider>()
        val browser = mockk<BrowserConfiguration> {
            every { getAdditionalCustomTabs(any()) } returns additionalCustomTabs
        }
        val sessionOptions = CustomTabsSessionOptions(browser)

        val context = mockk<Context>()
        val provider = sessionOptions.getAdditionalCustomTabs(context)

        assertThat(provider).isSameInstanceAs(additionalCustomTabs)
    }
}