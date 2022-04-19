import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_climatic_elements.freezed.dart';

part 'main_climatic_elements.g.dart';

@freezed
class MainElements with _$MainElements {
  const factory MainElements({
    @JsonKey(name: "temp") required double temperature,
    @JsonKey(name: "feels_like") required double sensibleTemperature,
    @JsonKey(name: "temp_min") required double minTemperature,
    @JsonKey(name: "temp_max") required double maxTemperature,
    required double pressure,
    required double humidity,
  }) = _MainElements;

  factory MainElements.fromJson(Map<String, dynamic> json) =>
      _$MainElementsFromJson(json);
}
