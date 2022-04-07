import 'package:api/model/datetime_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'request.freezed.dart';

part 'request.g.dart';

@freezed
class Request with _$Request {
  const factory Request({
    @DateTimeConverter() required DateTime date,
    required String area,
  }) = _Request;

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);
}
