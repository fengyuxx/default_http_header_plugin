#import "DefaultHttpHeaderPlugin.h"
#import "HttpHeader.h"

@implementation DefaultHttpHeaderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"default_http_header_plugin"
                                     binaryMessenger:[registrar messenger]];
    DefaultHttpHeaderPlugin* instance = [[DefaultHttpHeaderPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if ([@"getAllDefaultHeaders" isEqualToString:call.method]) {
        result([self getAllDefaultHeaders]);
    }else if ([@"getAcceptLanguage" isEqualToString:call.method]) {
        result([self getAcceptLanguage]);
    }else if ([@"getUserAgent" isEqualToString:call.method]) {
        result([self getUserAgent]);
    }else {
        result(FlutterMethodNotImplemented);
    }
}


- (NSDictionary<const NSString *, NSString *> *)getAllDefaultHeaders{
    return @{acceptLanguageHeader: [self getAcceptLanguage],
             userAgentHeader: [self getUserAgent],};
}

- (NSString *)getAcceptLanguage{
    // Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
    NSMutableArray *list = [NSMutableArray array];
    [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        float q = 1.0f - (idx * 0.1f);
        [list addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
        *stop = q <= 0.5f;
    }];
    return [list componentsJoinedByString:@", "];
}

- (NSString *)getUserAgent{
    NSString *userAgent = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
#if TARGET_OS_IOS
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#elif TARGET_OS_WATCH
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; watchOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[WKInterfaceDevice currentDevice] model], [[WKInterfaceDevice currentDevice] systemVersion], [[WKInterfaceDevice currentDevice] screenScale]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
#pragma clang diagnostic pop
    return userAgent;
}

@end
