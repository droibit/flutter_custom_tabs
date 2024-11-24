package com.github.droibit.flutter.plugins.customtabs.core.session;

import android.content.ComponentName;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import androidx.browser.customtabs.CustomTabsClient;
import androidx.browser.customtabs.CustomTabsService;
import androidx.browser.customtabs.CustomTabsServiceConnection;
import androidx.browser.customtabs.CustomTabsSession;

import java.util.ArrayList;
import java.util.List;

import io.flutter.Log;

public class CustomTabsSessionController extends CustomTabsServiceConnection {
    private static final @NonNull String TAG = "CustomTabsAndroid";

    private final String packageName;
    private @Nullable Context context;
    private @Nullable CustomTabsSession session;
    private boolean customTabsServiceBound;

    public @NonNull String getPackageName() {
        return packageName;
    }

    public @Nullable CustomTabsSession getSession() {
        return session;
    }

    @VisibleForTesting
    void setSession(@Nullable CustomTabsSession session) {
        this.session = session;
    }

    @VisibleForTesting
    boolean isCustomTabsServiceBound() {
        return customTabsServiceBound;
    }

    public CustomTabsSessionController(@NonNull String packageName) {
        this.packageName = packageName;
    }

    public boolean bindCustomTabsService(@NonNull Context context) {
        if (customTabsServiceBound) {
            Log.d(TAG, "Custom Tab(" + packageName + ") already bound.");
            return true;
        }
        return tryBindCustomTabsService(context);
    }

    private boolean tryBindCustomTabsService(@NonNull Context context) {
        try {
            final boolean bound = CustomTabsClient.bindCustomTabsService(context, packageName, this);
            Log.d(TAG, "Custom Tab(" + packageName + ") bound: " + bound);
            if (bound) {
                this.context = context;
            }
            customTabsServiceBound = bound;
        } catch (SecurityException e) {
            customTabsServiceBound = false;
        }
        return customTabsServiceBound;
    }

    public void unbindCustomTabsService() {
        final Context context = this.context;
        if (context != null) {
            context.unbindService(this);
        }
        session = null;
        customTabsServiceBound = false;
        Log.d(TAG, "Custom Tab(" + packageName + ") unbound.");
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
        customTabsServiceBound = false;

        Log.d(TAG, "Custom Tab(" + packageName + ") disconnected.");
    }

    public void mayLaunchUrls(@NonNull List<String> urls) {
        final CustomTabsSession session = this.session;
        if (session == null) {
            Log.w(TAG, "Custom Tab session is null. Cannot may launch URLs.");
            return;
        }
        if (urls.isEmpty()) {
            Log.w(TAG, "URLs is empty. Cannot may launch URLs.");
            return;
        }

        if (urls.size() == 1) {
            final boolean succeeded = session.mayLaunchUrl(Uri.parse(urls.get(0)), null, null);
            Log.d(TAG, "May launch URL: " + succeeded);
            return;
        }

        final List<Bundle> bundles = new ArrayList<>(urls.size());
        for (String url : urls) {
            final Bundle bundle = new Bundle(1);
            bundle.putParcelable(CustomTabsService.KEY_URL, Uri.parse(url));
            bundles.add(bundle);
        }
        final boolean succeeded = session.mayLaunchUrl(null, null, bundles);
        Log.d(TAG, "May launch URL(s): " + succeeded);
    }
}
