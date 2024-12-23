package com.github.droibit.flutter.plugins.customtabs

import android.app.Activity
import android.content.ActivityNotFoundException
import android.net.Uri
import androidx.browser.customtabs.CustomTabsIntent
import androidx.core.net.toUri
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.github.droibit.flutter.plugins.customtabs.core.CustomTabsIntentFactory
import com.github.droibit.flutter.plugins.customtabs.core.ExternalBrowserLauncher
import com.github.droibit.flutter.plugins.customtabs.core.NativeAppLauncher
import com.github.droibit.flutter.plugins.customtabs.core.PartialCustomTabsLauncher
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsSessionOptions
import com.github.droibit.flutter.plugins.customtabs.core.session.CustomTabsSessionController
import com.github.droibit.flutter.plugins.customtabs.core.session.CustomTabsSessionManager
import com.google.common.truth.Truth.assertThat
import io.mockk.every
import io.mockk.impl.annotations.InjectMockKs
import io.mockk.impl.annotations.MockK
import io.mockk.junit4.MockKRule
import io.mockk.mockk
import io.mockk.slot
import io.mockk.spyk
import io.mockk.verify
import org.junit.Assert.fail
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.annotation.Config

@RunWith(AndroidJUnit4::class)
@Config(manifest = Config.NONE)
class CustomTabsLauncherTest {
    @get:Rule
    val mockkRule = MockKRule(this)

    @MockK(relaxed = true)
    private lateinit var customTabsIntentFactory: CustomTabsIntentFactory

    @MockK(relaxed = true)
    private lateinit var nativeAppLauncher: NativeAppLauncher

    @MockK(relaxed = true)
    private lateinit var externalBrowserLauncher: ExternalBrowserLauncher

    @MockK(relaxed = true)
    private lateinit var partialCustomTabsLauncher: PartialCustomTabsLauncher

    @MockK(relaxed = true)
    private lateinit var customTabsSessionManager: CustomTabsSessionManager

    @InjectMockKs
    private lateinit var launcher: CustomTabsLauncher

    @Test
    fun launch_withoutActivity_throwsException() {
        launcher.setActivity(null)

        try {
            launcher.launch("https://example.com", false, null)
            fail("error")
        } catch (e: Throwable) {
            assertThat(e).isInstanceOf(FlutterError::class.java)

            val actualError = (e as FlutterError)
            assertThat(actualError.code).isEqualTo("LAUNCH_ERROR")
        }
        verify(exactly = 0) { nativeAppLauncher.launch(any(), any()) }
    }

    @Test
    fun launch_withNativeApp() {
        val activity = mockk<Activity>()
        launcher.setActivity(activity)

        every { nativeAppLauncher.launch(any(), any()) } returns true

        val expUrl = "https://example.com".toUri()
        launcher.launch(expUrl.toString(), true, null)

        verify {
            nativeAppLauncher.launch(refEq(activity), eq(expUrl))
        }
        verify(exactly = 0) {
            externalBrowserLauncher.launch(any(), any(), any())
            customTabsIntentFactory.createIntent(any(), any(), any())
        }
    }

    @Test
    fun launch_withExternalBrowser() {
        val activity = mockk<Activity>()
        launcher.setActivity(activity)

        every { customTabsIntentFactory.createIntentOptions(any()) } returns null
        every { externalBrowserLauncher.launch(any(), any(), any()) } returns true

        val expUrl = "https://example.com".toUri()
        launcher.launch(expUrl.toString(), false, null)

        verify { externalBrowserLauncher.launch(refEq(activity), eq(expUrl), isNull()) }
        verify(exactly = 0) { customTabsIntentFactory.createIntent(any(), any(), any()) }
    }

    @Test
    fun launch_withExternalBrowser_throwsException() {
        val activity = mockk<Activity>()
        launcher.setActivity(activity)

        every { customTabsIntentFactory.createIntentOptions(any()) } returns null

        val anf = ActivityNotFoundException()
        every { externalBrowserLauncher.launch(any(), any(), any()) } throws anf

        val url = "https://example.com".toUri()
        try {
            launcher.launch(url.toString(), false, null)
            fail("error")
        } catch (e: Throwable) {
            assertThat(e).isInstanceOf(FlutterError::class.java)

            val actualError = (e as FlutterError)
            assertThat(actualError.code).isEqualTo("LAUNCH_ERROR")
        }

        verify { externalBrowserLauncher.launch(refEq(activity), eq(url), isNull()) }
        verify(exactly = 0) { customTabsIntentFactory.createIntent(any(), any(), any()) }
    }

    @Test
    fun launch_withPartialCustomTabs() {
        val activity = mockk<Activity>()
        launcher.setActivity(activity)

        val intentOptions = mockk<CustomTabsIntentOptions>()
        every { customTabsIntentFactory.createIntentOptions(any()) } returns intentOptions
        every { externalBrowserLauncher.launch(any(), any(), any()) } returns false

        val customTabsIntent = spyk(
            CustomTabsIntent.Builder()
                .setInitialActivityHeightPx(100)
                .build()
        )
        every { customTabsIntentFactory.createIntent(any(), any(), any()) } returns customTabsIntent
        every { partialCustomTabsLauncher.launch(any(), any(), any()) } returns true

        val expUrl = "https://example.com".toUri()
        val options = emptyMap<String, Any>()
        launcher.launch(expUrl.toString(), false, options)

        verify {
            customTabsIntentFactory.createIntent(refEq(activity), refEq(intentOptions), any())
            partialCustomTabsLauncher.launch(
                refEq(activity),
                eq(expUrl),
                refEq(customTabsIntent)
            )
        }
        verify(exactly = 0) { customTabsIntent.launchUrl(any(), any()) }
    }

    @Test
    fun launch_withPartialCustomTabs_throwsException() {
        val activity = mockk<Activity>()
        launcher.setActivity(activity)

        val intentOptions = mockk<CustomTabsIntentOptions>()
        every { customTabsIntentFactory.createIntentOptions(any()) } returns intentOptions
        every { externalBrowserLauncher.launch(any(), any(), any()) } returns false

        val customTabsIntent = CustomTabsIntent.Builder()
            .setInitialActivityHeightPx(100)
            .build()
        every { customTabsIntentFactory.createIntent(any(), any(), any()) } returns customTabsIntent

        val anf = ActivityNotFoundException()
        every { partialCustomTabsLauncher.launch(any(), any(), any()) } throws anf

        try {
            val url = "https://example.com".toUri()
            val options = emptyMap<String, Any>()
            launcher.launch(url.toString(), false, options)
            fail("error")
        } catch (e: Throwable) {
            assertThat(e).isInstanceOf(FlutterError::class.java)

            val actualError = (e as FlutterError)
            assertThat(actualError.code).isEqualTo("LAUNCH_ERROR")
        }

        verify {
            customTabsIntentFactory.createIntent(refEq(activity), refEq(intentOptions), any())
            partialCustomTabsLauncher.launch(refEq(activity), any(), refEq(customTabsIntent))
        }
    }

    @Test
    fun launch_withCustomTabs() {
        val activity = mockk<Activity>(relaxed = true)
        launcher.setActivity(activity)

        val intentOptions = mockk<CustomTabsIntentOptions>()
        every { customTabsIntentFactory.createIntentOptions(any()) } returns intentOptions
        every { externalBrowserLauncher.launch(any(), any(), any()) } returns false

        val customTabsIntent = mockk<CustomTabsIntent>(relaxed = true)
        every { customTabsIntentFactory.createIntent(any(), any(), any()) } returns customTabsIntent
        every { partialCustomTabsLauncher.launch(any(), any(), any()) } returns false

        val expUrl = "https://example.com".toUri()
        val options = emptyMap<String, Any>()
        launcher.launch(expUrl.toString(), false, options)

        val urlSlot = slot<Uri>()
        verify { customTabsIntent.launchUrl(refEq(activity), capture(urlSlot)) }

        val actualUrl = urlSlot.captured
        assertThat(actualUrl).isEqualTo(expUrl)

        verify {
            customTabsIntentFactory.createIntent(
                refEq(activity),
                refEq(intentOptions),
                any()
            )
        }
    }

    @Test
    fun launch_withCustomTabs_throwsException() {
        val activity = mockk<Activity>()
        launcher.setActivity(activity)

        val intentOptions = mockk<CustomTabsIntentOptions>()
        every { customTabsIntentFactory.createIntentOptions(any()) } returns intentOptions
        every { externalBrowserLauncher.launch(any(), any(), any()) } returns false

        val anf = ActivityNotFoundException()
        val customTabsIntent = spyk(CustomTabsIntent.Builder().build()) {
            every { launchUrl(any(), any()) } throws anf
        }
        every { customTabsIntentFactory.createIntent(any(), any(), any()) } returns customTabsIntent
        every { partialCustomTabsLauncher.launch(any(), any(), any()) } returns false

        try {
            val url = "https://example.com".toUri()
            val options = emptyMap<String, Any>()
            launcher.launch(url.toString(), false, options)
            fail("error")
        } catch (e: Throwable) {
            assertThat(e).isInstanceOf(FlutterError::class.java)

            val actualError = (e as FlutterError)
            assertThat(actualError.code).isEqualTo("LAUNCH_ERROR")
        }

        verify { customTabsIntentFactory.createIntent(any(), refEq(intentOptions), any()) }
    }

    @Test
    fun warmup_withSessionOptions_returnsPackageName() {
        val activity = mockk<Activity>()
        launcher.setActivity(activity)

        val sessionOptions = mockk<CustomTabsSessionOptions>()
        every { customTabsSessionManager.createSessionOptions(any()) } returns sessionOptions

        val expPackageName = "com.example.browser"
        val controller = mockk<CustomTabsSessionController> {
            every { packageName } returns expPackageName
            every { bindCustomTabsService(any()) } returns true
        }
        every { customTabsSessionManager.createSessionController(any(), any()) } returns controller

        val options = emptyMap<String, Any>()
        val actualPackageName = launcher.warmup(options)
        assertThat(actualPackageName).isEqualTo(expPackageName)

        verify {
            customTabsSessionManager.createSessionOptions(refEq(options))
            controller.bindCustomTabsService(any())
        }
    }

    @Test
    fun warmup_withSessionOptions_returnsNull() {
        val activity = mockk<Activity>()
        launcher.setActivity(activity)

        val sessionOptions = mockk<CustomTabsSessionOptions>()
        with(customTabsSessionManager) {
            every { createSessionOptions(any()) } returns sessionOptions
            every { createSessionController(any(), any()) } returns null
        }

        val options = emptyMap<String, Any>()
        val actualPackageName = launcher.warmup(options)
        assertThat(actualPackageName).isNull()

        verify { customTabsSessionManager.createSessionOptions(refEq(options)) }
    }

    @Test
    fun warmup_withSessionOptions_bindCustomTabsServiceReturnsFalse() {
        val activity = mockk<Activity>()
        launcher.setActivity(activity)

        val sessionOptions = mockk<CustomTabsSessionOptions>()
        every { customTabsSessionManager.createSessionOptions(any()) } returns sessionOptions

        val controller = mockk<CustomTabsSessionController> {
            every { bindCustomTabsService(any()) } returns false
        }
        every { customTabsSessionManager.createSessionController(any(), any()) } returns controller

        val options = emptyMap<String, Any>()
        val actualPackageName = launcher.warmup(options)
        assertThat(actualPackageName).isNull()

        verify {
            customTabsSessionManager.createSessionOptions(refEq(options))
            controller.bindCustomTabsService(any())
        }
    }

    @Test
    fun warmup_withoutActivity_returnsNull() {
        launcher.setActivity(null)

        val actualPackageName = launcher.warmup(emptyMap())
        assertThat(actualPackageName).isNull()

        with(customTabsSessionManager) {
            verify(exactly = 0) {
                createSessionOptions(any())
                createSessionController(any(), any())
            }
        }
    }

    @Test
    @Throws(Exception::class)
    fun invalidate_withValidPackageName_invokesInvalidateSession() {
        val packageName = "com.example.browser"
        launcher.invalidate(packageName)

        verify { customTabsSessionManager.invalidateSession(packageName) }
    }
}