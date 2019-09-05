import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:default_http_header_plugin/default_http_header_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('default_http_header_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await DefaultHttpHeaderPlugin.platformVersion, '42');
  });
}
