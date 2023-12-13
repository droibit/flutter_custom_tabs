package com.github.droibit.flutter.plugins.customtabs;

import static android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP;
import static android.content.Intent.FLAG_ACTIVITY_SINGLE_TOP;
import static androidx.browser.customtabs.CustomTabsIntent.EXTRA_INITIAL_ACTIVITY_HEIGHT_PX;
import static androidx.browser.customtabs.CustomTabsService.ACTION_CUSTOM_TABS_CONNECTION;
import static java.util.Objects.requireNonNull;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.core.content.ContextCompat;

import com.github.droibit.flutter.plugins.customtabs.Messages.CustomTabsOptionsMessage;
import com.github.droibit.flutter.plugins.customtabs.Messages.FlutterError;

import java.util.Objects;

class CustomTabsLauncher implements Messages.CustomTabsApi {
    private static final String CODE_LAUNCH_ERROR = "LAUNCH_ERROR";
    private static final int REQUEST_CODE_CUSTOM_TABS = 0;

    private final @NonNull CustomTabsFactory customTabsFactory;
    private final @NonNull NativeAppLauncher nativeAppLauncher;
    private @Nullable Activity activity;

    public CustomTabsLauncher() {
        this(new CustomTabsFactory(), new NativeAppLauncher());
    }

    public CustomTabsLauncher(
            @NonNull CustomTabsFactory customTabsFactory,
            @NonNull NativeAppLauncher nativeAppLauncher
    ) {
        this.customTabsFactory = customTabsFactory;
        this.nativeAppLauncher = nativeAppLauncher;
    }

    void setActivity(@Nullable Activity activity) {
        this.activity = activity;
    }

    @Override
    public void launch(
            @NonNull String urlString,
            @NonNull Boolean prefersDeepLink,
            @Nullable CustomTabsOptionsMessage options
    ) {
        final Activity activity = this.activity;
        if (activity == null) {
            throw new FlutterError(CODE_LAUNCH_ERROR, "Launching a custom tab requires a foreground activity.", null);
        }

        final Uri uri = Uri.parse(urlString);
        if (prefersDeepLink && nativeAppLauncher.launch(activity, uri)) {
            return;
        }

        try {
            final Intent externalBrowserIntent = customTabsFactory.createExternalBrowserIntent(options);
            if (externalBrowserIntent != null) {
                externalBrowserIntent.setData(uri);
                activity.startActivity(externalBrowserIntent);
                return;
            }

            final CustomTabsIntent customTabsIntent = customTabsFactory
                    .createCustomTabsIntent(activity, requireNonNull(options));
            if (customTabsIntent.intent.hasExtra(EXTRA_INITIAL_ACTIVITY_HEIGHT_PX)) {
                customTabsIntent.intent.setData(uri);
                activity.startActivityForResult(customTabsIntent.intent, REQUEST_CODE_CUSTOM_TABS);
            } else {
                customTabsIntent.launchUrl(activity, uri);
            }
        } catch (ActivityNotFoundException e) {
            throw new FlutterError(CODE_LAUNCH_ERROR, e.getMessage(), null);
        }
    }

    @Override
    public void closeAllIfPossible() {
        final Activity activity = this.activity;
        if (activity == null) {
            return;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            final ActivityManager am = ContextCompat.getSystemService(activity, ActivityManager.class);
            final ComponentName selfActivityName = new ComponentName(activity, activity.getClass());
            //noinspection DataFlowIssue
            for (ActivityManager.AppTask appTask : am.getAppTasks()) {
                final ActivityManager.RecentTaskInfo taskInfo = appTask.getTaskInfo();
                if (!Objects.equals(selfActivityName, taskInfo.baseActivity) ||
                        taskInfo.topActivity == null) {
                    continue;
                }
                final Intent serviceIntent = new Intent(ACTION_CUSTOM_TABS_CONNECTION)
                        .setPackage(taskInfo.topActivity.getPackageName());

                if (resolveService(activity.getPackageManager(), serviceIntent, 0) != null) {
                    try {
                        final Intent intent = new Intent(activity, activity.getClass())
                                .setFlags(FLAG_ACTIVITY_CLEAR_TOP | FLAG_ACTIVITY_SINGLE_TOP);
                        activity.startActivity(intent);
                    } catch (ActivityNotFoundException ignored) {
                    }
                    break;
                }
            }
        }
    }

    @SuppressWarnings("deprecation")
    private static @Nullable ResolveInfo resolveService(
            @NonNull PackageManager pm,
            @NonNull Intent intent,
            int flags
    ) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return pm.resolveService(
                    intent,
                    PackageManager.ResolveInfoFlags.of(flags)
            );
        } else {
            return pm.resolveService(intent, flags);
        }
    }
}
