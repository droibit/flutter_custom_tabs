package com.github.droibit.flutter.plugins.customtabs.core;

import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_DARK;
import static androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_LIGHT;
import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.setChromeCustomTabsPackage;
import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.setCustomTabsPackage;
import static com.github.droibit.flutter.plugins.customtabs.core.ResourceFactory.INVALID_RESOURCE_ID;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.provider.Browser;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import androidx.browser.customtabs.CustomTabColorSchemeParams;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.browser.customtabs.CustomTabsSession;
import androidx.core.util.Pair;

import com.droibit.android.customtabs.launcher.CustomTabsPackageProvider;
import com.github.droibit.flutter.plugins.customtabs.core.options.BrowserConfiguration;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsAnimations;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsCloseButton;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsColorSchemes;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions;
import com.github.droibit.flutter.plugins.customtabs.core.options.PartialCustomTabsConfiguration;
import com.github.droibit.flutter.plugins.customtabs.core.session.CustomTabsSessionController;
import com.github.droibit.flutter.plugins.customtabs.core.session.CustomTabsSessionFactory;

import java.util.Map;

public class CustomTabsIntentFactory {
    private final @NonNull ResourceFactory resources;

    public CustomTabsIntentFactory() {
        this(new ResourceFactory());
    }

    @VisibleForTesting
    CustomTabsIntentFactory(@NonNull ResourceFactory resources) {
        this.resources = resources;
    }

    public @NonNull CustomTabsIntent createIntent(
            @NonNull Context context,
            @NonNull CustomTabsIntentOptions options,
            @NonNull CustomTabsSessionFactory customTabsSessionFactory
    ) {
        final BrowserConfiguration browserConfiguration;
        if (options.getBrowser() != null) {
            browserConfiguration = options.getBrowser();
        } else {
            browserConfiguration = new BrowserConfiguration();
        }
        final Pair<String, CustomTabsSession> session = customTabsSessionFactory
                .getSession(browserConfiguration.getSessionPackageName());

        final CustomTabsIntent.Builder builder;
        if (session == null) {
            builder = new CustomTabsIntent.Builder();
        } else {
            builder = new CustomTabsIntent.Builder(session.second);
        }

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

        if (initialHeightDp != null) {
            final int initialHeightPx = resources.convertToPx(context, initialHeightDp);
            if (resizeBehavior != null) {
                builder.setInitialActivityHeightPx(initialHeightPx, resizeBehavior);
            } else {
                builder.setInitialActivityHeightPx(initialHeightPx);
            }
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

        // Avoid overriding the package if using CustomTabsSession.
        if (customTabsIntent.intent.getPackage() != null) {
            return;
        }
        final String sessionPackageName = options.getSessionPackageName();
        if (sessionPackageName != null) {
            // If CustomTabsSession is not obtained after service binding,
            // fallback to launching the Custom Tabs resolved during warmup.
            customTabsIntent.intent.setPackage(sessionPackageName);
            return;
        }

        final CustomTabsPackageProvider fallback = options.getAdditionalCustomTabs(context);
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

    public @Nullable CustomTabsIntentOptions createIntentOptions(@Nullable Map<String, Object> options) {
        if (options == null) {
            return null;
        }
        return new CustomTabsIntentOptions.Builder()
                .setOptions(options)
                .build();
    }
}
