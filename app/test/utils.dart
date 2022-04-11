import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TextWidgetMatcher extends CustomMatcher {
  _TextWidgetMatcher(dynamic stringMatcher)
      : super(
          "Text Widget with",
          "string",
          stringMatcher,
        );

  @override
  Object? featureValueOf(actual) {
    // inspired by https://stackoverflow.com/questions/54235752/flutter-how-to-get-text-widget-on-widget-test
    final finder = actual as Finder;
    final w = finder.evaluate().single.widget;
    return (w as Text).data;
  }
}

/// 指定した文字列表現をもつTextのWidgetであるか判定するMatcher
///
/// example: `expect(find.byKey(key), withText(string));`
Matcher withText(dynamic stringMatcher) => _TextWidgetMatcher(stringMatcher);
