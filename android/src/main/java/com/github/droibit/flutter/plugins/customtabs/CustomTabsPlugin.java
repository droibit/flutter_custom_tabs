package com.github.droibit.flutter.plugins.customtabs;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.net.Uri;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent;

import com.droibit.android.customtabs.launcher.CustomTabsFallback;
import com.droibit.android.customtabs.launcher.CustomTabsLauncher;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

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
        channel = new MethodChannel(binding.getBinaryMessenger(), "com.github.droibit.flutter.plugins.custom_tabs");
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
}
