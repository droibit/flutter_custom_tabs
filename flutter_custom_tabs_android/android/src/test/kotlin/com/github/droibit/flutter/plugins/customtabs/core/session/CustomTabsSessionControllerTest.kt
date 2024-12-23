package com.github.droibit.flutter.plugins.customtabs.core.session

import android.content.ComponentName
import android.content.Context
import android.os.Bundle
import android.os.Parcelable
import androidx.browser.customtabs.CustomTabsClient
import androidx.browser.customtabs.CustomTabsService.KEY_URL
import androidx.browser.customtabs.CustomTabsSession
import androidx.core.net.toUri
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.ext.truth.os.BundleSubject.assertThat
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
class CustomTabsSessionControllerTest {
    private val packageName = "com.example.browser"

    private lateinit var controller: CustomTabsSessionController

    @Before
    fun setUp() {
        controller = CustomTabsSessionController(packageName)
    }

    @After
    fun tearDown() {
        unmockkAll()
    }

    @Test
    fun bindCustomTabsService_withValidPackageName_returnsTrue() {
        mockkStatic(CustomTabsClient::class)
        every { CustomTabsClient.bindCustomTabsService(any(), any(), any()) } returns true

        val context = mockk<Context>()
        val result = controller.bindCustomTabsService(context)
        assertThat(result).isTrue()
        assertThat(controller.isCustomTabsServiceBound).isTrue()

        verify { CustomTabsClient.bindCustomTabsService(any(), eq(packageName), any()) }
    }

    @Test
    fun bindCustomTabsService_withInvalidPackageName_returnsFalse() {
        mockkStatic(CustomTabsClient::class)
        every { CustomTabsClient.bindCustomTabsService(any(), any(), any()) } returns false

        val context = mockk<Context>()
        val result = controller.bindCustomTabsService(context)
        assertThat(result).isFalse()
        assertThat(controller.isCustomTabsServiceBound).isFalse()

        verify { CustomTabsClient.bindCustomTabsService(any(), eq(packageName), any()) }
    }

    @Test
    fun bindCustomTabsService_withSecurityException_returnsFalse() {
        mockkStatic(CustomTabsClient::class)

        val ex = SecurityException()
        every { CustomTabsClient.bindCustomTabsService(any(), any(), any()) } throws ex

        val context = mockk<Context>()
        val result = controller.bindCustomTabsService(context)
        assertThat(result).isFalse()
        assertThat(controller.isCustomTabsServiceBound).isFalse()

        verify { CustomTabsClient.bindCustomTabsService(any(), eq(packageName), any()) }
    }

    @Test
    fun unbindCustomTabsService_whenBound_unbindsService() {
        mockkStatic(CustomTabsClient::class)
        every { CustomTabsClient.bindCustomTabsService(any(), any(), any()) } returns true

        val context = mockk<Context>(relaxed = true)
        controller.bindCustomTabsService(context)
        controller.unbindCustomTabsService()

        assertThat(controller.isCustomTabsServiceBound).isFalse()
        assertThat(controller.session).isNull()

        verify { context.unbindService(refEq(controller)) }
    }

    @Test
    fun onCustomTabsServiceConnected_setsSession() {
        val session = mockk<CustomTabsSession>()
        val client = mockk<CustomTabsClient>(relaxed = true) {
            every { newSession(any()) } returns session
        }

        val name = ComponentName("com.example", "CustomTabsService")
        controller.onCustomTabsServiceConnected(name, client)

        assertThat(controller.session).isNotNull()
    }

    @Test
    fun onServiceDisconnected_clearsSession() {
        val name = ComponentName("com.example", "CustomTabsService")
        controller.onServiceDisconnected(name)

        assertThat(controller.session).isNull()
        assertThat(controller.isCustomTabsServiceBound).isFalse()
    }

    @Test
    fun mayLaunchUrls_withSessionAndSingleUrl_callsMayLaunchUrl() {
        val session = mockk<CustomTabsSession> {
            every { mayLaunchUrl(any(), any(), any()) } returns true
        }
        controller.session = session

        val url = "https://example.com".toUri()
        controller.mayLaunchUrls(listOf(url.toString()))

        verify { session.mayLaunchUrl(eq(url), isNull(), isNull()) }
    }

    @Test
    fun mayLaunchUrls_withSessionAndMultipleUrls_callsMayLaunchUrlWithBundles() {
        val session = mockk<CustomTabsSession> {
            every { mayLaunchUrl(any(), any(), any()) } returns true
        }
        controller.session = session

        val url1 = "https://example.com".toUri()
        val url2 = "https://flutter.dev".toUri()
        controller.mayLaunchUrls(listOf(url1.toString(), url2.toString()))

        val slot = mutableListOf<List<Bundle>>()
        verify { session.mayLaunchUrl(isNull(), isNull(), capture(slot)) }

        val bundles = slot.first()
        assertThat(bundles).hasSize(2)

        val bundle1 = bundles[0]
        assertThat(bundle1).parcelable<Parcelable>(KEY_URL).isEqualTo(url1)

        val bundle2 = bundles[1]
        assertThat(bundle2).parcelable<Parcelable>(KEY_URL).isEqualTo(url2)
    }

    @Test
    fun mayLaunchUrls_withNullSession_logsWarning() {
        controller.session = null

        val url = "https://example.com".toUri()
        controller.mayLaunchUrls(listOf(url.toString()))

        // Since session is null, mayLaunchUrl should not be called
        // We verify that session remains null and no exception is thrown
        assertThat(controller.session).isNull()
    }

    @Test
    fun mayLaunchUrls_withEmptyUrlList_logsWarning() {
        val session = mockk<CustomTabsSession>()
        controller.session = session

        controller.mayLaunchUrls(emptyList())

        verify(exactly = 0) { session.mayLaunchUrl(any(), any(), any()) }
    }
}