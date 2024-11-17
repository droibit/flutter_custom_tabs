package com.github.droibit.flutter.plugins.customtabs.core.session;

import android.content.ComponentName;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.Size;
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

    public void mayLaunchUrls(@NonNull @Size(min = 1) List<String> urls) {
        final CustomTabsSession session = this.session;
        if (session == null) {
            Log.w(TAG, "Custom Tab session is null. Cannot may launch URLs.");
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
