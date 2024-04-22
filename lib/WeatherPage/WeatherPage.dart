import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../api/OpenWeatherMap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api/LocationService.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Map<String, dynamic> airQuality = {};
  List<dynamic> forecastData = [];
  Uri? widgetUrl;
  Position? _currentPosition;
  OpenWeatherMapAPI? weatherApi;
  Map<String, dynamic> currentWeather = {};

  @override
  void initState() {
    super.initState();
    loadAirQuality();
    loadForecastData();
    _getLocationAndWeather();
  }

  void _getLocationAndWeather() async {
    LocationService locationService = LocationService();
    try {
      _currentPosition = await locationService.getCurrentLocation();
      if (_currentPosition != null) {
        weatherApi = OpenWeatherMapAPI(
            apiKey: '76ebb83681279eea1a7c0dbecba1c26e', // API key
            latitude: _currentPosition!.latitude,
            longitude: _currentPosition!.longitude);
        loadForecastData();
        loadAirQuality();
        loadWeatherData();
      }
    } catch (e) {
      print('Failed to get location: $e');
    }
  }

  void loadForecastData() async {
    try {
      forecastData = (await weatherApi?.getThreeHourForecast())!;
      setState(() {});
    } catch (e) {
      print('Failed to load forecast data: $e');
    }
  }

  void loadAirQuality() async {
    try {
      airQuality = await weatherApi!.getAirQuality();
      setState(() {});
    } catch (e) {
      print('Failed to load air quality data: $e');
    }
  }

  void loadWeatherData() async {
    try {
      currentWeather = await weatherApi!.getCurrentWeather();
      forecastData = await weatherApi!.getThreeHourForecast();
      setState(() {});
    } catch (e) {
      print('Error loading weather data: $e');
    }
  }

// make app more fun
  String getAirQualityDescription(int aqi) {
    if (aqi <= 50) {
      return 'Good! Let\'s play outside!';
    } else if (aqi <= 100) {
      return 'Fair, good to play outside!';
    } else if (aqi <= 150) {
      return 'Moderate, it\'s Okay to play outside.';
    } else if (aqi <= 200) {
      return 'Poor, maybe I\'m not really want to play outside?';
    } else {
      return 'Very poor, it would be great not to go outside!';
    }
  }

// convert reading
  double convertKelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather Information',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 255, 182, 47),
      ),
      backgroundColor: Color.fromARGB(255, 255, 247, 229),
      body: Column(
        children: [
          // air quality section, smaller size
          Expanded(
            flex: 1, // Less space allocation
            child: Center(
              child: airQuality.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize
                          .min, // To keep the text centered vertically
                      children: [
                        Text(
                          'Air Quality Index: ${airQuality['aqi']}',
                          style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 114, 76, 39)),
                        ),
                        SizedBox(
                            height:
                                screenHeight * 0.01), // Spacing between texts
                        Text(
                          '${getAirQualityDescription(airQuality['aqi'])}',
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 228, 209, 34)),
                        ),
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
          ),
          Expanded(
            flex: 1, // More space allocation
            child: forecastData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      if (currentWeather.isNotEmpty)
                        ListTile(
                          title: Text('Current Weather'),
                          subtitle: Text(
                              '${currentWeather['weather'][0]['description']} at ${convertKelvinToCelsius(currentWeather['main']['temp']).toStringAsFixed(1)}°C'),
                          leading: Image.network(
                            'http://openweathermap.org/img/wn/${currentWeather['weather'][0]['icon']}.png',
                          ),
                        ),
                    ],
                  ),
          ),

          // forecast list, larger size
          Expanded(
            flex: 6, // More space allocation
            child: forecastData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // align
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "3-Hour Forecast for 5 Days", // subtitle
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 114, 76, 39),
                          ),
                        ),
                      ),
                      Expanded(
                        // ListView.builder fill space
                        child: ListView.builder(
                          itemCount: forecastData.length,
                          itemBuilder: (context, index) {
                            var item = forecastData[index];
                            double tempCelsius =
                                convertKelvinToCelsius(item['main']['temp'])
                                    .toDouble();
                            return ListTile(
                              title: Text('${item['dt_txt']}'), // date and time
                              subtitle: Text(
                                '${item['weather'][0]['description']} at ${tempCelsius.toStringAsFixed(1)}°C',
                              ),
                              trailing: Image.network(
                                'http://openweathermap.org/img/wn/${item['weather'][0]['icon']}.png', // load weather icon
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
