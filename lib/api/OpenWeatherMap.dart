import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class OpenWeatherMapAPI {
  final String apiKey;
  final double latitude;
  final double longitude;

  OpenWeatherMapAPI(
      {required this.apiKey, required this.latitude, required this.longitude});

  Future<Map<String, dynamic>> getAirQuality() async {
    var url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/air_pollution?lat=$latitude&lon=$longitude&appid=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return {
        'aqi': data['list'][0]['main']['aqi'],
      };
    } else {
      throw Exception(
          'Failed to load air quality data with status: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to load current weather data with status: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getThreeHourForecast() async {
    var url = Uri.parse(
        // 'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric');
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['list']; // forecast
    } else {
      throw Exception(
          'Failed to load 3-hour forecast with status: ${response.statusCode}');
    }
  }
}
