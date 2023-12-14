package com.github.droibit.flutter.plugins.customtabs;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
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
import com.github.droibit.flutter.plugins.customtabs.Messages.Animations;
import com.github.droibit.flutter.plugins.customtabs.Messages.BrowserConfiguration;
import com.github.droibit.flutter.plugins.customtabs.Messages.CloseButton;
import com.github.droibit.flutter.plugins.customtabs.Messages.ColorSchemeParams;
import com.github.droibit.flutter.plugins.customtabs.Messages.ColorSchemes;
import com.github.droibit.flutter.plugins.customtabs.Messages.CustomTabsIntentOptions;
import com.github.droibit.flutter.plugins.customtabs.Messages.PartialConfiguration;

import java.util.List;
import java.util.Map;

import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_DARK;
import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_LIGHT;
import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.setChromeCustomTabsPackage;
import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.setCustomTabsPackage;
import static com.github.droibit.flutter.plugins.customtabs.ResourceFactory.INVALID_RESOURCE_ID;

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
    Intent createExternalBrowserIntent(@Nullable CustomTabsIntentOptions options) {
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

    @NonNull
    CustomTabsIntent createCustomTabsIntent(
            @NonNull Context context,
            @NonNull CustomTabsIntentOptions options
    ) {
        final CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
        final ColorSchemes colorSchemes = options.getColorSchemes();
        if (colorSchemes != null) {
            applyColorSchemes(builder, colorSchemes);
        }

        final CloseButton closeButton = options.getCloseButton();
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

        final Animations animations = options.getAnimations();
        if (animations != null) {
            applyAnimations(context, builder, animations);
        }

        final PartialConfiguration partial = options.getPartial();
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
            @NonNull ColorSchemes colorSchemes
    ) {
        final Long colorScheme = colorSchemes.getColorScheme();
        if (colorScheme != null) {
            builder.setColorScheme(colorScheme.intValue());
        }

        final ColorSchemeParams lightParams = colorSchemes.getLightParams();
        if (lightParams != null) {
            builder.setColorSchemeParams(COLOR_SCHEME_LIGHT, buildColorSchemeParams(lightParams));
        }

        final ColorSchemeParams darkParams = colorSchemes.getDarkParams();
        if (darkParams != null) {
            builder.setColorSchemeParams(COLOR_SCHEME_DARK, buildColorSchemeParams(darkParams));
        }

        final ColorSchemeParams defaultPrams = colorSchemes.getDefaultPrams();
        if (defaultPrams != null) {
            builder.setDefaultColorSchemeParams(buildColorSchemeParams(defaultPrams));
        }
    }

    private @NonNull CustomTabColorSchemeParams buildColorSchemeParams(
            @NonNull ColorSchemeParams params
    ) {
        final CustomTabColorSchemeParams.Builder builder = new CustomTabColorSchemeParams.Builder();
        final Long toolbarColor = params.getToolbarColor();
        if (toolbarColor != null) {
            builder.setToolbarColor(toolbarColor.intValue());
        }

        final Long navigationBarColor = params.getNavigationBarColor();
        if (navigationBarColor != null) {
            builder.setNavigationBarColor(navigationBarColor.intValue());
        }

        final Long navigationBarDividerColor = params.getNavigationBarDividerColor();
        if (navigationBarDividerColor != null) {
            builder.setNavigationBarDividerColor(navigationBarDividerColor.intValue());
        }
        return builder.build();
    }

    @VisibleForTesting
    void applyCloseButton(
            @NonNull Context context,
            @NonNull CustomTabsIntent.Builder builder,
            @NonNull CloseButton closeButton
    ) {
        final String icon = closeButton.getIcon();
        if (icon != null) {
            final Bitmap closeButtonIcon = resources.getBitmap(context, icon);
            if (closeButtonIcon != null) {
                builder.setCloseButtonIcon(closeButtonIcon);
            }
        }

        final Long position = closeButton.getPosition();
        if (position != null) {
            builder.setCloseButtonPosition(position.intValue());
        }
    }

    @VisibleForTesting
    void applyAnimations(
            @NonNull Context context,
            @NonNull CustomTabsIntent.Builder builder,
            @NonNull Animations animations
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

    @VisibleForTesting
    void applyPartialCustomTabsConfiguration(
            @NonNull Context context,
            @NonNull CustomTabsIntent.Builder builder,
            @NonNull PartialConfiguration configuration
    ) {
        final double initialHeightDp = configuration.getInitialHeight();
        final int resizeBehavior = configuration.getActivityHeightResizeBehavior().intValue();
        builder.setInitialActivityHeightPx(
                resources.convertToPx(context, initialHeightDp),
                resizeBehavior
        );

        final Long cornerRadius = configuration.getCornerRadius();
        if (cornerRadius != null) {
            builder.setToolbarCornerRadiusDp(cornerRadius.intValue());
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
