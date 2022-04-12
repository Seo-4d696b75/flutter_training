import 'dart:core';

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

/// 外部から終了可能なFutureを扱う
///
/// Basic Usage:
/// 1. 初期化 `var latch = Latch();`
/// 2. 待機させたい箇所で使用 `await latch.wait;`
/// 3. 終了させる `latch.complete();`
class Latch {
  /// period: 終了条件を監視する時間幅
  Latch({Duration? period})
      : _period = period ?? const Duration(milliseconds: 100);

  final Duration _period;
  var _waiting = true;

  /// このlatchが`#complete`で終了されるまで待機するFuture
  ///
  /// すでに`#complate`で終了済みの場合は即座に完了するFutureを返す
  Future<void> get wait => _waiting
      ? Future.sync(() async {
          while (_waiting) {
            await Future.delayed(_period);
          }
        })
      : Future.value();

  /// `#wait`で返したFutureを終了する
  ///
  /// **注意** Futureは即座に終了しない
  /// 指定した時間間隔でこの終了呼び出しを監視して`#complate`が呼ばれた以降のタイミングでFutureを終了させる
  void complete() {
    _waiting = false;
  }
}
