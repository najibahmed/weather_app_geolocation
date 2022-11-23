import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as Http;
import '../Models/current_weather_response.dart';
import '../Models/forecast_weather_response.dart';
import '../utils/constants.dart';

class WeatherProvider extends ChangeNotifier {
  CurrentWeatherResponse currentWeatherResponse = CurrentWeatherResponse();
  ForecastWeatherResponse forecastWeatherResponse = ForecastWeatherResponse();

  Future<void> getCurrentWeatherData(Position position) async {
    final urlString =
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$WeatherAPI_KEY';
    final response = await Http.get(Uri.parse(urlString));
    final map = json.decode(response.body);
    if (response.statusCode == 200) {
      currentWeatherResponse = CurrentWeatherResponse.fromJson(map);
      print(currentWeatherResponse.main!.temp.toString());
      notifyListeners();
    } else {
      map['message'];
    }
  }
}
