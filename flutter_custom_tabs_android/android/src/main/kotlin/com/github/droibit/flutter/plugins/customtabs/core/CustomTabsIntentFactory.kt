package com.github.droibit.flutter.plugins.customtabs.core

import android.content.Context
import android.provider.Browser.EXTRA_HEADERS
import androidx.annotation.VisibleForTesting
import androidx.browser.customtabs.CustomTabsIntent
import androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_DARK
import androidx.browser.customtabs.CustomTabsIntent.COLOR_SCHEME_LIGHT
import androidx.core.content.res.ResourcesCompat.ID_NULL
import com.droibit.android.customtabs.launcher.setChromeCustomTabsPackage
import com.droibit.android.customtabs.launcher.setCustomTabsPackage
import com.github.droibit.flutter.plugins.customtabs.core.options.BrowserConfiguration
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsAnimations
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsCloseButton
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsColorSchemes
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions
import com.github.droibit.flutter.plugins.customtabs.core.options.PartialCustomTabsConfiguration
import com.github.droibit.flutter.plugins.customtabs.core.session.CustomTabsSessionProvider
import com.github.droibit.flutter.plugins.customtabs.core.utils.extractBundle

class CustomTabsIntentFactory @VisibleForTesting internal constructor(
    private val resources: ResourceFactory
) {
    constructor() : this(ResourceFactory())

    fun createIntentOptions(options: Map<String, Any?>?): CustomTabsIntentOptions? {
        if (options == null) {
            return null
        }
        return CustomTabsIntentOptions.Builder()
            .setOptions(options)
            .build()
    }

    fun createIntent(
        context: Context,
        options: CustomTabsIntentOptions,
        sessionProvider: CustomTabsSessionProvider
    ): CustomTabsIntent {
        val browserConfiguration = options.browser ?: BrowserConfiguration.Builder().build()
        val session = sessionProvider.getSession(browserConfiguration.sessionPackageName)
        val builder = CustomTabsIntent.Builder(session)

        options.colorSchemes?.let { applyColorSchemes(builder, it) }
        options.closeButton?.let { applyCloseButton(context, builder, it) }
        options.urlBarHidingEnabled?.let { builder.setUrlBarHidingEnabled(it) }
        options.shareState?.let { builder.setShareState(it) }
        options.showTitle?.let { builder.setShowTitle(it) }
        options.instantAppsEnabled?.let { builder.setInstantAppsEnabled(it) }
        options.animations?.let { applyAnimations(context, builder, it) }
        options.partial?.let { applyPartialCustomTabsConfiguration(context, builder, it) }

        return builder.build().apply {
            applyBrowserConfiguration(context, this, browserConfiguration)
        }
    }

    @VisibleForTesting
    internal fun applyColorSchemes(
        builder: CustomTabsIntent.Builder,
        colorSchemes: CustomTabsColorSchemes
    ) {
        colorSchemes.colorScheme?.let { builder.setColorScheme(it) }
        colorSchemes.lightParams?.let { builder.setColorSchemeParams(COLOR_SCHEME_LIGHT, it) }
        colorSchemes.darkParams?.let { builder.setColorSchemeParams(COLOR_SCHEME_DARK, it) }
        colorSchemes.defaultPrams?.let { builder.setDefaultColorSchemeParams(it) }
    }

    @VisibleForTesting
    internal fun applyCloseButton(
        context: Context,
        builder: CustomTabsIntent.Builder,
        closeButton: CustomTabsCloseButton
    ) {
        val icon = closeButton.icon
        if (icon != null) {
            val closeButtonIcon = resources.getBitmap(context, icon)
            if (closeButtonIcon != null) {
                builder.setCloseButtonIcon(closeButtonIcon)
            }
        }

        val position = closeButton.position
        if (position != null) {
            builder.setCloseButtonPosition(position)
        }
    }

    @VisibleForTesting
    internal fun applyAnimations(
        context: Context,
        builder: CustomTabsIntent.Builder,
        animations: CustomTabsAnimations
    ) {
        val startEnterAnimationId = resources.getAnimationIdentifier(context, animations.startEnter)
        val startExitAnimationId = resources.getAnimationIdentifier(context, animations.startExit)
        if (startEnterAnimationId != ID_NULL && startExitAnimationId != ID_NULL) {
            builder.setStartAnimations(context, startEnterAnimationId, startExitAnimationId)
        }

        val endEnterAnimationId = resources.getAnimationIdentifier(context, animations.endEnter)
        val endExitAnimationId = resources.getAnimationIdentifier(context, animations.endExit)
        if (endEnterAnimationId != ID_NULL && endExitAnimationId != ID_NULL) {
            builder.setExitAnimations(context, endEnterAnimationId, endExitAnimationId)
        }
    }

    @VisibleForTesting
    internal fun applyPartialCustomTabsConfiguration(
        context: Context,
        builder: CustomTabsIntent.Builder,
        configuration: PartialCustomTabsConfiguration
    ) {
        configuration.initialHeight?.let { initialHeightDp ->
            val initialHeightPx = resources.convertToPx(context, initialHeightDp)
            val resizeBehavior = configuration.activityHeightResizeBehavior
            if (resizeBehavior == null) {
                builder.setInitialActivityHeightPx(initialHeightPx)
            } else {
                builder.setInitialActivityHeightPx(initialHeightPx, resizeBehavior)
            }
        }
        configuration.cornerRadius?.let { builder.setToolbarCornerRadiusDp(it) }
    }

    @VisibleForTesting
    internal fun applyBrowserConfiguration(
        context: Context,
        customTabsIntent: CustomTabsIntent,
        options: BrowserConfiguration
    ) {
        val rawIntent = customTabsIntent.intent
        options.headers?.let { rawIntent.putExtra(EXTRA_HEADERS, extractBundle(it)) }

        // Avoid overriding the package if using CustomTabsSession.
        if (rawIntent.getPackage() != null) {
            return
        }
        val sessionPackageName = options.sessionPackageName
        if (sessionPackageName != null) {
            // If CustomTabsSession is not obtained after service binding,
            // fallback to launching the Custom Tabs resolved during warmup.
            rawIntent.setPackage(sessionPackageName)
            return
        }

        val fallback = options.getAdditionalCustomTabs(context)
        val prefersDefaultBrowser = options.prefersDefaultBrowser
        if (prefersDefaultBrowser == true) {
            customTabsIntent.setCustomTabsPackage(context, fallback)
        } else {
            customTabsIntent.setChromeCustomTabsPackage(context, fallback)
        }
    }
}
