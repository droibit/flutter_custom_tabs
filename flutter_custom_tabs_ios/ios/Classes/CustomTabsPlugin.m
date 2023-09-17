#import "CustomTabsPlugin.h"
#if __has_include(<flutter_custom_tabs_ios/flutter_custom_tabs_ios-Swift.h>)
#import <flutter_custom_tabs_ios/flutter_custom_tabs_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_custom_tabs_ios-Swift.h"
#endif

@implementation GDBCustomTabsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [CustomTabsPlugin registerWithRegistrar:registrar];
}

@end
