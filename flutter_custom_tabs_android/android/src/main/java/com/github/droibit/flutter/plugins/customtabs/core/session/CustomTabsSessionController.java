package com.github.droibit.flutter.plugins.customtabs.core.session;

import android.content.ComponentName;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import androidx.browser.customtabs.CustomTabsClient;
import androidx.browser.customtabs.CustomTabsServiceConnection;
import androidx.browser.customtabs.CustomTabsSession;

import io.flutter.Log;

public class CustomTabsSessionController extends CustomTabsServiceConnection {
    private static final @NonNull String TAG = "CustomTabsAndroid";

    private @Nullable Context context;
    private @Nullable CustomTabsSession session;
    private boolean boundCustomTabsService;

    public @Nullable CustomTabsSession getSession() {
        return session;
    }

    @VisibleForTesting
    boolean isBoundCustomTabsService() {
        return boundCustomTabsService;
    }

    public boolean bindCustomTabsService(@NonNull Context context, @NonNull String packageName) {
        if (boundCustomTabsService) {
            Log.d(TAG, "Custom Tab(" + packageName + ") already bound.");
            return true;
        }
        return tryBindCustomTabsService(context, packageName);
    }

    private boolean tryBindCustomTabsService(@NonNull Context context, @NonNull String packageName) {
        try {
            final boolean bound = CustomTabsClient.bindCustomTabsService(context, packageName, this);
            Log.d(TAG, "Custom Tab(" + packageName + ") bound: " + bound);
            boundCustomTabsService = bound;
            this.context = context;
        } catch (SecurityException e) {
            boundCustomTabsService = false;
        }
        return boundCustomTabsService;
    }

    public void unbindCustomTabsService() {
        final Context context = this.context;
        if (context != null) {
            context.unbindService(this);
        }
        session = null;
        boundCustomTabsService = false;
        Log.d(TAG, "Custom Tab unbound.");
    }

    @Override
    public void onCustomTabsServiceConnected(@NonNull ComponentName name, @NonNull CustomTabsClient client) {
        final boolean warmedUp = client.warmup(0);
        Log.d(TAG, "Custom Tab(" + name.getPackageName() + ") warmedUp: " + warmedUp);
        session = client.newSession(null);
    }

    @Override
    public void onServiceDisconnected(ComponentName name) {
        session = null;
        boundCustomTabsService = false;

        final String packageName = name != null ? name.getPackageName() : "unknown";
        Log.d(TAG, "Custom Tab(" + packageName + ") disconnected.");
    }
}
