import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherappbd/models/weather_model.dart';
import 'package:weatherappbd/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Api key
  final _weatherService = WeatherService('d99a3b25496cf1ee446b25b4956dcda0');
  Weather? _weather;

  // Fetch Weather for Dhaka
  void _fetchDhakaWeather() async {
    try {
      Weather dhakaWeather = await _weatherService.getWeather("Dhaka, BD");
      setState(() {
        _weather = dhakaWeather;
      });
      print("Temperature in Dhaka: ${_weather?.temperature} °C");
    } catch (e) {
      print("Error: $e");
    }
  }

  // Weather Animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/thunderstromerain.json';
    switch (mainCondition.toLowerCase()) {
      case 'cloud':
        return 'assets/cloudsunnyrain.json';
      case 'thunder':
        return 'assets/thunderstromerain.json';
      default:
        return 'assets/thunderstromerain.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();
    // Fetch weather for Dhaka on startup
    _fetchDhakaWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City Name
            Text(_weather?.cityName ?? "Loading City.."),
            // Animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            // Temperature
            Text("${_weather?.temperature.round()} °C"),
            // Weather Condition
            Text(_weather?.mainCondition ?? " ")
          ],
        ),
      ),
    );
  }
}
