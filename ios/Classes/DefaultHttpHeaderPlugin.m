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
    } else {
        result(FlutterMethodNotImplemented);
    }
}


- (NSDictionary<const NSString *, NSString *> *)getAllDefaultHeaders{
    return @{acceptLanguageHeader: [self getAcceptLanguage],};
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

@end
