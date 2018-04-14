package com.github.droibit.flutter.plugins.customtabs;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class CustomTabsPlugin implements MethodChannel.MethodCallHandler {

  /**
   * Plugin registration.
   */
  public static void registerWith(PluginRegistry.Registrar registrar) {
    final MethodChannel channel =
        new MethodChannel(registrar.messenger(), "flutter_custom_tabs");
    channel.setMethodCallHandler(new CustomTabsPlugin(registrar));
  }

  private final PluginRegistry.Registrar registrar;

  private CustomTabsPlugin(PluginRegistry.Registrar registrar) {
    this.registrar = registrar;
  }

  @Override public void onMethodCall(MethodCall call, MethodChannel.Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }
}

