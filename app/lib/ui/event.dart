import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Event<T> {
  T get peek;

  bool get hasValue;

  void handle(void Function(T value) handler);

  factory Event.none() {
    return _NotInitEvent();
  }

  factory Event.create(T value) {
    return _Event(value);
  }
}

class _NotInitEvent<T> implements Event<T> {
  @override
  void handle(void Function(T value) handler) {
    // nothing to do
  }

  @override
  bool get hasValue => false;

  @override
  get peek => throw StateError("not init yet");
}

class _Event<T> implements Event<T> {
  _Event(T value) : _value = value;

  final T _value;

  @override
  T get peek => _value;

  @override
  void handle(void Function(T value) handler) {
    handler(_value);
  }

  @override
  bool get hasValue => true;
}

extension EventListening on WidgetRef {
  /// Eventが更新される度にコールバックされる
  ///
  /// - 有効な値を持つEvent型[Event#create]の場合のみコールバックする
  /// - Event<T>がラップするT型のオブジェクトが等価(==)でもEventオブジェクトが別なら再度コールバックされる
  void listenEvent<T>(
    ProviderListenable<Event<T>> provider,
    void Function(T value) listener, {
    void Function(Object value, StackTrace trace)? onError,
  }) {
    listen<Event<T>>(
      provider,
      (_, current) {
        current.handle(listener);
      },
      onError: onError,
    );
  }
}
