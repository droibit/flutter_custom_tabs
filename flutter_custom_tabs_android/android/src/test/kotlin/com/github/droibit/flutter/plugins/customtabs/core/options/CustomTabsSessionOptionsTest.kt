package com.github.droibit.flutter.plugins.customtabs.core.options

import android.content.Context
import com.google.common.truth.Truth.assertThat
import io.mockk.every
import io.mockk.mockk
import org.junit.Test

class CustomTabsSessionOptionsTest {
  @Test
  fun constructor_withPrefersDefaultBrowserAndFallbackPackages() {
    val prefersDefaultBrowser = true
    val fallbackPackages = listOf("com.example.browser1", "com.example.browser2")
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
    val fallbackPackages = listOf("com.example.browser1", "com.example.browser2")
    val sessionOptions = CustomTabsSessionOptions(null, fallbackPackages)

    assertThat(sessionOptions.fallbackCustomTabPackages).isEqualTo(fallbackPackages)
  }

  @Test
  fun getAdditionalCustomTabs_delegatesToBrowserConfiguration() {
    val additionalCustomTabs = listOf("com.example.browser")
    val browser = mockk<BrowserConfiguration> {
      every { getAdditionalCustomTabs(any()) } returns additionalCustomTabs
    }
    val sessionOptions = CustomTabsSessionOptions(browser)

    val context = mockk<Context>()
    val result = sessionOptions.getAdditionalCustomTabs(context)

    assertThat(result).isEqualTo(additionalCustomTabs)
  }
}