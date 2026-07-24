package com.github.droibit.flutter.plugins.customtabs.core.browser

import android.content.Context
import androidx.browser.customtabs.CustomTabsClient
import androidx.browser.customtabs.CustomTabsIntent
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.github.droibit.flutter.plugins.customtabs.core.browser.CustomTabsPackage.CHROME_PACKAGES
import com.google.common.truth.Truth.assertThat
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.junit4.MockKRule
import io.mockk.mockkStatic
import io.mockk.unmockkAll
import io.mockk.verify
import org.junit.After
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.annotation.Config

@RunWith(AndroidJUnit4::class)
@Config(manifest = Config.NONE)
class CustomTabsIntentHelperTest {
  @get:Rule
  val mockkRule = MockKRule(this)

  @MockK
  private lateinit var context: Context

  @After
  fun tearDown() {
    unmockkAll()
  }

  @Test
  fun `setChromeCustomTabsPackage uses Chrome if found`() {
    mockkStatic(CustomTabsClient::class)

    val chromePackage = "com.android.chrome"
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns chromePackage

    val customTabsIntent = CustomTabsIntent.Builder()
      .build()
      .setChromeCustomTabsPackage(context)
    assertThat(customTabsIntent.intent.`package`).isEqualTo(chromePackage)

    verify {
      val packages = CHROME_PACKAGES.toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(true))
    }
  }

  @Test
  fun `setChromeCustomTabsPackage sets null if Chrome not found`() {
    mockkStatic(CustomTabsClient::class)
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns null

    val customTabsIntent = CustomTabsIntent.Builder()
      .build()
      .setChromeCustomTabsPackage(context)
    assertThat(customTabsIntent.intent.`package`).isNull()

    verify {
      val packages = CHROME_PACKAGES.toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(true))
    }
  }

  @Test
  fun `setChromeCustomTabsPackage uses non-Chrome Custom Tab if Chrome not found`() {
    mockkStatic(CustomTabsClient::class)

    val nonChromePackage = "com.example.customtabs"
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns nonChromePackage

    val additionalCustomTabs = listOf(nonChromePackage)
    val customTabsIntent = CustomTabsIntent.Builder()
      .build()
      .setChromeCustomTabsPackage(context, additionalCustomTabs)
    assertThat(customTabsIntent.intent.`package`).isEqualTo(nonChromePackage)

    verify {
      val packages = (CHROME_PACKAGES + nonChromePackage).toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(true))
    }
  }

  @Test
  fun `setChromeCustomTabsPackage does not set package if getCustomTabsPackage returns null`() {
    mockkStatic(CustomTabsClient::class)
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns null

    val customTabsIntent = CustomTabsIntent.Builder().build()
      .also {
        assertThat(it.intent.`package`).isNull()
      }
      .setChromeCustomTabsPackage(context)

    assertThat(customTabsIntent.intent.`package`).isNull()

    verify {
      val packages = CHROME_PACKAGES.toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(true))
    }
  }

  @Test
  fun `setCustomTabsPackage uses default browser if found`() {
    mockkStatic(CustomTabsClient::class)

    val chromePackage = "com.chrome.beta"
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns chromePackage

    val customTabsIntent = CustomTabsIntent.Builder()
      .build()
      .setCustomTabsPackage(context)
    assertThat(customTabsIntent.intent.`package`).isEqualTo(chromePackage)

    verify {
      val packages = CHROME_PACKAGES.toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(false))
    }
  }

  @Test
  fun `setCustomTabsPackage sets null if no default browser or Chrome found`() {
    mockkStatic(CustomTabsClient::class)
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns null

    val customTabsIntent = CustomTabsIntent.Builder()
      .build()
      .setCustomTabsPackage(context)
    assertThat(customTabsIntent.intent.`package`).isNull()

    verify {
      val packages = CHROME_PACKAGES.toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(false))
    }
  }

  @Test
  fun `setCustomTabsPackage uses non-Chrome Custom Tab if none found`() {
    mockkStatic(CustomTabsClient::class)

    val nonChromePackage = "com.example.customtabs"
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns nonChromePackage

    val additionalCustomTabs = listOf(nonChromePackage)
    val customTabsIntent = CustomTabsIntent.Builder()
      .build()
      .setCustomTabsPackage(context, additionalCustomTabs)
    assertThat(customTabsIntent.intent.`package`).isEqualTo(nonChromePackage)

    verify {
      val packages = (CHROME_PACKAGES + nonChromePackage).toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(false))
    }
  }

  @Test
  fun `setCustomTabsPackage does not set package if getCustomTabsPackage returns null`() {
    mockkStatic(CustomTabsClient::class)
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns null

    val customTabsIntent = CustomTabsIntent.Builder().build()
      .also {
        assertThat(it.intent.`package`).isNull()
      }
      .setCustomTabsPackage(context)

    assertThat(customTabsIntent.intent.`package`).isNull()

    verify {
      val packages = CHROME_PACKAGES.toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(false))
    }
  }

  @Test
  fun `getCustomTabsPackage returns default Chrome package when available`() {
    mockkStatic(CustomTabsClient::class)

    val chromePackage = "com.android.chrome"
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns chromePackage

    val packageName = getCustomTabsPackage(context)
    assertThat(packageName).isEqualTo(chromePackage)

    verify {
      val packages = CHROME_PACKAGES.toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(true))
    }
  }

  @Test
  fun `getCustomTabsPackage returns additional Custom Tabs package when Chrome not available`() {
    mockkStatic(CustomTabsClient::class)

    val nonChromePackage = "com.example.browser"
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns nonChromePackage

    val additionalCustomTabs = listOf(nonChromePackage)
    val packageName =
      getCustomTabsPackage(context, additionalCustomTabs = additionalCustomTabs)
    assertThat(packageName).isEqualTo(nonChromePackage)

    verify {
      val packages = (CHROME_PACKAGES + nonChromePackage).toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(true))
    }
  }

  @Test
  fun `getCustomTabsPackage returns null when no packages are available`() {
    mockkStatic(CustomTabsClient::class)
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns null


    val packageName = getCustomTabsPackage(context)
    assertThat(packageName).isNull()

    verify {
      val packages = CHROME_PACKAGES.toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(true))
    }
  }

  @Test
  fun `getCustomTabsPackage ignores default packages when ignoreDefault is false`() {
    mockkStatic(CustomTabsClient::class)

    val nonChromePackage = "com.example.browser"
    every { CustomTabsClient.getPackageName(any(), any(), any()) } returns nonChromePackage

    val packageName = getCustomTabsPackage(
      context,
      ignoreDefault = false,
    )
    assertThat(packageName).isEqualTo(nonChromePackage)

    verify {
      val packages = CHROME_PACKAGES.toList()
      CustomTabsClient.getPackageName(any(), eq(packages), eq(false))
    }
  }
}
