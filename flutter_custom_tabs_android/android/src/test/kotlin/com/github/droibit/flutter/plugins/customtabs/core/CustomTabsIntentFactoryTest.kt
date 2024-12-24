package com.github.droibit.flutter.plugins.customtabs.core

import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.os.Parcelable
import android.provider.Browser.EXTRA_HEADERS
import androidx.browser.customtabs.CustomTabColorSchemeParams
import androidx.browser.customtabs.CustomTabsIntent
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_DEFAULT
import androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_FIXED
import androidx.browser.customtabs.CustomTabsIntent.EXTRA_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR
import androidx.browser.customtabs.CustomTabsIntent.EXTRA_CLOSE_BUTTON_ICON
import androidx.browser.customtabs.CustomTabsIntent.EXTRA_CLOSE_BUTTON_POSITION
import androidx.browser.customtabs.CustomTabsIntent.EXTRA_ENABLE_INSTANT_APPS
import androidx.browser.customtabs.CustomTabsIntent.EXTRA_ENABLE_URLBAR_HIDING
import androidx.browser.customtabs.CustomTabsIntent.EXTRA_INITIAL_ACTIVITY_HEIGHT_PX
import androidx.browser.customtabs.CustomTabsIntent.EXTRA_SHARE_STATE
import androidx.browser.customtabs.CustomTabsIntent.EXTRA_TITLE_VISIBILITY_STATE
import androidx.browser.customtabs.CustomTabsIntent.EXTRA_TOOLBAR_CORNER_RADIUS_DP
import androidx.browser.customtabs.CustomTabsIntent.SHARE_STATE_OFF
import androidx.browser.customtabs.CustomTabsIntent.SHOW_PAGE_TITLE
import androidx.core.content.res.ResourcesCompat.ID_NULL
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.ext.truth.content.IntentSubject.assertThat
import androidx.test.ext.truth.os.BundleSubject.assertThat
import com.droibit.android.customtabs.launcher.NonChromeCustomTabs
import com.droibit.android.customtabs.launcher.setChromeCustomTabsPackage
import com.droibit.android.customtabs.launcher.setCustomTabsPackage
import com.github.droibit.flutter.plugins.customtabs.core.options.BrowserConfiguration
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsAnimations
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsCloseButton
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsColorSchemes
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions
import com.github.droibit.flutter.plugins.customtabs.core.options.PartialCustomTabsConfiguration
import com.github.droibit.flutter.plugins.customtabs.core.session.CustomTabsSessionProvider
import com.google.common.truth.Truth.assertThat
import io.mockk.every
import io.mockk.impl.annotations.InjectMockKs
import io.mockk.impl.annotations.MockK
import io.mockk.junit4.MockKRule
import io.mockk.justRun
import io.mockk.mockk
import io.mockk.mockkStatic
import io.mockk.slot
import io.mockk.spyk
import io.mockk.unmockkAll
import io.mockk.verify
import org.junit.After
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.annotation.Config

@RunWith(AndroidJUnit4::class)
@Config(manifest = Config.NONE)
class CustomTabsIntentFactoryTest {
    @get:Rule
    val mockkRule = MockKRule(this)

    @MockK
    private lateinit var resources: ResourceFactory

    @MockK(relaxed = true)
    private lateinit var sessionProvider: CustomTabsSessionProvider

    @MockK
    private lateinit var context: Context

    @InjectMockKs
    private lateinit var factory: CustomTabsIntentFactory

    @After
    fun tearDown() {
        unmockkAll()
    }

    @Test
    fun createIntent_completeOptions() {
        val expColorSchemes = mockk<CustomTabsColorSchemes>()
        val expUrlBarHidingEnabled = true
        val expShareState = SHARE_STATE_OFF
        val expShowTitle = true
        val expInstantAppsEnabled = false
        val expCloseButton = mockk<CustomTabsCloseButton>()
        val expAnimations = mockk<CustomTabsAnimations>()
        val expPartial = mockk<PartialCustomTabsConfiguration>()
        val expBrowser = mockk<BrowserConfiguration>(relaxed = true)
        val options = CustomTabsIntentOptions.Builder()
            .setColorSchemes(expColorSchemes)
            .setCloseButton(expCloseButton)
            .setUrlBarHidingEnabled(expUrlBarHidingEnabled)
            .setShareState(expShareState)
            .setShowTitle(expShowTitle)
            .setInstantAppsEnabled(expInstantAppsEnabled)
            .setAnimations(expAnimations)
            .setPartial(expPartial)
            .setBrowser(expBrowser)
            .build()

        val factory = spyk(this.factory) {
            justRun { applyColorSchemes(any(), any()) }
            justRun { applyCloseButton(any(), any(), any()) }
            justRun { applyAnimations(any(), any(), any()) }
            justRun { applyPartialCustomTabsConfiguration(any(), any(), any()) }
            justRun { applyBrowserConfiguration(any(), any(), any()) }
        }

        val customTabsIntent = factory.createIntent(context, options, sessionProvider)
        val extras = assertThat(customTabsIntent.intent).extras()

        val colorSchemesSlot = slot<CustomTabsColorSchemes>()
        verify { factory.applyColorSchemes(any(), capture(colorSchemesSlot)) }

        assertThat(colorSchemesSlot.captured).isSameInstanceAs(expColorSchemes)

        val closeButtonSlot = slot<CustomTabsCloseButton>()
        verify { factory.applyCloseButton(any(), any(), capture(closeButtonSlot)) }
        assertThat(closeButtonSlot.captured).isSameInstanceAs(expCloseButton)

        extras.bool(EXTRA_ENABLE_URLBAR_HIDING).isEqualTo(expUrlBarHidingEnabled)
        extras.integer(EXTRA_SHARE_STATE).isEqualTo(expShareState)
        extras.integer(EXTRA_TITLE_VISIBILITY_STATE).isEqualTo(SHOW_PAGE_TITLE)
        extras.bool(EXTRA_ENABLE_INSTANT_APPS).isEqualTo(expInstantAppsEnabled)

        val animationsSlot = slot<CustomTabsAnimations>()
        verify { factory.applyAnimations(any(), any(), capture(animationsSlot)) }
        assertThat(animationsSlot.captured).isSameInstanceAs(expAnimations)

        val partialSlot = slot<PartialCustomTabsConfiguration>()
        verify { factory.applyPartialCustomTabsConfiguration(any(), any(), capture(partialSlot)) }
        assertThat(partialSlot.captured).isSameInstanceAs(expPartial)

        val browserSlot = slot<BrowserConfiguration>()
        verify { factory.applyBrowserConfiguration(any(), any(), capture(browserSlot)) }
        assertThat(browserSlot.captured).isSameInstanceAs(expBrowser)
    }

    @Test
    fun createIntent_minimumOptions() {
        val options = CustomTabsIntentOptions.Builder()
            .build()
        val factory = spyk(this.factory) {
            justRun { applyColorSchemes(any(), any()) }
            justRun { applyCloseButton(any(), any(), any()) }
            justRun { applyAnimations(any(), any(), any()) }
            justRun { applyPartialCustomTabsConfiguration(any(), any(), any()) }
            justRun { applyBrowserConfiguration(any(), any(), any()) }
        }

        val customTabsIntent = factory.createIntent(context, options, sessionProvider)
        val extras = assertThat(customTabsIntent.intent).extras()
        extras.doesNotContainKey(EXTRA_ENABLE_URLBAR_HIDING)
        extras.doesNotContainKey(EXTRA_TITLE_VISIBILITY_STATE)
        // It seems that CustomTabsIntent includes these extras by default.
        extras.containsKey(EXTRA_SHARE_STATE)
        extras.containsKey(EXTRA_ENABLE_INSTANT_APPS)

        verify(exactly = 0) {
            factory.applyColorSchemes(any(), any())
            factory.applyCloseButton(any(), any(), any())
            factory.applyAnimations(any(), any(), any())
            factory.applyPartialCustomTabsConfiguration(any(), any(), any())
        }

        val browserConfigSlot = slot<BrowserConfiguration>()
        verify { factory.applyBrowserConfiguration(any(), any(), capture(browserConfigSlot)) }

        val actualBrowserConfig = browserConfigSlot.captured
        assertThat(actualBrowserConfig.prefersExternalBrowser).isNull()
        assertThat(actualBrowserConfig.prefersDefaultBrowser).isNull()
        assertThat(actualBrowserConfig.fallbackCustomTabPackages).isNull()
        assertThat(actualBrowserConfig.headers).isNull()
    }

    /**
     * @noinspection DataFlowIssue
     */
    @Test
    fun applyColorSchemes_completeOptions() {
        val expLightParams = CustomTabColorSchemeParams.Builder()
            .setToolbarColor(0xFFFFDBA0.toInt())
            .setNavigationBarDividerColor(0xFFFFDBA1.toInt())
            .setNavigationBarColor(0xFFFFDBA2.toInt())
            .build()
        val expDarkParams = CustomTabColorSchemeParams.Builder()
            .setToolbarColor(0xFFFFDBA3.toInt())
            .setNavigationBarDividerColor(0xFFFFDBA4.toInt())
            .setNavigationBarColor(0xFFFFDBA5.toInt())
            .build()
        val expDefaultParams = CustomTabColorSchemeParams.Builder()
            .setToolbarColor(0xFFFFDBA5.toInt())
            .setNavigationBarDividerColor(0xFFFFDBA6.toInt())
            .setNavigationBarColor(0xFFFFDBA7.toInt())
            .build()
        val expColorScheme = CustomTabsIntent.COLOR_SCHEME_SYSTEM
        val options = CustomTabsColorSchemes.Builder()
            .setColorScheme(expColorScheme)
            .setLightParams(
                CustomTabColorSchemeParams.Builder()
                    .setToolbarColor(expLightParams.toolbarColor ?: 0)
                    .setNavigationBarColor(expLightParams.navigationBarColor ?: 0)
                    .setNavigationBarDividerColor(expLightParams.navigationBarDividerColor ?: 0)
                    .build()
            )
            .setDarkParams(
                CustomTabColorSchemeParams.Builder()
                    .setToolbarColor(expDarkParams.toolbarColor ?: 0)
                    .setNavigationBarColor(expDarkParams.navigationBarColor ?: 0)
                    .setNavigationBarDividerColor(expDarkParams.navigationBarDividerColor ?: 0)
                    .build()
            )
            .setDefaultParams(
                CustomTabColorSchemeParams.Builder()
                    .setToolbarColor(expDefaultParams.toolbarColor ?: 0)
                    .setNavigationBarColor(expDefaultParams.navigationBarColor ?: 0)
                    .setNavigationBarDividerColor(expDefaultParams.navigationBarDividerColor ?: 0)
                    .build()
            )
            .build()
        val builder = mockk<CustomTabsIntent.Builder>(relaxed = true)
        factory.applyColorSchemes(builder, options)

        val schemeSlot = mutableListOf<Int>()
        val paramsSlot = mutableListOf<CustomTabColorSchemeParams>()
        verify { builder.setColorScheme(capture(schemeSlot)) }
        verify(exactly = 2) {
            builder.setColorSchemeParams(capture(schemeSlot), capture(paramsSlot))
        }
        verify { builder.setDefaultColorSchemeParams(capture(paramsSlot)) }

        assertThat(schemeSlot).containsExactly(
            expColorScheme,
            CustomTabsIntent.COLOR_SCHEME_LIGHT,
            CustomTabsIntent.COLOR_SCHEME_DARK
        )
        assertThat(paramsSlot).hasSize(3)

        val actualLightParams = paramsSlot[0]
        assertThat(actualLightParams.toolbarColor).isEqualTo(expLightParams.toolbarColor)
        assertThat(actualLightParams.navigationBarColor)
            .isEqualTo(expLightParams.navigationBarColor)
        assertThat(actualLightParams.navigationBarDividerColor)
            .isEqualTo(expLightParams.navigationBarDividerColor)

        val actualDarkParams = paramsSlot[1]
        assertThat(actualDarkParams.toolbarColor).isEqualTo(expDarkParams.toolbarColor)
        assertThat(actualDarkParams.navigationBarColor)
            .isEqualTo(expDarkParams.navigationBarColor)
        assertThat(actualDarkParams.navigationBarDividerColor)
            .isEqualTo(expDarkParams.navigationBarDividerColor)

        val actualDefaultParams = paramsSlot[2]
        assertThat(actualDefaultParams.toolbarColor)
            .isEqualTo(expDefaultParams.toolbarColor)
        assertThat(actualDefaultParams.navigationBarColor)
            .isEqualTo(expDefaultParams.navigationBarColor)
        assertThat(actualDefaultParams.navigationBarDividerColor)
            .isEqualTo(expDefaultParams.navigationBarDividerColor)
    }

    @Test
    fun applyColorSchemes_minimumOptions() {
        val options = CustomTabsColorSchemes.Builder().build()
        val builder = mockk<CustomTabsIntent.Builder>()
        factory.applyColorSchemes(builder, options)

        verify(exactly = 0) {
            builder.setColorScheme(any())
            builder.setColorSchemeParams(any(), any())
            builder.setDefaultColorSchemeParams(any())
        }
    }

    @Test
    fun applyCloseButton_completeOptions() {
        val expIcon = mockk<Bitmap>()
        every { resources.getBitmap(any(), any()) } returns expIcon

        val expPosition = CustomTabsIntent.CLOSE_BUTTON_POSITION_DEFAULT
        val options = CustomTabsCloseButton.Builder()
            .setIcon("icon")
            .setPosition(expPosition)
            .build()

        val builder = CustomTabsIntent.Builder()
        factory.applyCloseButton(context, builder, options)

        val customTabsIntent = builder.build()
        val extras = assertThat(customTabsIntent.intent).extras()
        extras.isNotNull()
        extras.parcelable<Parcelable>(EXTRA_CLOSE_BUTTON_ICON).isSameInstanceAs(expIcon)
        extras.integer(EXTRA_CLOSE_BUTTON_POSITION).isEqualTo(expPosition)
    }

    @Test
    fun applyCloseButton_minimumOptions() {
        val options = CustomTabsCloseButton.Builder().build()
        val builder = CustomTabsIntent.Builder()
        factory.applyCloseButton(context, builder, options)

        val customTabsIntent = builder.build()
        val extras = assertThat(customTabsIntent.intent).extras()
        extras.doesNotContainKey(EXTRA_CLOSE_BUTTON_ICON)
        extras.doesNotContainKey(EXTRA_CLOSE_BUTTON_POSITION)
    }

    @Test
    fun applyCloseButton_invalidIcon() {
        every { resources.getBitmap(any(), any()) } returns null

        val options = CustomTabsCloseButton.Builder()
            .setIcon("icon")
            .build()
        val builder = CustomTabsIntent.Builder()
        factory.applyCloseButton(context, builder, options)

        val customTabsIntent = builder.build()
        val extras = assertThat(customTabsIntent.intent).extras()
        extras.doesNotContainKey(EXTRA_CLOSE_BUTTON_ICON)
        extras.doesNotContainKey(EXTRA_CLOSE_BUTTON_POSITION)
    }

    @Test
    fun applyAnimations_completeOptions() {
        val expStartEnter = 1
        val expStartExit = 2
        val expEndEnter = 3
        val expEndExit = 4
        every { resources.getAnimationIdentifier(any(), eq("start_enter")) } returns expStartEnter
        every { resources.getAnimationIdentifier(any(), eq("start_exit")) } returns expStartExit
        every { resources.getAnimationIdentifier(any(), eq("end_enter")) } returns expEndEnter
        every { resources.getAnimationIdentifier(any(), eq("end_exit")) } returns expEndExit

        val options = CustomTabsAnimations.Builder()
            .setStartEnter("start_enter")
            .setStartExit("start_exit")
            .setEndEnter("end_enter")
            .setEndExit("end_exit")
            .build()
        val builder = mockk<CustomTabsIntent.Builder>(relaxed = true)
        factory.applyAnimations(context, builder, options)

        val startEnterSlot = slot<Int>()
        val startExitSlot = slot<Int>()
        verify {
            builder.setStartAnimations(
                any(),
                capture(startEnterSlot),
                capture(startExitSlot)
            )
        }
        assertThat(startEnterSlot.captured).isEqualTo(expStartEnter)
        assertThat(startExitSlot.captured).isEqualTo(expStartExit)

        val endEnterSlot = slot<Int>()
        val endExitSlot = slot<Int>()
        verify { builder.setExitAnimations(any(), capture(endEnterSlot), capture(endExitSlot)) }
        assertThat(endEnterSlot.captured).isEqualTo(expEndEnter)
        assertThat(endExitSlot.captured).isEqualTo(expEndExit)
    }

    @Test
    fun applyAnimations_emptyOptions() {
        every { resources.getAnimationIdentifier(any(), any()) } returns ID_NULL


        val options = CustomTabsAnimations.Builder().build()
        val builder = mockk<CustomTabsIntent.Builder>()
        factory.applyAnimations(context, builder, options)

        verify(exactly = 0) {
            builder.setStartAnimations(any(), any(), any())
            builder.setExitAnimations(any(), any(), any())
        }
    }

    @Test
    fun applyPartialCustomTabsConfiguration_completeOptions() {
        val expCornerRadius = 8
        val options = PartialCustomTabsConfiguration.Builder()
            .setActivityHeightResizeBehavior(ACTIVITY_HEIGHT_FIXED)
            .setInitialHeight(100.0)
            .setCornerRadius(expCornerRadius)
            .build()

        val expInitialActivityHeight = 100
        every { resources.convertToPx(any(), any()) } returns expInitialActivityHeight

        val builder = CustomTabsIntent.Builder()
        factory.applyPartialCustomTabsConfiguration(context, builder, options)

        val customTabsIntent = builder.build()
        val extras = assertThat(customTabsIntent.intent).extras()
        extras.integer(EXTRA_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR).isEqualTo(ACTIVITY_HEIGHT_FIXED)
        extras.integer(EXTRA_INITIAL_ACTIVITY_HEIGHT_PX).isEqualTo(expInitialActivityHeight)
        extras.integer(EXTRA_TOOLBAR_CORNER_RADIUS_DP).isEqualTo(expCornerRadius)
    }

    @Test
    fun applyPartialCustomTabsConfiguration_minimumOptions() {
        val options = PartialCustomTabsConfiguration.Builder()
            .setInitialHeight(200.0)
            .build()

        val expInitialActivityHeight = 200
        every { resources.convertToPx(any(), any()) } returns expInitialActivityHeight

        val builder = CustomTabsIntent.Builder()
        factory.applyPartialCustomTabsConfiguration(context, builder, options)

        val customTabsIntent = builder.build()
        val extras = assertThat(customTabsIntent.intent).extras()
        extras.integer(EXTRA_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR).isEqualTo(ACTIVITY_HEIGHT_DEFAULT)
        extras.integer(EXTRA_INITIAL_ACTIVITY_HEIGHT_PX).isEqualTo(expInitialActivityHeight)
        extras.doesNotContainKey(EXTRA_TOOLBAR_CORNER_RADIUS_DP)
    }

    @Test
    fun applyBrowserConfiguration_completeOptionsWithPrefersChrome() {
        mockkStatic("com.droibit.android.customtabs.launcher.CustomTabsIntentHelper")

        val customTabsIntent = spyk(CustomTabsIntent.Builder().build())
        every {
            customTabsIntent.setChromeCustomTabsPackage(any(), any())
        } returns customTabsIntent

        val expHeader = "key" to "value"
        val options = BrowserConfiguration.Builder()
            .setHeaders(mapOf(expHeader))
            .setFallbackCustomTabs(setOf("com.example.customtabs"))
            .setPrefersExternalBrowser(false)
            .setPrefersDefaultBrowser(false)
            .build()
        factory.applyBrowserConfiguration(context, customTabsIntent, options)

        assertThat(customTabsIntent.intent).extras().containsKey(EXTRA_HEADERS)
        val actualHeaders = customTabsIntent.intent.getBundleExtra(EXTRA_HEADERS)
        assertThat(actualHeaders).isNotNull()
        assertThat(actualHeaders).hasSize(1)
        assertThat(actualHeaders).string(expHeader.first).isEqualTo(expHeader.second)

        verify {
            customTabsIntent.setChromeCustomTabsPackage(
                any(),
                ofType(NonChromeCustomTabs::class)
            )
        }
    }

    @Suppress("deprecation")
    @Test
    fun applyBrowserConfiguration_minimumOptionsWithPrefersChrome() {
        mockkStatic("com.droibit.android.customtabs.launcher.CustomTabsIntentHelper")

        val customTabsIntent = spyk(CustomTabsIntent.Builder().build())
        every {
            customTabsIntent.setChromeCustomTabsPackage(any(), any())
        } returns customTabsIntent

        val pm = mockk<PackageManager> {
            every { queryIntentActivities(any(), any<Int>()) } returns emptyList()
        }
        every { context.packageManager } returns pm

        val options = BrowserConfiguration.Builder()
            .setPrefersExternalBrowser(false)
            .build()
        factory.applyBrowserConfiguration(context, customTabsIntent, options)

        assertThat(customTabsIntent.intent)
            .extras()
            .doesNotContainKey(EXTRA_HEADERS)

        verify {
            customTabsIntent.setChromeCustomTabsPackage(
                any(),
                ofType(NonChromeCustomTabs::class)
            )
        }
    }

    @Suppress("deprecation")
    @Test
    fun applyBrowserConfiguration_prefersDefaultBrowser() {
        mockkStatic("com.droibit.android.customtabs.launcher.CustomTabsIntentHelper")

        val customTabsIntent = spyk(CustomTabsIntent.Builder().build())
        every { customTabsIntent.setCustomTabsPackage(any(), any()) } returns customTabsIntent

        val pm = mockk<PackageManager> {
            every { queryIntentActivities(any(), any<Int>()) } returns emptyList()
        }
        every { context.packageManager } returns pm

        val options = BrowserConfiguration.Builder()
            .setPrefersExternalBrowser(false)
            .setPrefersDefaultBrowser(true)
            .build()
        factory.applyBrowserConfiguration(context, customTabsIntent, options)

        assertThat(customTabsIntent.intent)
            .extras()
            .doesNotContainKey(EXTRA_HEADERS)

        verify {
            customTabsIntent.setCustomTabsPackage(
                any(),
                ofType(NonChromeCustomTabs::class)
            )
        }
    }

    @Test
    fun applyBrowserConfiguration_customTabsSession() {
        mockkStatic("com.droibit.android.customtabs.launcher.CustomTabsIntentHelper")

        val expSessionPackageName = "com.example.customtabs"
        val options = BrowserConfiguration.Builder()
            .setSessionPackageName(expSessionPackageName)
            .build()
        val customTabsIntent = CustomTabsIntent.Builder().build()
        factory.applyBrowserConfiguration(context, customTabsIntent, options)

        assertThat(customTabsIntent.intent).hasPackage(expSessionPackageName)

        verify(exactly = 0) {
            customTabsIntent.setChromeCustomTabsPackage(any(), any())
            customTabsIntent.setCustomTabsPackage(any(), any())
        }
    }

    @Test
    fun applyBrowserConfiguration_avoidOverridingPackage() {
        mockkStatic("com.droibit.android.customtabs.launcher.CustomTabsIntentHelper")

        val customTabsIntent = CustomTabsIntent.Builder().build()
        val expPackageName = "com.example.customtabs"
        customTabsIntent.intent.setPackage(expPackageName)

        val sessionPackageName = "com.example.session.customtabs"
        val options = BrowserConfiguration.Builder()
            .setSessionPackageName(sessionPackageName)
            .build()
        factory.applyBrowserConfiguration(context, customTabsIntent, options)

        assertThat(customTabsIntent.intent).hasPackage(expPackageName)

        verify(exactly = 0) {
            customTabsIntent.setChromeCustomTabsPackage(any(), any())
            customTabsIntent.setCustomTabsPackage(any(), any())
        }
    }

    @Test
    fun createIntentOptions_nullOptions() {
        val options = factory.createIntentOptions(null)
        assertThat(options).isNull()
    }

    @Test
    fun createIntentOptions_notNullOptions() {
        val options = factory.createIntentOptions(emptyMap())
        assertThat(options).isNotNull()
    }
}