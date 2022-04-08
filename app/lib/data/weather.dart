enum Weather { sunny, cloudy, rainy }

Weather parseWeather(String value) {
  switch (value) {
    case "sunny":
      return Weather.sunny;
    case "cloudy":
      return Weather.cloudy;
    case "rainy":
      return Weather.rainy;
    default:
      throw ArgumentError("invalid weather string value: $value");
  }
}
