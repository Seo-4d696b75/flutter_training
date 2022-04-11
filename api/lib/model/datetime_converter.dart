import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  final _format = "yyyy-MM-dd";

  @override
  DateTime fromJson(String json) {
    return DateFormat(_format).parse(json);
  }

  @override
  String toJson(DateTime object) {
    return DateFormat(_format).format(object);
  }
}
