import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as Http;
import 'package:weather_app08/Utils/constants.dart';
import '../Models/current_weather_model.dart';
import '../Models/forecast_weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  CurrentWeatherResponse? currentWeatherResponse ;
  ForecastWeatherResponse? forecastWeatherResponse ;
  double latitude = 0.0;
  double longitude = 0.0;
  String tempUnit = metric;
  String tempUnitSymbol = celsius;
  String timePattern = timePattern12;

  void setNewLocation(double lat, double lng){
    latitude = lat;
    longitude = lng;
  }

  void setTimePattern(bool status){
    timePattern = status ? timePattern24 : timePattern12;
    notifyListeners();
  }
   Future<void> convertAddressToLatLng(String city)async{
    try {
       final locationList = await locationFromAddress(city);
       if(locationList.isNotEmpty){
         final location = locationList.first;
         latitude = location.latitude;
         longitude = location.longitude;
         getData();
       }else{
         print('No location found from your provided Adress.');
       }
    } catch(error){
      print(error.toString());
    }
   }

  void getData (){
    _getCurrentWeatherData();
    _getForecastWeatherData();
  }
  void setTempUnit(bool status){
    tempUnit= status? imperial: metric;
    tempUnitSymbol=status? fahrenheit: celsius;
    getData();
  }

  bool get hasDataResponse =>
  currentWeatherResponse != null
  && forecastWeatherResponse != null;

  Future<void> _getForecastWeatherData() async {
    final urlString =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=$tempUnit&appid=$weatherApiKey';
    final response = await Http.get(Uri.parse(urlString));
    final map = json.decode(response.body);
    if (response.statusCode == 200) {
      currentWeatherResponse = CurrentWeatherResponse.fromJson(map);
      notifyListeners();
    } else {
      map['message'];
    }
  }

  Future<void> _getCurrentWeatherData() async {
    final urlString =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=$tempUnit&appid=$weatherApiKey';
    final response = await Http.get(Uri.parse(urlString));
    final map = json.decode(response.body);
    if (response.statusCode == 200) {
      forecastWeatherResponse = ForecastWeatherResponse.fromJson(map);
      notifyListeners();
    } else {
      map['message'];
    }
  }

}
