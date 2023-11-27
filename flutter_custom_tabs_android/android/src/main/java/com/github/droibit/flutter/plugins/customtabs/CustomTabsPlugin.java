package com.github.droibit.flutter.plugins.customtabs;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

public class CustomTabsPlugin implements FlutterPlugin, ActivityAware {
    private @Nullable CustomTabsLauncher api;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        api = new CustomTabsLauncher();
        Messages.CustomTabsApi.setUp(binding.getBinaryMessenger(), api);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        if (api == null) {
            return;
        }

        Messages.CustomTabsApi.setUp(binding.getBinaryMessenger(), null);
        api = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        if (api == null) {
            return;
        }
        api.setActivity(binding.getActivity());
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
        if (api == null) {
            return;
        }
        api.setActivity(null);
    }
}
