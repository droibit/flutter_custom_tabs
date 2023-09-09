package com.github.droibit.flutter.plugins.customtabs;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.browser.customtabs.CustomTabsService;
import androidx.core.content.ContextCompat;

import com.droibit.android.customtabs.launcher.CustomTabsFallback;
import com.droibit.android.customtabs.launcher.CustomTabsLauncher;

import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import static android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP;
import static android.content.Intent.FLAG_ACTIVITY_SINGLE_TOP;
import static androidx.browser.customtabs.CustomTabsService.ACTION_CUSTOM_TABS_CONNECTION;

public class CustomTabsPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {

    private static final String KEY_OPTION = "customTabsOption";

    private static final String KEY_URL = "url";

    private static final String CODE_LAUNCH_ERROR = "LAUNCH_ERROR";

    @Nullable
    private Activity activity;

    @Nullable
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "plugins.flutter.droibit.github.io/custom_tabs");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        if (channel == null) {
            return;
        }
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @SuppressWarnings("unchecked")
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final MethodChannel.Result result) {
        if ("launch".equals(call.method)) {
            launch(((Map<String, Object>) call.arguments), result);
        } else if ("closeAllIfPossible".equals(call.method)) {
            closeAllIfPossible(result);
        } else {
            result.notImplemented();
        }
    }

    @SuppressWarnings({"unchecked", "ConstantConditions"})
    private void launch(@NonNull Map<String, Object> args, @NonNull MethodChannel.Result result) {
        final Activity activity = this.activity;
        if (activity == null) {
            result.error(CODE_LAUNCH_ERROR, "Launching a CustomTabs requires a foreground activity.", null);
            return;
        }

        final CustomTabsFactory factory = new CustomTabsFactory(activity);
        try {
            final Map<String, Object> options = (Map<String, Object>) args.get(KEY_OPTION);
            final CustomTabsIntent customTabsIntent = factory.createIntent(options);
            final Uri uri = Uri.parse(args.get(KEY_URL).toString());
            final CustomTabsFallback fallback = factory.createFallback(options);
            CustomTabsLauncher.launch(activity, customTabsIntent, uri, fallback);
            result.success(null);
        } catch (ActivityNotFoundException e) {
            result.error(CODE_LAUNCH_ERROR, e.getMessage(), null);
        }
    }

    private void closeAllIfPossible(@NonNull MethodChannel.Result result) {
        final Activity activity = this.activity;
        if (activity == null) {
            result.success(null);
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
                if (activity.getPackageManager().resolveService(serviceIntent, 0) != null) {
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
        result.success(null);
    }
}
