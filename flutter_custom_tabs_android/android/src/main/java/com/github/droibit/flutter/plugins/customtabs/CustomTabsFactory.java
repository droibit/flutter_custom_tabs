package com.github.droibit.flutter.plugins.customtabs;

import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_DARK;
import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_LIGHT;
import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.setChromeCustomTabsPackage;
import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.setCustomTabsPackage;
import static com.github.droibit.flutter.plugins.customtabs.ResourceFactory.INVALID_RESOURCE_ID;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Bundle;
import android.provider.Browser;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;
import androidx.annotation.VisibleForTesting;
import androidx.browser.customtabs.CustomTabColorSchemeParams;
import androidx.browser.customtabs.CustomTabsIntent;

import com.droibit.android.customtabs.launcher.CustomTabsPackageFallback;
import com.droibit.android.customtabs.launcher.NonChromeCustomTabs;
import com.github.droibit.flutter.plugins.customtabs.Messages.CustomTabsAnimationsMessage;
import com.github.droibit.flutter.plugins.customtabs.Messages.CustomTabsBrowserConfigurationMessage;
import com.github.droibit.flutter.plugins.customtabs.Messages.CustomTabsCloseButtonMessage;
import com.github.droibit.flutter.plugins.customtabs.Messages.CustomTabsColorSchemeParamsMessage;
import com.github.droibit.flutter.plugins.customtabs.Messages.CustomTabsColorSchemesMessage;
import com.github.droibit.flutter.plugins.customtabs.Messages.CustomTabsOptionsMessage;
import com.github.droibit.flutter.plugins.customtabs.Messages.PartialCustomTabsConfigurationMessage;

import java.util.List;
import java.util.Map;

@RestrictTo(RestrictTo.Scope.LIBRARY)
class CustomTabsFactory {
    private final @NonNull ResourceFactory resources;

    CustomTabsFactory() {
        this(new ResourceFactory());
    }

    @VisibleForTesting
    CustomTabsFactory(@NonNull ResourceFactory resources) {
        this.resources = resources;
    }

    @Nullable
    Intent createExternalBrowserIntent(@Nullable CustomTabsOptionsMessage options) {
        final Intent intent = new Intent(Intent.ACTION_VIEW);
        if (options == null) {
            return intent;
        }

        final CustomTabsBrowserConfigurationMessage browserOptions = options.getBrowser();
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

    @NonNull
    CustomTabsIntent createCustomTabsIntent(
            @NonNull Context context,
            @NonNull CustomTabsOptionsMessage options
    ) {
        final CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
        final CustomTabsColorSchemesMessage colorSchemes = options.getColorSchemes();
        if (colorSchemes != null) {
            applyColorSchemes(builder, colorSchemes);
        }

        final CustomTabsCloseButtonMessage closeButton = options.getCloseButton();
        if (closeButton != null) {
            applyCloseButton(context, builder, closeButton);
        }

        final Boolean urlBarHidingEnabled = options.getUrlBarHidingEnabled();
        if (urlBarHidingEnabled != null) {
            builder.setUrlBarHidingEnabled(urlBarHidingEnabled);
        }

        final Long shareState = options.getShareState();
        if (shareState != null) {
            builder.setShareState(shareState.intValue());
        }

        final Boolean showTitle = options.getShowTitle();
        if (showTitle != null) {
            builder.setShowTitle(showTitle);
        }

        final Boolean instantAppsEnabled = options.getInstantAppsEnabled();
        if (instantAppsEnabled != null) {
            builder.setInstantAppsEnabled(instantAppsEnabled);
        }

        final CustomTabsAnimationsMessage animations = options.getAnimations();
        if (animations != null) {
            applyAnimations(context, builder, animations);
        }

        final PartialCustomTabsConfigurationMessage partial = options.getPartial();
        if (partial != null) {
            applyPartialCustomTabsConfiguration(context, builder, partial);
        }

        final CustomTabsIntent customTabsIntent = builder.build();
        final CustomTabsBrowserConfigurationMessage browserConfiguration;
        if (options.getBrowser() != null) {
            browserConfiguration = options.getBrowser();
        } else {
            browserConfiguration = new CustomTabsBrowserConfigurationMessage();
        }
        applyBrowserConfiguration(context, customTabsIntent, browserConfiguration);
        return customTabsIntent;
    }

    private void applyColorSchemes(
            @NonNull CustomTabsIntent.Builder builder,
            @NonNull CustomTabsColorSchemesMessage colorSchemes
    ) {
        final Long colorScheme = colorSchemes.getColorScheme();
        if (colorScheme != null) {

            builder.setColorScheme(colorScheme.intValue());
        }

        final CustomTabsColorSchemeParamsMessage lightParams = colorSchemes.getLightParams();
        if (lightParams != null) {
            builder.setColorSchemeParams(COLOR_SCHEME_LIGHT, buildColorSchemeParams(lightParams));
        }

        final CustomTabsColorSchemeParamsMessage darkParams = colorSchemes.getDarkParams();
        if (darkParams != null) {
            builder.setColorSchemeParams(COLOR_SCHEME_DARK, buildColorSchemeParams(darkParams));
        }

        final CustomTabsColorSchemeParamsMessage defaultPrams = colorSchemes.getDefaultPrams();
        if (defaultPrams != null) {
            builder.setDefaultColorSchemeParams(buildColorSchemeParams(defaultPrams));
        }
    }

    private @NonNull CustomTabColorSchemeParams buildColorSchemeParams(
            @NonNull CustomTabsColorSchemeParamsMessage params
    ) {
        final CustomTabColorSchemeParams.Builder builder = new CustomTabColorSchemeParams.Builder();
        final String colorString = params.getToolbarColor();
        if (colorString != null) {
            builder.setToolbarColor(Color.parseColor(colorString));
        }

        final String navigationBarColor = params.getNavigationBarColor();
        if (navigationBarColor != null) {
            builder.setNavigationBarColor(Color.parseColor(navigationBarColor));
        }

        final String navigationBarDividerColor = params.getNavigationBarDividerColor();
        if (navigationBarDividerColor != null) {
            builder.setNavigationBarDividerColor(Color.parseColor(navigationBarDividerColor));
        }
        return builder.build();
    }

    private void applyCloseButton(
            @NonNull Context context,
            @NonNull CustomTabsIntent.Builder builder,
            @NonNull CustomTabsCloseButtonMessage closeButton
    ) {
        final String icon = closeButton.getIcon();
        if (icon != null) {
            final int closeButtonIconId = resources.getDrawableIdentifier(context, icon);
            if (closeButtonIconId != INVALID_RESOURCE_ID) {
                final Bitmap closeButtonIcon = resources.getBitmap(context, closeButtonIconId);
                if (closeButtonIcon != null) {
                    builder.setCloseButtonIcon(closeButtonIcon);
                }
            }
        }

        final Long position = closeButton.getPosition();
        if (position != null) {
            builder.setCloseButtonPosition(position.intValue());
        }
    }

    private void applyAnimations(
            @NonNull Context context,
            @NonNull CustomTabsIntent.Builder builder,
            @NonNull CustomTabsAnimationsMessage animations
    ) {
        final int startEnterAnimationId =
                resources.getAnimationIdentifier(context, animations.getStartEnter());
        final int startExitAnimationId =
                resources.getAnimationIdentifier(context, animations.getStartExit());
        final int endEnterAnimationId =
                resources.getAnimationIdentifier(context, animations.getEndEnter());
        final int endExitAnimationId =
                resources.getAnimationIdentifier(context, animations.getEndExit());

        if (startEnterAnimationId != INVALID_RESOURCE_ID
                && startExitAnimationId != INVALID_RESOURCE_ID) {
            builder.setStartAnimations(context, startEnterAnimationId, startExitAnimationId);
        }

        if (endEnterAnimationId != INVALID_RESOURCE_ID
                && endExitAnimationId != INVALID_RESOURCE_ID) {
            builder.setExitAnimations(context, endEnterAnimationId, endExitAnimationId);
        }
    }

    private void applyPartialCustomTabsConfiguration(
            @NonNull Context context,
            @NonNull CustomTabsIntent.Builder builder,
            @NonNull PartialCustomTabsConfigurationMessage configuration
    ) {
        final double initialHeightDp = configuration.getInitialHeight();
        final float scale = context.getResources().getDisplayMetrics().density;
        final int resizeBehavior = configuration.getActivityHeightResizeBehavior().intValue();
        builder.setInitialActivityHeightPx(
                (int) (initialHeightDp * scale + 0.5),
                resizeBehavior
        );

        final Long cornerRadius = configuration.getCornerRadius();
        if (cornerRadius != null) {
            builder.setToolbarCornerRadiusDp(cornerRadius.intValue());
        }
    }

    private void applyBrowserConfiguration(
            @NonNull Context context,
            @NonNull CustomTabsIntent customTabsIntent,
            @NonNull CustomTabsBrowserConfigurationMessage options
    ) {
        final Map<String, String> headers = options.getHeaders();
        if (headers != null) {
            final Bundle bundleHeaders = extractBundle(headers);
            customTabsIntent.intent.putExtra(Browser.EXTRA_HEADERS, bundleHeaders);
        }

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

        final Boolean prefersDefaultBrowser = options.getPrefersDefaultBrowser();
        if (prefersDefaultBrowser != null && prefersDefaultBrowser) {
            setCustomTabsPackage(customTabsIntent, context, fallback);
        } else {
            setChromeCustomTabsPackage(customTabsIntent, context, fallback);
        }
    }

    private @NonNull Bundle extractBundle(@NonNull Map<String, String> headers) {
        final Bundle dest = new Bundle(headers.size());
        for (Map.Entry<String, String> entry : headers.entrySet()) {
            dest.putString(entry.getKey(), entry.getValue());
        }
        return dest;
    }
}
