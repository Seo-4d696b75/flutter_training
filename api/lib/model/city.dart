import 'package:freezed_annotation/freezed_annotation.dart';

part 'city.freezed.dart';

part 'city.g.dart';

@freezed
class City with _$City {
  const factory City({
    required String name,
    required int id,
    required String country,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  static const tokyo = City(name: "Tokyo", id: 1850147, country: "JP");
  static const sapporo = City(name: "Sapporo", id: 2128295, country: "JP");
  static const osaka = City(name: "Osaka", id: 1853908, country: "JP");
  static const fukuoka = City(name: "Fukuoka", id: 1863967, country: "JP");
  static const okinawa = City(name: "Okinawa", id: 1854345, country: "JP");
  static const newYork = City(name: "New York", id: 5128581, country: "US");
  static const london = City(name: "London", id: 2643743, country: "GB");
}

final cities = List<City>.unmodifiable([
  City.tokyo,
  City.sapporo,
  City.osaka,
  City.fukuoka,
  City.okinawa,
  City.newYork,
  City.london
]);
