package com.github.droibit.flutter.plugins.customtabs.core.session

import android.content.Context
import androidx.browser.customtabs.CustomTabsSession
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.droibit.android.customtabs.launcher.CustomTabsPackageProvider
import com.droibit.android.customtabs.launcher.getCustomTabsPackage
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsSessionOptions
import com.google.common.truth.Truth.assertThat
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkStatic
import io.mockk.unmockkAll
import io.mockk.verify
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.annotation.Config

@RunWith(AndroidJUnit4::class)
@Config(manifest = Config.NONE)
class CustomTabsSessionManagerTest {
  private lateinit var cachedSessions: MutableMap<String, CustomTabsSessionController>

  private lateinit var factory: CustomTabsSessionManager

  @Before
  fun setUp() {
    cachedSessions = mutableMapOf()
    factory = CustomTabsSessionManager(cachedSessions)
  }

  @After
  fun tearDown() {
    unmockkAll()
  }

  @Test
  fun createSessionController_withValidPackage_returnsSessionController() {
    mockkStatic("com.droibit.android.customtabs.launcher.CustomTabsIntentHelper")

    val packageName = "com.example.customtabs"
    every { getCustomTabsPackage(any(), any(), any()) } returns packageName

    val additionalCustomTabs = mockk<CustomTabsPackageProvider>()
    val options = mockk<CustomTabsSessionOptions>(relaxed = true) {
      every { prefersDefaultBrowser } returns null
      every { getAdditionalCustomTabs(any()) } returns additionalCustomTabs
    }

    val context = mockk<Context>()
    val result = factory.createSessionController(context, options)
    assertThat(result).isNotNull()
    assertThat(requireNotNull(result).packageName).isEqualTo(packageName)
    assertThat(cachedSessions.containsKey(packageName)).isTrue()

    verify { getCustomTabsPackage(any(), eq(true), any()) }
  }

  @Test
  fun createSessionController_withNullPackage_returnsNull() {
    mockkStatic("com.droibit.android.customtabs.launcher.CustomTabsIntentHelper")
    every { getCustomTabsPackage(any(), any(), any()) } returns null

    val additionalCustomTabs = mockk<CustomTabsPackageProvider>()
    val options = mockk<CustomTabsSessionOptions> {
      every { prefersDefaultBrowser } returns null
      every { getAdditionalCustomTabs(any()) } returns additionalCustomTabs
    }

    val context = mockk<Context>()
    val result = factory.createSessionController(context, options)
    assertThat(result).isNull()

    verify { getCustomTabsPackage(any(), eq(true), any()) }
  }

  @Test
  fun createSessionController_prefersDefaultBrowser_returnsSessionController() {
    mockkStatic("com.droibit.android.customtabs.launcher.CustomTabsIntentHelper")

    val packageName = "com.example.customtabs"
    every { getCustomTabsPackage(any(), any(), any()) } returns packageName

    val additionalCustomTabs = mockk<CustomTabsPackageProvider>()
    val options = mockk<CustomTabsSessionOptions>(relaxed = true) {
      every { prefersDefaultBrowser } returns true
      every { getAdditionalCustomTabs(any()) } returns additionalCustomTabs
    }

    val context = mockk<Context>()
    val result = factory.createSessionController(context, options)
    assertThat(result).isNotNull()
    assertThat(requireNotNull(result).packageName).isEqualTo(packageName)
    assertThat(cachedSessions.containsKey(packageName)).isTrue()

    verify { getCustomTabsPackage(any(), eq(false), any()) }
  }

  @Test
  fun createSessionController_prefersChrome_returnsSessionController() {
    mockkStatic("com.droibit.android.customtabs.launcher.CustomTabsIntentHelper")

    val packageName = "com.example.customtabs"
    every { getCustomTabsPackage(any(), any(), any()) } returns packageName

    val additionalCustomTabs = mockk<CustomTabsPackageProvider>()
    val options = mockk<CustomTabsSessionOptions>(relaxed = true) {
      every { prefersDefaultBrowser } returns false
      every { getAdditionalCustomTabs(any()) } returns additionalCustomTabs
    }

    val context = mockk<Context>()
    val result = factory.createSessionController(context, options)
    assertThat(result).isNotNull()
    assertThat(requireNotNull(result).packageName).isEqualTo(packageName)
    assertThat(cachedSessions.containsKey(packageName)).isTrue()

    verify { getCustomTabsPackage(any(), eq(true), any()) }
  }

  @Test
  fun session_withExistingSession_returnsSession() {
    val packageName = "com.example.customtabs"
    val expSession = mockk<CustomTabsSession>()
    val controller = mockk<CustomTabsSessionController> {
      every { session } returns expSession
    }
    cachedSessions[packageName] = controller

    val result = factory.getSession(packageName)
    assertThat(result).isNotNull()
    assertThat(result).isSameInstanceAs(expSession)
  }

  @Test
  fun session_withNonExistingSession_returnsNull() {
    val result = factory.getSession("non.existent.package")
    assertThat(result).isNull()
  }

  @Test
  fun invalidateSession_withExistingSession_removesSession() {
    val packageName = "com.example.customtabs"
    val controller = mockk<CustomTabsSessionController>(relaxed = true)
    cachedSessions[packageName] = controller

    factory.invalidateSession(packageName)

    assertThat(cachedSessions.containsKey(packageName)).isFalse()
    verify { controller.unbindCustomTabsService() }
  }

  @Test
  fun invalidateSession_withNonExistentPackage_doesNotRemoveSession() {
    val packageName = "com.example.customtabs"
    val controller = mockk<CustomTabsSessionController>()
    cachedSessions[packageName] = controller

    factory.invalidateSession("non.existent.package")

    assertThat(cachedSessions.containsKey(packageName)).isTrue()
    verify(exactly = 0) { controller.unbindCustomTabsService() }
  }

  @Test
  fun handleActivityChange_withNullActivity_unbindsAllServices() {
    val packageName1 = "com.example.customtabs1"
    val controller1 = mockk<CustomTabsSessionController>(relaxed = true)
    cachedSessions[packageName1] = controller1

    val packageName2 = "com.example.customtabs2"
    val controller2 = mockk<CustomTabsSessionController>(relaxed = true)
    cachedSessions[packageName2] = controller2

    factory.handleActivityChange(null)

    verify {
      controller1.unbindCustomTabsService()
      controller2.unbindCustomTabsService()
    }
  }

  @Test
  fun handleActivityChange_withActivity_bindsAllServices() {
    val packageName1 = "com.example.customtabs1"
    val controller1 = mockk<CustomTabsSessionController>(relaxed = true)

    cachedSessions[packageName1] = controller1

    val packageName2 = "com.example.customtabs2"
    val controller2 = mockk<CustomTabsSessionController>(relaxed = true)
    cachedSessions[packageName2] = controller2

    val activity = mockk<Context>()
    factory.handleActivityChange(activity)

    verify {
      controller1.bindCustomTabsService(refEq(activity))
      controller2.bindCustomTabsService(refEq(activity))
    }
  }
}