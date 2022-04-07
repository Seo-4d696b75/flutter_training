import 'package:api/model/datetime_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.freezed.dart';

part 'response.g.dart';

@freezed
class Response with _$Response {
  const factory Response({
    required String weather,
    required int maxTemp,
    required int minTemp,
    @DateTimeConverter() required DateTime date,
  }) = _Response;

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
}
