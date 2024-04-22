import 'package:flutter/material.dart';
import '../api/OpenWeatherMap.dart';
import 'package:url_launcher/url_launcher.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Map<String, dynamic> airQuality = {};
  List<dynamic> forecastData = [];
  Uri? weatherMapUrl;

  final OpenWeatherMapAPI weatherApi = OpenWeatherMapAPI(
      apiKey: '76ebb83681279eea1a7c0dbecba1c26e', // API key
      city: 'London',
      latitude: 51.5074,
      longitude: -0.1278
      );

  @override
  void initState() {
    super.initState();
    loadAirQuality();
    loadForecastData();
  }

  void loadForecastData() async {
    try {
      forecastData = await weatherApi.getThreeHourForecast();
      setState(() {});
    } catch (e) {
      print('Failed to load forecast data: $e');
    }
  }

  void loadAirQuality() async {
    try {
      airQuality = await weatherApi.getAirQuality();
      setState(() {});
    } catch (e) {
      print('Failed to load air quality data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Information'),
      ),
      body: Column(
        children: [
          // air quality
          Expanded(
            flex: 1,
            child: Center(
              child: airQuality.isNotEmpty
                  ? Text('AQI: ${airQuality['aqi']}',
                      style: TextStyle(fontSize: 24))
                  : CircularProgressIndicator(),
            ),
          ),
          // forecast list
          Expanded(
            flex: 2,
            child: forecastData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: forecastData.length,
                    itemBuilder: (context, index) {
                      var item = forecastData[index];
                      return ListTile(
                        title: Text('${item['dt_txt']}'), // weather and time
                        subtitle: Text(
                            '${item['weather'][0]['description']} at ${item['main']['temp']}°C'),
                        trailing: Image.network(
                          'http://openweathermap.org/img/wn/${item['weather'][0]['icon']}.png', // load weather icon
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
