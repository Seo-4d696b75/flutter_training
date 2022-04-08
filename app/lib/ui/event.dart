import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Event<T> {
  T get peek;

  bool get hasValue;

  bool get hasHandled;

  void handleOnce(void Function(T value) handler);

  factory Event.none() {
    return _NotInitEvent();
  }

  factory Event.create(T value) {
    return _Event(value);
  }
}

class _NotInitEvent<T> implements Event<T> {
  @override
  void handleOnce(void Function(T value) handler) {
    // nothing to do
  }

  @override
  bool get hasHandled => false;

  @override
  bool get hasValue => false;

  @override
  get peek => throw StateError("not init yet");
}

class _Event<T> implements Event<T> {
  _Event(T value) : _value = value;

  final T _value;
  bool _hasHandled = false;

  @override
  T get peek => _value;

  @override
  bool get hasHandled => _hasHandled;

  @override
  void handleOnce(void Function(T value) handler) {
    if (!_hasHandled) {
      _hasHandled = true;
      handler(_value);
    }
  }

  @override
  bool get hasValue => true;
}

extension EventListening on WidgetRef {
  void listenEvent<T>(
    ProviderListenable<Event<T>> provider,
    void Function(T value) listener,
  ) {
    listen<Event<T>>(provider, (_, current) {
      current.handleOnce(listener);
    });
  }
}
