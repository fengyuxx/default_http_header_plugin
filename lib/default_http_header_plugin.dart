import 'dart:async';

import 'package:flutter/services.dart';

class DefaultHttpHeaderPlugin {
  static const MethodChannel _channel =
      const MethodChannel('default_http_header_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Map<dynamic, dynamic>> get allDefaultHeaders async {
    final headers = await _channel.invokeMethod('getAllDefaultHeaders');
    return headers;
  }

  static Future<String> get acceptLanguage async {
    final String acceptLanguage = await _channel.invokeMethod('getAcceptLanguage');
    return acceptLanguage;
  }

  static Future<String> get userAgent async {
    final String userAgent = await _channel.invokeMethod('getUserAgent');
    return userAgent;
  }
}
