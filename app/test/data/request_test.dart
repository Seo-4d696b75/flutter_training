import 'dart:convert';

import 'package:api/model/request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const jsonString1 = """
{
  "date": "2022-01-01",
  "area": "tokyo"
}
  """;
  final date1 = DateTime(2022, DateTime.january, 1);
  const jsonString2 = """
{
  "date": "2022-04-11",
  "area": "sapporo"
}
  """;
  final date2 = DateTime(2022, DateTime.april, 11);
  group("JSON decode", () {
    test("case1", () {
      var request = Request.fromJson(json.decode(jsonString1));
      expect(request.date, date1);
      expect(request.area, "tokyo");
    });
    test("case2", () {
      var request = Request.fromJson(json.decode(jsonString2));
      expect(request.date, date2);
      expect(request.area, "sapporo");
    });
  });
  group("JSON encode", () {
    const encoder = JsonEncoder.withIndent("  ");
    test("case1", () {
      var request = Request(date: date1, area: "tokyo");
      var str = encoder.convert(request.toJson());
      expect(str, jsonString1.trim());
    });
    test("case2", () {
      var request = Request(date: date2, area: "sapporo");
      var str = encoder.convert(request.toJson());
      expect(str, jsonString2.trim());
    });
  });
}
