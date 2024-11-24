package com.github.droibit.flutter.plugins.customtabs.core.session;

import static com.droibit.android.customtabs.launcher.CustomTabsIntentHelper.getCustomTabsPackage;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import androidx.browser.customtabs.CustomTabsSession;

import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsSessionOptions;

import java.util.HashMap;
import java.util.Map;

public class CustomTabsSessionManager implements CustomTabsSessionProvider {
    private static final @NonNull String TAG = "CustomTabsAndroid";

    private final @NonNull Map<String, CustomTabsSessionController> cachedSessions;

    public CustomTabsSessionManager() {
        this(new HashMap<>());
    }

    @VisibleForTesting
    CustomTabsSessionManager(@NonNull Map<String, CustomTabsSessionController> cachedSessions) {
        this.cachedSessions = cachedSessions;
    }

    public @NonNull CustomTabsSessionOptions createSessionOptions(@Nullable Map<String, Object> options) {
        return new CustomTabsSessionOptions.Builder()
                .setOptions(options)
                .build();
    }

    public @Nullable CustomTabsSessionController createSessionController(
            @NonNull Context context,
            @NonNull CustomTabsSessionOptions options
    ) {
        final Boolean prefersDefaultBrowser = options.getPrefersDefaultBrowser();
        final String customTabsPackage = getCustomTabsPackage(
                context,
                prefersDefaultBrowser != null && !prefersDefaultBrowser,
                options.getAdditionalCustomTabs(context)
        );
        if (customTabsPackage == null) {
            return null;
        }

        final CustomTabsSessionController cachedController = cachedSessions.get(customTabsPackage);
        if (cachedController != null) {
            return cachedController;
        }

        final CustomTabsSessionController newController = new CustomTabsSessionController(customTabsPackage);
        cachedSessions.put(customTabsPackage, newController);
        return newController;
    }

    public @Nullable CustomTabsSessionController getSessionController(@NonNull String packageName) {
        return cachedSessions.get(packageName);
    }

    @Override
    public @Nullable CustomTabsSession getSession(@Nullable String packageName) {
        if (packageName == null) {
            return null;
        }

        final CustomTabsSessionController controller = cachedSessions.get(packageName);
        if (controller == null) {
            return null;
        }
        return controller.getSession();
    }

    public void invalidateSession(@NonNull String packageName) {
        final CustomTabsSessionController controller = cachedSessions.get(packageName);
        if (controller == null) {
            return;
        }
        controller.unbindCustomTabsService();
        cachedSessions.remove(packageName);
    }

    public void handleActivityChange(@Nullable Context activity) {
        Log.d(TAG, "handleActivityChange: " + activity);
        for (CustomTabsSessionController controller : cachedSessions.values()) {
            if (activity == null) {
                controller.unbindCustomTabsService();
            } else {
                controller.bindCustomTabsService(activity);
            }
        }
    }
}
