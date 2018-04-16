#import "CustomTabsPlugin.h"

@implementation GDBCustomTabsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.github.droibit.flutter.plugins.custom_tabs"
            binaryMessenger:[registrar messenger]];
  GDBCustomTabsPlugin* instance = [[GDBCustomTabsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  result(FlutterMethodNotImplemented);
}

@end
