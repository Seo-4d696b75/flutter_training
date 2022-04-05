enum Weather { Sunny, Cloudy, Rainy }

Weather parseWeather(String value) {
  switch (value) {
    case "sunny":
      return Weather.Sunny;
    case "cloudy":
      return Weather.Cloudy;
    case "rainy":
      return Weather.Rainy;
    default:
      throw ArgumentError("invalid weather string value: $value");
  }
}
