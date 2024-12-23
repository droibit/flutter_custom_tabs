package com.github.droibit.flutter.plugins.customtabs.core

import android.app.Activity
import androidx.browser.customtabs.CustomTabsIntent
import androidx.core.net.toUri
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.ext.truth.content.IntentSubject.assertThat
import com.google.common.truth.Truth.assertThat
import io.mockk.impl.annotations.InjectMockKs
import io.mockk.impl.annotations.MockK
import io.mockk.junit4.MockKRule
import io.mockk.verify
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.annotation.Config

@RunWith(AndroidJUnit4::class)
@Config(manifest = Config.NONE)
class PartialCustomTabsLauncherTest {
    @get:Rule
    val mockkRule = MockKRule(this)

    @MockK(relaxed = true)
    private lateinit var activity: Activity

    @InjectMockKs
    private lateinit var launcher: PartialCustomTabsLauncher

    @Test
    fun launch_withValidCustomTabsIntent_returnsTrue() {
        val customTabsIntent = CustomTabsIntent.Builder()
            .setInitialActivityHeightPx(100)
            .build()

        val uri = "https://example.com".toUri()
        val result = launcher.launch(activity, uri, customTabsIntent)
        assertThat(result).isTrue()
        assertThat(customTabsIntent.intent).hasData(uri)

        verify { activity.startActivityForResult(refEq(customTabsIntent.intent), eq(1001)) }
    }

    @Test
    fun launch_withoutRequiredExtras_returnsFalse() {
        val customTabsIntent = CustomTabsIntent.Builder().build()

        val uri = "https://example.com".toUri()
        val result = launcher.launch(activity, uri, customTabsIntent)
        assertThat(result).isFalse()

        verify(exactly = 0) { activity.startActivityForResult(any(), any()) }
    }
}