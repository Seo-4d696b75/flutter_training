import 'dart:convert';

import 'package:api/model/response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const jsonString1 = """
{
  "weather": "sunny",
  "maxTemp": 20,
  "minTemp": 10,
  "date": "2022-01-01"
}
  """;
  final date1 = DateTime(2022, DateTime.january, 1);
  const jsonString2 = """
{
  "weather": "rainy",
  "maxTemp": 10,
  "minTemp": 8,
  "date": "2022-04-11"
}
  """;
  final date2 = DateTime(2022, DateTime.april, 11);
  group("JSON decode", () {
    test("case1", () {
      var response = Response.fromJson(json.decode(jsonString1));
      expect(response.weather, "sunny");
      expect(response.maxTemp, 20);
      expect(response.minTemp, 10);
      expect(response.date, date1);
    });
    test("case2", () {
      var response = Response.fromJson(json.decode(jsonString2));
      expect(response.weather, "rainy");
      expect(response.maxTemp, 10);
      expect(response.minTemp, 8);
      expect(response.date, date2);
    });
  });
  group("JSON encode", () {
    const encoder = JsonEncoder.withIndent("  ");
    test("case1", () {
      var request = Response(
        weather: "sunny",
        maxTemp: 20,
        minTemp: 10,
        date: date1,
      );
      var str = encoder.convert(request.toJson());
      expect(str, jsonString1.trim());
    });
    test("case2", () {
      var request = Response(
        weather: "rainy",
        maxTemp: 10,
        minTemp: 8,
        date: date2,
      );
      var str = encoder.convert(request.toJson());
      expect(str, jsonString2.trim());
    });
  });
}
