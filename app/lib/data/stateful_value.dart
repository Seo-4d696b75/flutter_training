import 'package:freezed_annotation/freezed_annotation.dart';

part 'stateful_value.freezed.dart';

@freezed
abstract class StatefulValue<T, E> with _$StatefulValue<T, E> {
  const factory StatefulValue.data(T value) = Data<T, E>;

  const factory StatefulValue.error(E error) = Error<T, E>;

  const factory StatefulValue.none() = None;
}
