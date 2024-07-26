package com.github.droibit.flutter.plugins.customtabs.core;

import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_DARK;
import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_LIGHT;
import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.setChromeCustomTabsPackage;
import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.setCustomTabsPackage;
import static com.github.droibit.flutter.plugins.customtabs.core.ResourceFactory.INVALID_RESOURCE_ID;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.provider.Browser;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import androidx.browser.customtabs.CustomTabColorSchemeParams;
import androidx.browser.customtabs.CustomTabsIntent;

import com.droibit.android.customtabs.launcher.CustomTabsPackageFallback;
import com.droibit.android.customtabs.launcher.NonChromeCustomTabs;
import com.github.droibit.flutter.plugins.customtabs.core.options.BrowserConfiguration;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsAnimations;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsCloseButton;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsColorSchemes;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions;
import com.github.droibit.flutter.plugins.customtabs.core.options.PartialCustomTabsConfiguration;

import java.util.List;
import java.util.Map;

public class IntentFactory {
    private final @NonNull ResourceFactory resources;

    public IntentFactory() {
        this(new ResourceFactory());
    }

    @VisibleForTesting
    IntentFactory(@NonNull ResourceFactory resources) {
        this.resources = resources;
    }

    public @Nullable Intent createExternalBrowserIntent(@Nullable CustomTabsIntentOptions options) {
        final Intent intent = new Intent(Intent.ACTION_VIEW);
        if (options == null) {
            return intent;
        }

        final BrowserConfiguration browserOptions = options.getBrowser();
        if (browserOptions == null || !browserOptions.getPrefersExternalBrowser()) {
            return null;
        }

        final Map<String, String> headers = browserOptions.getHeaders();
        if (headers != null) {
            final Bundle bundleHeaders = extractBundle(headers);
            intent.putExtra(Browser.EXTRA_HEADERS, bundleHeaders);
        }
        return intent;
    }

    public @NonNull CustomTabsIntent createCustomTabsIntent(
            @NonNull Context context,
            @NonNull CustomTabsIntentOptions options
    ) {
        final CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
        final CustomTabsColorSchemes colorSchemes = options.getColorSchemes();
        if (colorSchemes != null) {
            applyColorSchemes(builder, colorSchemes);
        }

        final CustomTabsCloseButton closeButton = options.getCloseButton();
        if (closeButton != null) {
            applyCloseButton(context, builder, closeButton);
        }

        final Boolean urlBarHidingEnabled = options.getUrlBarHidingEnabled();
        if (urlBarHidingEnabled != null) {
            builder.setUrlBarHidingEnabled(urlBarHidingEnabled);
        }

        final Integer shareState = options.getShareState();
        if (shareState != null) {
            builder.setShareState(shareState);
        }

        final Boolean showTitle = options.getShowTitle();
        if (showTitle != null) {
            builder.setShowTitle(showTitle);
        }

        final Boolean instantAppsEnabled = options.getInstantAppsEnabled();
        if (instantAppsEnabled != null) {
            builder.setInstantAppsEnabled(instantAppsEnabled);
        }

        final CustomTabsAnimations animations = options.getAnimations();
        if (animations != null) {
            applyAnimations(context, builder, animations);
        }

        final PartialCustomTabsConfiguration partial = options.getPartial();
        if (partial != null) {
            applyPartialCustomTabsConfiguration(context, builder, partial);
        }

        final CustomTabsIntent customTabsIntent = builder.build();
        final BrowserConfiguration browserConfiguration;
        if (options.getBrowser() != null) {
            browserConfiguration = options.getBrowser();
        } else {
            browserConfiguration = new BrowserConfiguration();
        }
        applyBrowserConfiguration(context, customTabsIntent, browserConfiguration);
        return customTabsIntent;
    }

    @VisibleForTesting
    void applyColorSchemes(
            @NonNull CustomTabsIntent.Builder builder,
            @NonNull CustomTabsColorSchemes colorSchemes
    ) {
        final Integer colorScheme = colorSchemes.getColorScheme();
        if (colorScheme != null) {
            builder.setColorScheme(colorScheme);
        }

        final CustomTabColorSchemeParams lightParams = colorSchemes.getLightParams();
        if (lightParams != null) {
            builder.setColorSchemeParams(COLOR_SCHEME_LIGHT, lightParams);
        }

        final CustomTabColorSchemeParams darkParams = colorSchemes.getDarkParams();
        if (darkParams != null) {
            builder.setColorSchemeParams(COLOR_SCHEME_DARK, darkParams);
        }

        final CustomTabColorSchemeParams defaultPrams = colorSchemes.getDefaultPrams();
        if (defaultPrams != null) {
            builder.setDefaultColorSchemeParams(defaultPrams);
        }
    }

    @VisibleForTesting
    void applyCloseButton(
            @NonNull Context context,
            @NonNull CustomTabsIntent.Builder builder,
            @NonNull CustomTabsCloseButton closeButton
    ) {
        final String icon = closeButton.getIcon();
        if (icon != null) {
            final Bitmap closeButtonIcon = resources.getBitmap(context, icon);
            if (closeButtonIcon != null) {
                builder.setCloseButtonIcon(closeButtonIcon);
            }
        }

        final Integer position = closeButton.getPosition();
        if (position != null) {
            builder.setCloseButtonPosition(position);
        }
    }

    @VisibleForTesting
    void applyAnimations(
            @NonNull Context context,
            @NonNull CustomTabsIntent.Builder builder,
            @NonNull CustomTabsAnimations animations
    ) {
        final int startEnterAnimationId = resources.getAnimationIdentifier(context, animations.getStartEnter());
        final int startExitAnimationId = resources.getAnimationIdentifier(context, animations.getStartExit());
        final int endEnterAnimationId = resources.getAnimationIdentifier(context, animations.getEndEnter());
        final int endExitAnimationId = resources.getAnimationIdentifier(context, animations.getEndExit());

        if (startEnterAnimationId != INVALID_RESOURCE_ID && startExitAnimationId != INVALID_RESOURCE_ID) {
            builder.setStartAnimations(context, startEnterAnimationId, startExitAnimationId);
        }

        if (endEnterAnimationId != INVALID_RESOURCE_ID && endExitAnimationId != INVALID_RESOURCE_ID) {
            builder.setExitAnimations(context, endEnterAnimationId, endExitAnimationId);
        }
    }

    @VisibleForTesting
    void applyPartialCustomTabsConfiguration(
            @NonNull Context context,
            @NonNull CustomTabsIntent.Builder builder,
            @NonNull PartialCustomTabsConfiguration configuration
    ) {
        final Double initialHeightDp = configuration.getInitialHeight();
        final Integer resizeBehavior = configuration.getActivityHeightResizeBehavior();
        if (initialHeightDp != null && resizeBehavior != null) {
            builder.setInitialActivityHeightPx(
                    resources.convertToPx(context, initialHeightDp),
                    resizeBehavior
            );
        }

        final Integer cornerRadius = configuration.getCornerRadius();
        if (cornerRadius != null) {
            builder.setToolbarCornerRadiusDp(cornerRadius);
        }
    }

    @VisibleForTesting
    void applyBrowserConfiguration(
            @NonNull Context context,
            @NonNull CustomTabsIntent customTabsIntent,
            @NonNull BrowserConfiguration options
    ) {
        final Map<String, String> headers = options.getHeaders();
        if (headers != null) {
            final Bundle bundleHeaders = extractBundle(headers);
            customTabsIntent.intent.putExtra(Browser.EXTRA_HEADERS, bundleHeaders);
        }

        final CustomTabsPackageFallback fallback = getCustomTabsPackageFallback(context, options);
        final Boolean prefersDefaultBrowser = options.getPrefersDefaultBrowser();
        if (prefersDefaultBrowser != null && prefersDefaultBrowser) {
            setCustomTabsPackage(customTabsIntent, context, fallback);
        } else {
            setChromeCustomTabsPackage(customTabsIntent, context, fallback);
        }
    }

    private static @NonNull CustomTabsPackageFallback getCustomTabsPackageFallback(
            @NonNull Context context,
            @NonNull BrowserConfiguration options
    ) {
        final List<String> fallbackCustomTabs;
        if (options.getFallbackCustomTabs() != null) {
            fallbackCustomTabs = options.getFallbackCustomTabs();
        } else {
            fallbackCustomTabs = null;
        }

        final CustomTabsPackageFallback fallback;
        if (fallbackCustomTabs != null && !fallbackCustomTabs.isEmpty()) {
            fallback = new NonChromeCustomTabs(fallbackCustomTabs);
        } else {
            fallback = new NonChromeCustomTabs(context);
        }
        return fallback;
    }

    private @NonNull Bundle extractBundle(@NonNull Map<String, String> headers) {
        final Bundle dest = new Bundle(headers.size());
        for (Map.Entry<String, String> entry : headers.entrySet()) {
            dest.putString(entry.getKey(), entry.getValue());
        }
        return dest;
    }

    public @Nullable CustomTabsIntentOptions createCustomTabsIntentOptions(@Nullable Map<String, Object> options) {
        if (options == null) {
            return null;
        } else {
            return new CustomTabsIntentOptions.Builder()
                    .setOptions(options)
                    .build();
        }
    }
}
