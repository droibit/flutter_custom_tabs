package com.github.droibit.flutter.plugins.customtabs.core;

import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR;
import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_INITIAL_ACTIVITY_HEIGHT_PX;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import androidx.annotation.NonNull;
import androidx.browser.customtabs.CustomTabsIntent;

public class PartialCustomTabsLauncher {
    private static final int REQUEST_CODE_PARTIAL_CUSTOM_TABS = 1001;

    public PartialCustomTabsLauncher() {
    }

    public boolean launch(
            @NonNull Activity activity,
            @NonNull Uri uri,
            @NonNull CustomTabsIntent customTabsIntent
    ) {
        final Intent rawIntent = customTabsIntent.intent;
        if (rawIntent.hasExtra(EXTRA_INITIAL_ACTIVITY_HEIGHT_PX) &&
                rawIntent.hasExtra(EXTRA_ACTIVITY_HEIGHT_RESIZE_BEHAVIOR)) {
            // ref. https://developer.chrome.com/docs/android/custom-tabs/guide-partial-custom-tabs
            rawIntent.setData(uri);
            activity.startActivityForResult(rawIntent, REQUEST_CODE_PARTIAL_CUSTOM_TABS);
            return true;
        }
        return false;
    }
}
