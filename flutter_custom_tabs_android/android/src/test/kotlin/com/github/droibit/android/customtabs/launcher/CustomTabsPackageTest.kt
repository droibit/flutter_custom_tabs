package com.github.droibit.android.customtabs.launcher

import android.content.Context
import android.content.pm.ActivityInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.github.droibit.android.customtabs.launcher.CustomTabsPackage.CHROME_PACKAGES
import com.google.common.truth.Truth.assertThat
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.junit4.MockKRule
import io.mockk.mockk
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.annotation.Config

@RunWith(AndroidJUnit4::class)
@Config(manifest = Config.NONE)
class CustomTabsPackageTest {
  @get:Rule
  val mockkRule = MockKRule(this)

  @MockK
  private lateinit var pm: PackageManager

  @MockK
  private lateinit var context: Context

  @Before
  fun setUp() {
    every { context.packageManager } returns pm
  }

  @Test
  fun `CHROME_PACKAGES are listed in priority order`() {
    val expectedOrder = listOf(
      "com.android.chrome",
      "com.chrome.beta",
      "com.chrome.dev",
      "com.google.android.apps.chrome",
    )
    assertThat(CHROME_PACKAGES.toList()).isEqualTo(expectedOrder)
  }

  @Test
  fun `getNonChromeCustomTabsPackages returns only non-Chrome CustomTabs packages`() {
    val activities = listOf(
      createResolveInfo(packageName = "com.android.chrome"),
      createResolveInfo(packageName = "com.example.customtabs_1"),
      createResolveInfo(packageName = "com.example.customtabs_2"),
    )
    every { pm.queryIntentActivities(any(), any<Int>()) } returns activities
    every { pm.resolveService(any(), any<Int>()) } returns mockk()

    val result = CustomTabsPackage.getNonChromeCustomTabsPackages(context)
    assertThat(result).containsExactly(
      "com.example.customtabs_1",
      "com.example.customtabs_2",
    )
  }

  @Test
  fun `getNonChromeCustomTabsPackages returns empty list if CustomTabsService is not found`() {
    val activities = listOf(
      createResolveInfo(packageName = "com.example.customtabs_1"),
      createResolveInfo(packageName = "com.example.customtabs_2"),
    )
    every { pm.queryIntentActivities(any(), any<Int>()) } returns activities
    every { pm.resolveService(any(), any<Int>()) } returns null

    val result = CustomTabsPackage.getNonChromeCustomTabsPackages(context)
    assertThat(result).isEmpty()
  }

  @Test
  fun `getNonChromeCustomTabsPackages returns empty list if Chrome is installed`() {
    val activities = listOf(
      createResolveInfo(packageName = "com.android.chrome"),
      createResolveInfo(packageName = "com.chrome.beta"),
    )
    every { pm.queryIntentActivities(any(), any<Int>()) } returns activities
    every { pm.resolveService(any(), any<Int>()) } returns mockk()

    val result = CustomTabsPackage.getNonChromeCustomTabsPackages(context)
    assertThat(result).isEmpty()
  }
}

private fun createResolveInfo(packageName: String) = ResolveInfo().apply {
  activityInfo = ActivityInfo().apply {
    this.packageName = packageName
  }
}
