package com.github.droibit.flutter.plugins.customtabs.core;

import static androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_DEFAULT;
import static androidx.browser.customtabs.CustomTabsIntent.ACTIVITY_HEIGHT_FIXED;
import static androidx.browser.customtabs.CustomTabsIntent.CLOSE_BUTTON_POSITION_DEFAULT;
import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_DARK;
import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_LIGHT;
import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_SYSTEM;
import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR;
import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_CLOSE_BUTTON_ICON;
import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_CLOSE_BUTTON_POSITION;
import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_ENABLE_INSTANT_APPS;
import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_ENABLE_URLBAR_HIDING;
import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_INITIAL_ACTIVITY_HEIGHT_PX;
import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_SHARE_STATE;
import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_TITLE_VISIBILITY_STATE;
import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_TOOLBAR_CORNER_RADIUS_DP;
import static androidx.browser.customtabs.CustomTabsIntent.SHARE_STATE_OFF;
import static androidx.browser.customtabs.CustomTabsIntent.SHOW_PAGE_TITLE;
import static androidx.test.ext.truth.content.IntentSubject.assertThat;
import static androidx.test.ext.truth.os.BundleSubject.assertThat;
import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.setChromeCustomTabsPackage;
import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.setCustomTabsPackage;
import static com.github.droibit.flutter.plugins.customtabs.core.ResourceFactory.INVALID_RESOURCE_ID;
import static com.google.common.truth.Truth.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyDouble;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNotNull;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static java.util.Collections.emptyList;
import static java.util.Collections.emptyMap;
import static java.util.Collections.singletonList;
import static java.util.Collections.singletonMap;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.provider.Browser;

import androidx.browser.customtabs.CustomTabColorSchemeParams;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.ext.truth.os.BundleSubject;

import com.droibit.android.customtabs.launcher.CustomTabsIntentHelper;
import com.droibit.android.customtabs.launcher.NonChromeCustomTabs;
import com.github.droibit.flutter.plugins.customtabs.core.options.BrowserConfiguration;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsAnimations;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsCloseButton;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsColorSchemes;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions;
import com.github.droibit.flutter.plugins.customtabs.core.options.PartialCustomTabsConfiguration;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;
import org.robolectric.annotation.Config;

import java.util.AbstractMap.SimpleEntry;
import java.util.Collections;
import java.util.List;

@RunWith(AndroidJUnit4.class)
@Config(manifest = Config.NONE)
public class IntentFactoryTest {
    @Rule
    public MockitoRule mockitoRule = MockitoJUnit.rule();

    @Mock
    private ResourceFactory resources;

    @Mock
    private Context context;

    @InjectMocks
    private IntentFactory intentFactory;

    @Test
    public void createExternalBrowserIntent_nullOptions() {
        final Intent result = intentFactory.createExternalBrowserIntent(null);
        assertThat(result).isNotNull();
        assertThat(result).hasAction(Intent.ACTION_VIEW);
        assertThat(result).extras().isNull();
    }

    @Test
    public void createExternalBrowserIntent_emptyBrowserConfiguration() {
        final CustomTabsIntentOptions options = new CustomTabsIntentOptions.Builder()
                .setBrowser(null)
                .build();
        final Intent result = intentFactory.createExternalBrowserIntent(options);
        assertThat(result).isNull();
    }

    @Test
    public void createExternalBrowserIntent_prefersCustomTabs() {
        final CustomTabsIntentOptions options = new CustomTabsIntentOptions.Builder()
                .setBrowser(
                        new BrowserConfiguration.Builder()
                                .setPrefersExternalBrowser(false)
                                .build()
                )
                .build();
        final Intent result = intentFactory.createExternalBrowserIntent(options);
        assertThat(result).isNull();
    }

    @Test
    public void createExternalBrowserIntent_noHeaders() {
        final CustomTabsIntentOptions options = new CustomTabsIntentOptions.Builder()
                .setBrowser(
                        new BrowserConfiguration.Builder()
                                .setPrefersExternalBrowser(true)
                                .build()
                )
                .build();
        final Intent result = intentFactory.createExternalBrowserIntent(options);
        assertThat(result).isNotNull();
        assertThat(result).hasAction(Intent.ACTION_VIEW);
        assertThat(result).extras().isNull();
    }

    @Test
    public void createExternalBrowserIntent_addedHeaders() {
        final SimpleEntry<String, String> expHeader = new SimpleEntry<>("key", "value");
        final CustomTabsIntentOptions options = new CustomTabsIntentOptions.Builder()
                .setBrowser(
                        new BrowserConfiguration.Builder()
                                .setPrefersExternalBrowser(true)
                                .setHeaders(singletonMap(expHeader.getKey(), expHeader.getValue()))
                                .build()
                )
                .build();
        final Intent result = intentFactory.createExternalBrowserIntent(options);
        assertThat(result).isNotNull();
        assertThat(result).hasAction(Intent.ACTION_VIEW);
        assertThat(result).extras().hasSize(1);

        //noinspection DataFlowIssue
        final Bundle actualHeaders = result.getBundleExtra(Browser.EXTRA_HEADERS);
        assertThat(actualHeaders).isNotNull();
        assertThat(actualHeaders).hasSize(1);
        assertThat(actualHeaders).string(expHeader.getKey()).isEqualTo(expHeader.getValue());
    }

    @Test
    public void createCustomTabsIntent_completeOptions() {
        final CustomTabsColorSchemes expColorSchemes = mock(CustomTabsColorSchemes.class);
        final boolean expUrlBarHidingEnabled = true;
        final int expShareState = SHARE_STATE_OFF;
        final boolean expShowTitle = true;
        final boolean expInstantAppsEnabled = false;
        final CustomTabsCloseButton expCloseButton = mock(CustomTabsCloseButton.class);
        final CustomTabsAnimations expAnimations = mock(CustomTabsAnimations.class);
        final PartialCustomTabsConfiguration expPartial = mock(PartialCustomTabsConfiguration.class);
        final BrowserConfiguration expBrowser = mock(BrowserConfiguration.class);
        final CustomTabsIntentOptions options = new CustomTabsIntentOptions.Builder()
                .setColorSchemes(expColorSchemes)
                .setCloseButton(expCloseButton)
                .setUrlBarHidingEnabled(expUrlBarHidingEnabled)
                .setShareState(expShareState)
                .setShowTitle(expShowTitle)
                .setInstantAppsEnabled(expInstantAppsEnabled)
                .setAnimations(expAnimations)
                .setPartial(expPartial)
                .setBrowser(expBrowser)
                .build();

        final IntentFactory intentFactory = spy(this.intentFactory);
        doNothing().when(intentFactory).applyColorSchemes(any(), any());
        doNothing().when(intentFactory).applyCloseButton(any(), any(), any());
        doNothing().when(intentFactory).applyAnimations(any(), any(), any());
        doNothing().when(intentFactory).applyPartialCustomTabsConfiguration(any(), any(), any());
        doNothing().when(intentFactory).applyBrowserConfiguration(any(), any(), any());

        final CustomTabsIntent customTabsIntent = intentFactory
                .createCustomTabsIntent(context, options);
        final BundleSubject extras = assertThat(customTabsIntent.intent).extras();

        final ArgumentCaptor<CustomTabsColorSchemes> colorSchemesCaptor = ArgumentCaptor.forClass(CustomTabsColorSchemes.class);
        verify(intentFactory).applyColorSchemes(any(), colorSchemesCaptor.capture());
        assertThat(colorSchemesCaptor.getValue()).isSameInstanceAs(expColorSchemes);

        final ArgumentCaptor<CustomTabsCloseButton> closeButtonCaptor = ArgumentCaptor.forClass(CustomTabsCloseButton.class);
        verify(intentFactory).applyCloseButton(any(), any(), closeButtonCaptor.capture());
        assertThat(closeButtonCaptor.getValue()).isSameInstanceAs(expCloseButton);

        extras.bool(EXTRA_ENABLE_URLBAR_HIDING).isEqualTo(expUrlBarHidingEnabled);
        extras.integer(EXTRA_SHARE_STATE).isEqualTo(expShareState);
        extras.integer(EXTRA_TITLE_VISIBILITY_STATE).isEqualTo(SHOW_PAGE_TITLE);
        extras.bool(EXTRA_ENABLE_INSTANT_APPS).isEqualTo(expInstantAppsEnabled);

        final ArgumentCaptor<CustomTabsAnimations> animationsCaptor = ArgumentCaptor.forClass(CustomTabsAnimations.class);
        verify(intentFactory).applyAnimations(any(), any(), animationsCaptor.capture());
        assertThat(animationsCaptor.getValue()).isSameInstanceAs(expAnimations);

        final ArgumentCaptor<PartialCustomTabsConfiguration> partialCaptor = ArgumentCaptor.forClass(PartialCustomTabsConfiguration.class);
        verify(intentFactory).applyPartialCustomTabsConfiguration(any(), any(), partialCaptor.capture());
        assertThat(partialCaptor.getValue()).isSameInstanceAs(expPartial);

        final ArgumentCaptor<BrowserConfiguration> browserCaptor = ArgumentCaptor.forClass(BrowserConfiguration.class);
        verify(intentFactory).applyBrowserConfiguration(any(), any(), browserCaptor.capture());
        assertThat(browserCaptor.getValue()).isSameInstanceAs(expBrowser);
    }

    @Test
    public void createCustomTabsIntent_minimumOptions() {
        final CustomTabsIntentOptions options = new CustomTabsIntentOptions.Builder()
                .build();
        final IntentFactory intentFactory = spy(this.intentFactory);
        doNothing().when(intentFactory).applyColorSchemes(any(), any());
        doNothing().when(intentFactory).applyCloseButton(any(), any(), any());
        doNothing().when(intentFactory).applyAnimations(any(), any(), any());
        doNothing().when(intentFactory).applyPartialCustomTabsConfiguration(any(), any(), any());
        doNothing().when(intentFactory).applyBrowserConfiguration(any(), any(), any());

        final CustomTabsIntent customTabsIntent = intentFactory
                .createCustomTabsIntent(context, options);
        final BundleSubject extras = assertThat(customTabsIntent.intent).extras();
        extras.doesNotContainKey(EXTRA_ENABLE_URLBAR_HIDING);
        extras.doesNotContainKey(EXTRA_TITLE_VISIBILITY_STATE);
        // It seems that CustomTabsIntent includes these extras by default.
        extras.containsKey(EXTRA_SHARE_STATE);
        extras.containsKey(EXTRA_ENABLE_INSTANT_APPS);

        verify(intentFactory, never()).applyColorSchemes(any(), any());
        verify(intentFactory, never()).applyCloseButton(any(), any(), any());
        verify(intentFactory, never()).applyAnimations(any(), any(), any());
        verify(intentFactory, never()).applyPartialCustomTabsConfiguration(any(), any(), any());

        final ArgumentCaptor<BrowserConfiguration> browserConfigCaptor =
                ArgumentCaptor.forClass(BrowserConfiguration.class);
        verify(intentFactory).applyBrowserConfiguration(any(), any(), browserConfigCaptor.capture());

        final BrowserConfiguration actualBrowserConfig = browserConfigCaptor.getValue();
        assertThat(actualBrowserConfig.getPrefersExternalBrowser()).isFalse();
        assertThat(actualBrowserConfig.getPrefersDefaultBrowser()).isNull();
        assertThat(actualBrowserConfig.getFallbackCustomTabs()).isNull();
        assertThat(actualBrowserConfig.getHeaders()).isNull();
    }

    /**
     * @noinspection DataFlowIssue
     */
    @Test
    public void applyColorSchemes_completeOptions() {
        final CustomTabColorSchemeParams expLightParams = new CustomTabColorSchemeParams.Builder()
                .setToolbarColor(0xFFFFDBA0)
                .setNavigationBarDividerColor(0xFFFFDBA1)
                .setNavigationBarColor(0xFFFFDBA2)
                .build();
        final CustomTabColorSchemeParams expDarkParams = new CustomTabColorSchemeParams.Builder()
                .setToolbarColor(0xFFFFDBA3)
                .setNavigationBarDividerColor(0xFFFFDBA4)
                .setNavigationBarColor(0xFFFFDBA5)
                .build();
        final CustomTabColorSchemeParams expDefaultParams = new CustomTabColorSchemeParams.Builder()
                .setToolbarColor(0xFFFFDBA5)
                .setNavigationBarDividerColor(0xFFFFDBA6)
                .setNavigationBarColor(0xFFFFDBA7)
                .build();
        final int expColorScheme = COLOR_SCHEME_SYSTEM;
        final CustomTabsColorSchemes options = new CustomTabsColorSchemes.Builder()
                .setColorScheme(expColorScheme)
                .setLightParams(
                        new CustomTabColorSchemeParams.Builder()
                                .setToolbarColor(expLightParams.toolbarColor)
                                .setNavigationBarColor(expLightParams.navigationBarColor)
                                .setNavigationBarDividerColor(expLightParams.navigationBarDividerColor)
                                .build()
                )
                .setDarkParams(
                        new CustomTabColorSchemeParams.Builder()
                                .setToolbarColor(expDarkParams.toolbarColor)
                                .setNavigationBarColor(expDarkParams.navigationBarColor)
                                .setNavigationBarDividerColor(expDarkParams.navigationBarDividerColor)
                                .build()
                )
                .setDefaultParams(
                        new CustomTabColorSchemeParams.Builder()
                                .setToolbarColor(expDefaultParams.toolbarColor)
                                .setNavigationBarColor(expDefaultParams.navigationBarColor)
                                .setNavigationBarDividerColor(expDefaultParams.navigationBarDividerColor)
                                .build()
                )
                .build();
        final CustomTabsIntent.Builder builder = mock(CustomTabsIntent.Builder.class);
        intentFactory.applyColorSchemes(builder, options);

        final ArgumentCaptor<Integer> schemeCaptor = ArgumentCaptor.forClass(Integer.class);
        final ArgumentCaptor<CustomTabColorSchemeParams> paramsCaptor
                = ArgumentCaptor.forClass(CustomTabColorSchemeParams.class);
        verify(builder).setColorScheme(schemeCaptor.capture());
        verify(builder, times(2)).setColorSchemeParams(
                schemeCaptor.capture(),
                paramsCaptor.capture()
        );
        verify(builder).setDefaultColorSchemeParams(paramsCaptor.capture());

        final List<Integer> actualColorSchemes = schemeCaptor.getAllValues();
        assertThat(actualColorSchemes).containsExactly(
                expColorScheme,
                COLOR_SCHEME_LIGHT,
                COLOR_SCHEME_DARK
        );

        final List<CustomTabColorSchemeParams> actualParams = paramsCaptor.getAllValues();
        assertThat(actualParams).hasSize(3);

        final CustomTabColorSchemeParams actualLightParams = actualParams.get(0);
        assertThat(actualLightParams.toolbarColor).isEqualTo(expLightParams.toolbarColor);
        assertThat(actualLightParams.navigationBarColor)
                .isEqualTo(expLightParams.navigationBarColor);
        assertThat(actualLightParams.navigationBarDividerColor)
                .isEqualTo(expLightParams.navigationBarDividerColor);

        final CustomTabColorSchemeParams actualDarkParams = actualParams.get(1);
        assertThat(actualDarkParams.toolbarColor).isEqualTo(expDarkParams.toolbarColor);
        assertThat(actualDarkParams.navigationBarColor)
                .isEqualTo(expDarkParams.navigationBarColor);
        assertThat(actualDarkParams.navigationBarDividerColor)
                .isEqualTo(expDarkParams.navigationBarDividerColor);

        final CustomTabColorSchemeParams actualDefaultParams = actualParams.get(2);
        assertThat(actualDefaultParams.toolbarColor).isEqualTo(expDefaultParams.toolbarColor);
        assertThat(actualDefaultParams.navigationBarColor)
                .isEqualTo(expDefaultParams.navigationBarColor);
        assertThat(actualDefaultParams.navigationBarDividerColor)
                .isEqualTo(expDefaultParams.navigationBarDividerColor);
    }

    @Test
    public void applyColorSchemes_minimumOptions() {
        final CustomTabsColorSchemes options = new CustomTabsColorSchemes.Builder()
                .build();
        final CustomTabsIntent.Builder builder = mock(CustomTabsIntent.Builder.class);
        intentFactory.applyColorSchemes(builder, options);

        verify(builder, never()).setColorScheme(anyInt());
        verify(builder, never()).setColorSchemeParams(anyInt(), any());
        verify(builder, never()).setDefaultColorSchemeParams(any());
    }

    @Test
    public void applyCloseButton_completeOptions() {
        final Bitmap expIcon = mock(Bitmap.class);
        when(resources.getBitmap(any(), anyString())).thenReturn(expIcon);

        final int expPosition = CLOSE_BUTTON_POSITION_DEFAULT;
        final CustomTabsCloseButton options = new CustomTabsCloseButton.Builder()
                .setIcon("icon")
                .setPosition(expPosition)
                .build();

        final CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
        intentFactory.applyCloseButton(context, builder, options);

        final CustomTabsIntent customTabsIntent = builder.build();
        final BundleSubject extras = assertThat(customTabsIntent.intent).extras();
        extras.isNotNull();
        extras.parcelable(EXTRA_CLOSE_BUTTON_ICON).isSameInstanceAs(expIcon);
        extras.integer(EXTRA_CLOSE_BUTTON_POSITION).isEqualTo(expPosition);
    }

    @Test
    public void applyCloseButton_minimumOptions() {
        final CustomTabsCloseButton options = new CustomTabsCloseButton.Builder()
                .build();
        final CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
        intentFactory.applyCloseButton(context, builder, options);

        final CustomTabsIntent customTabsIntent = builder.build();
        final BundleSubject extras = assertThat(customTabsIntent.intent).extras();
        extras.doesNotContainKey(EXTRA_CLOSE_BUTTON_ICON);
        extras.doesNotContainKey(EXTRA_CLOSE_BUTTON_POSITION);
    }

    @Test
    public void applyCloseButton_invalidIcon() {
        when(resources.getBitmap(any(), anyString())).thenReturn(null);

        final CustomTabsCloseButton options = new CustomTabsCloseButton.Builder()
                .setIcon("icon")
                .build();
        final CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
        intentFactory.applyCloseButton(context, builder, options);

        final CustomTabsIntent customTabsIntent = builder.build();
        final BundleSubject extras = assertThat(customTabsIntent.intent).extras();
        extras.doesNotContainKey(EXTRA_CLOSE_BUTTON_ICON);
        extras.doesNotContainKey(EXTRA_CLOSE_BUTTON_POSITION);
    }

    @Test
    public void applyAnimations_completeOptions() {
        final int expStartEnter = 1;
        final int expStartExit = 2;
        final int expEndEnter = 3;
        final int expEndExit = 4;
        when(resources.getAnimationIdentifier(any(), eq("start_enter")))
                .thenReturn(expStartEnter);
        when(resources.getAnimationIdentifier(any(), eq("start_exit")))
                .thenReturn(expStartExit);
        when(resources.getAnimationIdentifier(any(), eq("end_enter")))
                .thenReturn(expEndEnter);
        when(resources.getAnimationIdentifier(any(), eq("end_exit")))
                .thenReturn(expEndExit);

        final CustomTabsAnimations options = new CustomTabsAnimations.Builder()
                .setStartEnter("start_enter")
                .setStartExit("start_exit")
                .setEndEnter("end_enter")
                .setEndExit("end_exit")
                .build();
        final CustomTabsIntent.Builder builder = mock(CustomTabsIntent.Builder.class);
        intentFactory.applyAnimations(context, builder, options);

        final ArgumentCaptor<Integer> startEnterCaptor = ArgumentCaptor.forClass(Integer.class);
        final ArgumentCaptor<Integer> startExitCaptor = ArgumentCaptor.forClass(Integer.class);
        verify(builder).setStartAnimations(
                any(),
                startEnterCaptor.capture(),
                startExitCaptor.capture()
        );
        assertThat(startEnterCaptor.getValue()).isEqualTo(expStartEnter);
        assertThat(startExitCaptor.getValue()).isEqualTo(expStartExit);

        final ArgumentCaptor<Integer> endEnterCaptor = ArgumentCaptor.forClass(Integer.class);
        final ArgumentCaptor<Integer> endExitCaptor = ArgumentCaptor.forClass(Integer.class);
        verify(builder).setExitAnimations(
                any(),
                endEnterCaptor.capture(),
                endExitCaptor.capture()
        );
        assertThat(endEnterCaptor.getValue()).isEqualTo(expEndEnter);
        assertThat(endExitCaptor.getValue()).isEqualTo(expEndExit);
    }

    @Test
    public void applyAnimations_emptyOptions() {
        when(resources.getAnimationIdentifier(any(), anyString()))
                .thenReturn(INVALID_RESOURCE_ID);

        final CustomTabsAnimations options = new CustomTabsAnimations.Builder()
                .build();
        final CustomTabsIntent.Builder builder = mock(CustomTabsIntent.Builder.class);
        intentFactory.applyAnimations(context, builder, options);

        verify(builder, never()).setStartAnimations(any(), anyInt(), anyInt());
        verify(builder, never()).setExitAnimations(any(), anyInt(), anyInt());
    }

    @Test
    public void applyPartialCustomTabsConfiguration_completeOptions() {
        final int expCornerRadius = 8;
        final PartialCustomTabsConfiguration options = new PartialCustomTabsConfiguration.Builder()
                .setActivityHeightResizeBehavior(ACTIVITY_HEIGHT_DEFAULT)
                .setInitialHeight(100.0)
                .setCornerRadius(expCornerRadius)
                .build();

        final int expInitialActivityHeight = 100;
        when(resources.convertToPx(any(), anyDouble())).thenReturn(expInitialActivityHeight);

        final CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
        intentFactory.applyPartialCustomTabsConfiguration(context, builder, options);

        final CustomTabsIntent customTabsIntent = builder.build();
        final BundleSubject extras = assertThat(customTabsIntent.intent).extras();
        extras.integer(EXTRA_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR).isEqualTo(ACTIVITY_HEIGHT_DEFAULT);
        extras.integer(EXTRA_INITIAL_ACTIVITY_HEIGHT_PX).isEqualTo(expInitialActivityHeight);
        extras.integer(EXTRA_TOOLBAR_CORNER_RADIUS_DP).isEqualTo(expCornerRadius);
    }

    @Test
    public void applyPartialCustomTabsConfiguration_minimumOptions() {
        final PartialCustomTabsConfiguration options = new PartialCustomTabsConfiguration.Builder()
                .setActivityHeightResizeBehavior(ACTIVITY_HEIGHT_FIXED)
                .setInitialHeight(200.0)
                .build();

        final int expInitialActivityHeight = 200;
        when(resources.convertToPx(any(), anyDouble())).thenReturn(expInitialActivityHeight);

        final CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
        intentFactory.applyPartialCustomTabsConfiguration(context, builder, options);

        final CustomTabsIntent customTabsIntent = builder.build();
        final BundleSubject extras = assertThat(customTabsIntent.intent).extras();
        extras.integer(EXTRA_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR).isEqualTo(ACTIVITY_HEIGHT_FIXED);
        extras.integer(EXTRA_INITIAL_ACTIVITY_HEIGHT_PX).isEqualTo(expInitialActivityHeight);
        extras.doesNotContainKey(EXTRA_TOOLBAR_CORNER_RADIUS_DP);
    }

    @Test
    public void applyBrowserConfiguration_completeOptionsWithPrefersChrome() {
        try (MockedStatic<CustomTabsIntentHelper> mocked = mockStatic(CustomTabsIntentHelper.class)) {
            mocked.when(() -> setChromeCustomTabsPackage(any(), any(), any()))
                    .thenReturn(null);

            final SimpleEntry<String, String> expHeader = new SimpleEntry<>("key", "value");
            final BrowserConfiguration options = new BrowserConfiguration.Builder()
                    .setHeaders(singletonMap(expHeader.getKey(), expHeader.getValue()))
                    .setFallbackCustomTabs(singletonList("com.example.customtabs"))
                    .setPrefersExternalBrowser(false)
                    .setPrefersDefaultBrowser(false)
                    .build();
            final CustomTabsIntent customTabsIntent = new CustomTabsIntent.Builder()
                    .build();
            intentFactory.applyBrowserConfiguration(context, customTabsIntent, options);

            assertThat(customTabsIntent.intent).extras().containsKey(Browser.EXTRA_HEADERS);
            final Bundle actualHeaders = customTabsIntent.intent.getBundleExtra(Browser.EXTRA_HEADERS);
            assertThat(actualHeaders).isNotNull();
            assertThat(actualHeaders).hasSize(1);
            assertThat(actualHeaders).string(expHeader.getKey()).isEqualTo(expHeader.getValue());

            mocked.verify(() ->
                    setChromeCustomTabsPackage(any(), any(), isNotNull(NonChromeCustomTabs.class))
            );
        }
    }

    @SuppressWarnings("deprecation")
    @Test
    public void applyBrowserConfiguration_minimumOptionsWithPrefersChrome() {
        try (MockedStatic<CustomTabsIntentHelper> mockedHelper = mockStatic(CustomTabsIntentHelper.class)) {
            mockedHelper.when(() -> setChromeCustomTabsPackage(any(), any(), any()))
                    .thenReturn(null);

            final PackageManager pm = mock(PackageManager.class);
            when(pm.queryIntentActivities(any(), anyInt())).thenReturn(emptyList());
            when(context.getPackageManager()).thenReturn(pm);

            final BrowserConfiguration options = new BrowserConfiguration.Builder()
                    .setPrefersExternalBrowser(false)
                    .build();
            final CustomTabsIntent customTabsIntent = new CustomTabsIntent.Builder()
                    .build();
            intentFactory.applyBrowserConfiguration(context, customTabsIntent, options);

            assertThat(customTabsIntent.intent).extras().doesNotContainKey(Browser.EXTRA_HEADERS);

            mockedHelper.verify(() ->
                    setChromeCustomTabsPackage(any(), any(), isNotNull(NonChromeCustomTabs.class))
            );
        }
    }

    @SuppressWarnings("deprecation")
    @Test
    public void applyBrowserConfiguration_prefersDefaultBrowser() {
        try (MockedStatic<CustomTabsIntentHelper> mocked = mockStatic(CustomTabsIntentHelper.class)) {
            mocked.when(() -> setCustomTabsPackage(any(), any(), any()))
                    .thenReturn(null);

            final PackageManager pm = mock(PackageManager.class);
            when(pm.queryIntentActivities(any(), anyInt())).thenReturn(emptyList());
            when(context.getPackageManager()).thenReturn(pm);

            final BrowserConfiguration options = new BrowserConfiguration.Builder()
                    .setPrefersExternalBrowser(false)
                    .setPrefersDefaultBrowser(true)
                    .build();
            final CustomTabsIntent customTabsIntent = new CustomTabsIntent.Builder()
                    .build();
            intentFactory.applyBrowserConfiguration(context, customTabsIntent, options);

            assertThat(customTabsIntent.intent).extras().doesNotContainKey(Browser.EXTRA_HEADERS);

            mocked.verify(() ->
                    setCustomTabsPackage(any(), any(), isNotNull(NonChromeCustomTabs.class))
            );
        }
    }

    @Test
    public void createCustomTabsIntentOptions_nullOptions() {
        final CustomTabsIntentOptions options = intentFactory.createCustomTabsIntentOptions(null);
        assertThat(options).isNull();
    }

    @Test
    public void createCustomTabsIntentOptions_notNullOptions() {
        final CustomTabsIntentOptions options = intentFactory.createCustomTabsIntentOptions(emptyMap());
        assertThat(options).isNotNull();
    }
}