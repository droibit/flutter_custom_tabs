package com.github.droibit.flutter.plugins.customtabs.core

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Browser
import androidx.core.net.toUri
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.ext.truth.content.IntentSubject.assertThat
import androidx.test.ext.truth.os.BundleSubject.assertThat
import com.github.droibit.flutter.plugins.customtabs.core.options.BrowserConfiguration
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions
import com.google.common.truth.Truth.assertThat
import io.mockk.every
import io.mockk.impl.annotations.InjectMockKs
import io.mockk.impl.annotations.MockK
import io.mockk.junit4.MockKRule
import io.mockk.spyk
import io.mockk.verify
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.annotation.Config

@RunWith(AndroidJUnit4::class)
@Config(manifest = Config.NONE)
class ExternalBrowserLauncherTest {
    @get:Rule
    val mockkRule = MockKRule(this)

    @MockK(relaxed = true)
    private lateinit var context: Context

    @InjectMockKs
    private lateinit var launcher: ExternalBrowserLauncher

    @Test
    fun launch_withNullIntent_returnsFalse() {
        val launcher = spyk(this.launcher) {
            every { createIntent(any()) } returns null
        }

        val uri = "https://example.com".toUri()
        val result = launcher.launch(context, uri, null)
        assertThat(result).isFalse()

        verify(exactly = 0) { context.startActivity(any()) }
    }

    @Test
    fun launch_withValidIntent_returnsTrue() {
        val intent = Intent()
        val launcher = spyk(this.launcher) {
            every { createIntent(any()) } returns intent
        }

        val uri = Uri.parse("https://example.com")
        val result = launcher.launch(context, uri, null)
        assertThat(result).isTrue()

        assertThat(intent).hasData(uri)
        verify { context.startActivity(refEq(intent)) }
    }

    @Test
    fun createIntent_nullOptions() {
        val result = launcher.createIntent(null)
        assertThat(result).isNotNull()
        assertThat(result).hasAction(Intent.ACTION_VIEW)
        assertThat(result).extras().isNull()
    }

    @Test
    fun createIntent_emptyBrowserConfiguration() {
        val options = CustomTabsIntentOptions.Builder()
            .setBrowser(null)
            .build()
        val result = launcher.createIntent(options)
        assertThat(result).isNull()
    }

    @Test
    fun createIntent_noPriority() {
        val options = CustomTabsIntentOptions.Builder()
            .setBrowser(
                BrowserConfiguration.Builder()
                    .setPrefersExternalBrowser(null)
                    .build()
            )
            .build()
        val result = launcher.createIntent(options)
        assertThat(result).isNull()
    }

    @Test
    fun createIntent_prefersCustomTabs() {
        val options = CustomTabsIntentOptions.Builder()
            .setBrowser(
                BrowserConfiguration.Builder()
                    .setPrefersExternalBrowser(false)
                    .build()
            )
            .build()
        val result = launcher.createIntent(options)
        assertThat(result).isNull()
    }

    @Test
    fun createIntent_noHeaders() {
        val options = CustomTabsIntentOptions.Builder()
            .setBrowser(
                BrowserConfiguration.Builder()
                    .setPrefersExternalBrowser(true)
                    .build()
            )
            .build()
        val result = launcher.createIntent(options)
        assertThat(result).isNotNull()
        assertThat(result).hasAction(Intent.ACTION_VIEW)
        assertThat(result).extras().isNull()
    }

    @Test
    fun createIntent_addedHeaders() {
        val expHeader = "key" to "value"
        val options = CustomTabsIntentOptions.Builder()
            .setBrowser(
                BrowserConfiguration.Builder()
                    .setPrefersExternalBrowser(true)
                    .setHeaders(mapOf(expHeader))
                    .build()
            )
            .build()
        val result = launcher.createIntent(options)
        assertThat(result).isNotNull()
        assertThat(result).hasAction(Intent.ACTION_VIEW)
        assertThat(result).extras().hasSize(1)

        val actualHeaders = requireNotNull(result).getBundleExtra(Browser.EXTRA_HEADERS)
        assertThat(actualHeaders).isNotNull()
        assertThat(actualHeaders).hasSize(1)
        assertThat(actualHeaders).string(expHeader.first).isEqualTo(expHeader.second)
    }
}