package com.github.droibit.flutter.plugins.customtabs;

import static android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP;
import static android.content.Intent.FLAG_ACTIVITY_SINGLE_TOP;
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
import androidx.annotation.VisibleForTesting;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.core.content.ContextCompat;
import androidx.core.util.Pair;

import com.github.droibit.flutter.plugins.customtabs.Messages.FlutterError;
import com.github.droibit.flutter.plugins.customtabs.core.CustomTabsIntentFactory;
import com.github.droibit.flutter.plugins.customtabs.core.ExternalBrowserLauncher;
import com.github.droibit.flutter.plugins.customtabs.core.NativeAppLauncher;
import com.github.droibit.flutter.plugins.customtabs.core.PartialCustomTabsLauncher;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsIntentOptions;
import com.github.droibit.flutter.plugins.customtabs.core.options.CustomTabsSessionOptions;
import com.github.droibit.flutter.plugins.customtabs.core.session.CustomTabsSessionController;
import com.github.droibit.flutter.plugins.customtabs.core.session.CustomTabsSessionFactory;

import java.util.Map;
import java.util.Objects;

import io.flutter.Log;

public class CustomTabsLauncher implements Messages.CustomTabsApi {
    @VisibleForTesting
    static final String CODE_LAUNCH_ERROR = "LAUNCH_ERROR";

    private final @NonNull CustomTabsIntentFactory customTabsIntentFactory;
    private final @NonNull CustomTabsSessionFactory customTabsSessionFactory;
    private final @NonNull NativeAppLauncher nativeAppLauncher;
    private final @NonNull ExternalBrowserLauncher externalBrowserLauncher;
    private final @NonNull PartialCustomTabsLauncher partialCustomTabsLauncher;
    private @Nullable Activity activity;

    CustomTabsLauncher() {
        this(
                new CustomTabsIntentFactory(),
                new CustomTabsSessionFactory(),
                new NativeAppLauncher(),
                new ExternalBrowserLauncher(),
                new PartialCustomTabsLauncher()
        );
    }

    @VisibleForTesting
    CustomTabsLauncher(
            @NonNull CustomTabsIntentFactory customTabsIntentFactory,
            @NonNull CustomTabsSessionFactory customTabsSessionFactory,
            @NonNull NativeAppLauncher nativeAppLauncher,
            @NonNull ExternalBrowserLauncher externalBrowserLauncher,
            @NonNull PartialCustomTabsLauncher partialCustomTabsLauncher
    ) {
        this.customTabsIntentFactory = customTabsIntentFactory;
        this.customTabsSessionFactory = customTabsSessionFactory;
        this.nativeAppLauncher = nativeAppLauncher;
        this.externalBrowserLauncher = externalBrowserLauncher;
        this.partialCustomTabsLauncher = partialCustomTabsLauncher;
    }

    void setActivity(@Nullable Activity activity) {
        customTabsSessionFactory.handleActivityChange(activity);
        this.activity = activity;
    }

    @Override
    public void launch(
            @NonNull String urlString,
            @NonNull Boolean prefersDeepLink,
            @Nullable Map<String, Object> options
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
            final CustomTabsIntentOptions customTabsOptions = customTabsIntentFactory
                    .createIntentOptions(options);
            if (externalBrowserLauncher.launch(activity, uri, customTabsOptions)) {
                return;
            }

            final CustomTabsIntent customTabsIntent = customTabsIntentFactory.createIntent(
                    activity,
                    requireNonNull(customTabsOptions),
                    customTabsSessionFactory
            );
            if (partialCustomTabsLauncher.launch(activity, uri, customTabsIntent)) {
                return;
            }
            customTabsIntent.launchUrl(activity, uri);
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
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return;
        }

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

    /**
     * @noinspection SameParameterValue
     */
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

    @Override
    public @Nullable String warmup(@Nullable Map<String, Object> options) {
        final Activity activity = this.activity;
        if (activity == null) {
            Log.w("CustomTabsAndroid", "Activity is null. Cannot warm up custom tabs.");
            return null;
        }

        final CustomTabsSessionOptions sessionOptions = customTabsSessionFactory
                .createSessionOptions(options);
        final Pair<String, CustomTabsSessionController> session = customTabsSessionFactory
                .createSession(activity, sessionOptions);
        if (session == null) {
            return null;
        }

        final String packageName = session.first;
        final CustomTabsSessionController controller = session.second;
        if (controller.bindCustomTabsService(activity, packageName)) {
            return packageName;
        }
        return null;
    }

    @Override
    public void invalidate(@NonNull String packageName) {
        customTabsSessionFactory.invalidateSession(packageName);
    }
}
